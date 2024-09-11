import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:chat_app_flutter/services/chat/chat_services.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatSendButtonPressed>(_textMessageSent);
    on<ChatSelectMessage>(_messageSelected);
    on<ChatDeleteMessage>(_messageDeleted);
    on<ChatUpdateMessage>(_messageUpdated);
    on<ChatDeselectMessage>(_deselectMessage);
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
    emit(ChatMessageSelected(event.messageId, event.isSender, event.message));
  }

  Future<void> _messageDeleted(
      ChatDeleteMessage event, Emitter<ChatState> emit) async {
    try {
      await ChatServices.chatServices
          .deleteMessage(event.messageId, event.receiverId, event.isSender);
      emit(ChatMessageDeleted(event.messageId));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _messageUpdated(
      ChatUpdateMessage event, Emitter<ChatState> emit) async {
    try {
      await ChatServices.chatServices.editMessage(
          messageId: event.messageId,
          newMessage: event.newMessage,
          receiverId: event.receiverId,
          isSender: event.isSender);
      emit(ChatMessageUpdated(
        event.messageId,
        event.newMessage,
      ));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  void _deselectMessage(ChatDeselectMessage event, Emitter<ChatState> emit) {
    emit(ChatMessageDeselected());
  }

  @override
  void onChange(Change<ChatState> change) {
    // TODO: implement onChange
    super.onChange(change);
    log(change.toString());
  }
}
