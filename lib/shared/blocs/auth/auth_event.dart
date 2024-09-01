part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class AuthCreateAccountPressed extends AuthEvent {
  final String name, email, password;

  const AuthCreateAccountPressed(
      {required this.name, required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [name, email, password];
}

final class AuthLoginPressed extends AuthEvent {
  final String email, password;

  const AuthLoginPressed({required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

final class AuthSignOutPressed extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
