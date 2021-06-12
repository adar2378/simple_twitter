part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  AuthenticationFailure(this.errorMessage);
  final String errorMessage;
}

class AuthenticationSuccess extends AuthenticationState {
  AuthenticationSuccess(this.user);
  final User user;
}
