import 'package:chat_app_flutter/features/chat/widgets/receiver_message_card.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../../services/chat/chat_services.dart';
import '../../../services/globalkey_manager/key_manager.dart';
import '../../chat/model/message_model.dart';
import '../bloc/chat_bloc.dart';
import 'my_message_card.dart';

class ChatMessagesList extends StatefulWidget {
  final String receiverId;

  const ChatMessagesList({
    super.key,
    required this.receiverId,
  });

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

final key = GlobalKey<SnappableState>();

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController messageController = ScrollController();
  late Stream<List<MessageModel>> chatStream;

  @override
  void initState() {
    chatStream = ChatServices.chatServices.getChats(widget.receiverId);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return StreamBuilder<List<MessageModel>>(
          stream: chatStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Chats to display"),
              );
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              messageController
                  .jumpTo(messageController.position.maxScrollExtent);
            });
            return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final message = snapshot.data![index];
                final timeSent = DateFormat.Hm().format(message.timeSent);
                final isSelected = state is ChatMessageSelected &&
                    state.messageId == message.messageId;
                if (!message.isSeen &&
                    message.receiverId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ChatServices.chatServices.updateChatIsSeen(
                    message.messageId,
                    widget.receiverId,
                  );
                }
                final isSender =
                    message.senderId == FirebaseAuth.instance.currentUser!.uid;
                final snappableKey = GlobalKey<SnappableState>();

                // Register the key with the GlobalKeyManager
                GlobalKeyManager.registerKey(message.messageId, snappableKey);
                return Snappable(
                  key: snappableKey,
                  duration: Duration(milliseconds: 2500),
                  onSnapped: () {
                    context.read<ChatBloc>().add(ChatDeleteMessage(
                        (state as ChatMessageSelected).messageId,
                        widget.receiverId,
                        isSender));
                  },
                  child: GestureDetector(
                    onTap: () {
                      context.read<ChatBloc>().add(const ChatDeselectMessage());
                    },
                    onLongPress: () {
                      context.read<ChatBloc>().add(
                            isSelected
                                ? const ChatDeselectMessage()
                                : ChatSelectMessage(message.messageId, isSender,
                                    message.message),
                          );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      color: isSelected
                          ? Colors.purpleAccent.withOpacity(0.1)
                          : Colors.transparent,
                      child: message.senderId ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? MyMessageCard(
                              message: message.message,
                              timeSent: timeSent,
                              isSeen: message.isSeen,
                            )
                          : ReceiverMessageCard(
                              message: message.message, timeSent: timeSent),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
