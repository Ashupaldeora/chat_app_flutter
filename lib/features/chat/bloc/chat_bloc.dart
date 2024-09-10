import 'package:bloc/bloc.dart';

import 'package:chat_app_flutter/services/chat/chat_services.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatSendButtonPressed>(_textMessageSent);
    on<ChatSelectMessage>(_messageSelected);
    on<ChatDeleteMessage>(_messageDeleted);
    on<ChatUpdateMessage>(_messageUpdated);
  }

  Future<void> _textMessageSent(
      ChatSendButtonPressed event, Emitter<ChatState> emit) async {
    final senderModel = FireStoreService.currentUserData;
    await ChatServices.chatServices
        .sendTextMessage(senderModel!, event.receiverId, event.message);
  }

  Future<void> _messageSelected(
      ChatSelectMessage event, Emitter<ChatState> emit) async {
    // Emit the selected message ID
    emit(ChatMessageSelected(event.messageId));
  }

  Future<void> _messageDeleted(
      ChatDeleteMessage event, Emitter<ChatState> emit) async {
    try {
      await ChatServices.chatServices
          .deleteMessage(event.messageId, event.receiverId);
      emit(ChatMessageDeleted(event.messageId));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _messageUpdated(
      ChatUpdateMessage event, Emitter<ChatState> emit) async {
    try {
      await ChatServices.chatServices
          .updateMessage(event.messageId, event.newMessage, event.receiverId);
      emit(ChatMessageUpdated(
        event.messageId,
        event.newMessage,
      ));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}
