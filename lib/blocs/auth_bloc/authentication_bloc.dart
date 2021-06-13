import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:twitterapp/repositories/authentication/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial());
  final AuthenticationRepository _authenticationRepository;
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    print(event.toString());
    if (event is AuthenticationLogin) {
      yield* _login(event);
    } else if (event is AuthenticationRegister) {
      yield* _register(event);
    }
  }

  Stream<AuthenticationState> _login(AuthenticationLogin event) async* {
    yield AuthenticationLoading();
    try {
      final user =
          await _authenticationRepository.login(event.email, event.password);
      yield AuthenticationSuccess(user);
    } catch (e) {
      String? errorMessage;
      if (e is AuthException) {
        errorMessage = e.message;
      }
      yield AuthenticationFailure(errorMessage ?? 'Failed to authenticate!');
    }
  }

  Stream<AuthenticationState> _register(AuthenticationRegister event) async* {
    yield (AuthenticationLoading());
    try {
      final user =
          await _authenticationRepository.register(event.email, event.password);
      yield (AuthenticationSuccess(user));
    } catch (e) {
      String? errorMessage;
      if (e is AuthException) {
        errorMessage = e.message;
      }
      yield (AuthenticationFailure(errorMessage ?? 'Failed to register!'));
    }
  }
}
