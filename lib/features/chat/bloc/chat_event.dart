part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

final class ChatSendButtonPressed extends ChatEvent {
  final String receiverId;
  final String message;

  const ChatSendButtonPressed(
      {required this.receiverId, required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [receiverId, message];
}

class ChatSelectMessage extends ChatEvent {
  final String messageId;
  final bool isSender;
  final String message;

  const ChatSelectMessage(this.messageId, this.isSender, this.message);

  @override
  List<Object> get props => [messageId, isSender, message];
}

final class ChatDeleteMessage extends ChatEvent {
  final String messageId;
  final String receiverId;
  final bool isSender;

  const ChatDeleteMessage(this.messageId, this.receiverId, this.isSender);

  @override
  List<Object> get props => [messageId, receiverId, isSender];
}

final class ChatUpdateMessage extends ChatEvent {
  final String messageId;
  final String newMessage;
  final String receiverId;
  final bool isSender;

  const ChatUpdateMessage(
      this.messageId, this.newMessage, this.receiverId, this.isSender);

  @override
  List<Object> get props => [messageId, newMessage, receiverId, isSender];
}

final class ChatDeselectMessage extends ChatEvent {
  const ChatDeselectMessage();

  @override
  List<Object> get props => [];
}
