import 'package:bloc/bloc.dart';

import 'package:chat_app_flutter/services/chat/chat_services.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatSendButtonPressed>(_textMessageSent);
  }

  Future<void> _textMessageSent(
      ChatSendButtonPressed event, Emitter<ChatState> emit) async {
    final senderModel = FireStoreService.currentUserData;
    await ChatServices.chatServices
        .sendTextMessage(senderModel!, event.receiverId, event.message);
  }
}
