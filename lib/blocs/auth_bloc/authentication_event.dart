part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationRegister extends AuthenticationEvent {
  AuthenticationRegister(this.email, this.password);
  final String email;
  final String password;
}

class AuthenticationLogin extends AuthenticationEvent {
  AuthenticationLogin(this.email, this.password);
  final String email;
  final String password;
}
