import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String? message;

  AuthException(this.message);
}

class AuthenticationRepository {
  AuthenticationRepository(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  Future<User> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = _firebaseAuth.currentUser;
      if (user != null)
        return user;
      else
        throw (AuthException('Something went wrong!'));
    } on FirebaseAuthException catch (e) {
      throw (AuthException(_handleFirebaseException(e)));
    } catch (e, st) {
      throw (AuthException('Error: $e, Stacktrace: $st'));
    }
  }

  Future<User> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = _firebaseAuth.currentUser;
      if (user != null)
        return user;
      else
        throw (AuthException('Something went wrong!'));
    } on FirebaseAuthException catch (e) {
      throw (AuthException(_handleFirebaseException(e)));
    } catch (e, st) {
      throw (AuthException('Error: $e, Stacktrace: $st'));
    }
  }

  bool isLoggedIn() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  User? getCurrentUser() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  String _handleFirebaseException(FirebaseAuthException authException) {
    if (authException.code == 'user-not-found') {
      return 'User with this email does not exist.';
    } else if (authException.code == 'wrong-password') {
      return 'Wrong password provided.';
    } else if (authException.code == 'weak-password') {
      return 'The provided password is too weak.';
    } else if (authException.code == 'email-already-in-use' ||
        authException.code == 'credential-already-in-use') {
      return 'This email is already in use with other user.';
    } else {
      return authException.message ?? 'Something went wrong!';
    }
  }
}
