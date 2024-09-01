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
