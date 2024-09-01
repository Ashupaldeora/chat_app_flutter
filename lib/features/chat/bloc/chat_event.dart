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
