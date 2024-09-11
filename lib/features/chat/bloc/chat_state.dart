part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

final class ChatFailure extends ChatState {
  final String error;

  const ChatFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

final class ChatMessageSelected extends ChatState {
  final String messageId;
  final bool isSender;
  final String message;

  const ChatMessageSelected(this.messageId, this.isSender, this.message);

  @override
  List<Object> get props => [messageId, isSender, message];
}

final class ChatMessageDeleted extends ChatState {
  final String messageId;

  const ChatMessageDeleted(this.messageId);

  @override
  List<Object> get props => [messageId];
}

final class ChatMessageUpdated extends ChatState {
  final String messageId;
  final String newMessage;

  const ChatMessageUpdated(this.messageId, this.newMessage);

  @override
  List<Object> get props => [messageId, newMessage];
}

final class ChatMessageDeselected extends ChatState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
