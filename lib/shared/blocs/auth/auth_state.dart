part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

final class AuthSuccess extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
