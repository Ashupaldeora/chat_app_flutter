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

  const ChatSelectMessage(this.messageId);

  @override
  List<Object> get props => [messageId];
}

final class ChatDeleteMessage extends ChatEvent {
  final String messageId;
  final String receiverId;

  const ChatDeleteMessage(this.messageId, this.receiverId);

  @override
  List<Object> get props => [messageId, receiverId];
}

final class ChatUpdateMessage extends ChatEvent {
  final String messageId;
  final String newMessage;
  final String receiverId;

  const ChatUpdateMessage(this.messageId, this.newMessage, this.receiverId);

  @override
  List<Object> get props => [messageId, newMessage, receiverId];
}
