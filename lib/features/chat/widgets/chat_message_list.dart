import 'package:chat_app_flutter/features/chat/widgets/receiver_message_card.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../../../services/chat/chat_services.dart';
import '../../chat/model/message_model.dart';
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

class _ChatMessagesListState extends State<ChatMessagesList> {
  late Stream<List<MessageModel>> chatStream;
  final ScrollController messageController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatStream = ChatServices.chatServices.getChats(widget.receiverId);
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final message = snapshot.data![index];
            final timeSent = DateFormat.Hm().format(message.timeSent);
            if (!message.isSeen &&
                message.receiverId == FirebaseAuth.instance.currentUser!.uid) {
              print(widget.receiverId);
              print(message.receiverId);
              ChatServices.chatServices.updateChatIsSeen(
                message.messageId,
                widget.receiverId,
              );
            }
            if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: message.message,
                timeSent: timeSent,
                isSeen: message.isSeen,
              );
            } else {
              return ReceiverMessageCard(
                  message: message.message, timeSent: timeSent);
            }
          },
        );
      },
    );
  }
}
