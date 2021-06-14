import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:twitterapp/repositories/authentication/authentication_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('AuthenticationRepository', () {
    late FirebaseAuth firebaseAuth;
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      firebaseAuth = MockFirebaseAuth();

      authenticationRepository = AuthenticationRepository(
        firebaseAuth,
      );
    });
    final testEmail = 'test@gmail.com';
    final testPassword = '123456';
    group('signInWithEmailAndPassword', () {
      setUp(() {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signInWithEmailAndPassword', () async {
        await firebaseAuth.signInWithEmailAndPassword(
            email: testEmail, password: testPassword);
        verify(
          () => firebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword),
        ).called(1);
      });

      test('succeeds when signInWithEmailAndPassword succeeds', () async {
        expect(
          firebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword),
          completes,
        );
      });

      test(
          'throws AuthException '
          'when signInWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
              email: testEmail, password: testPassword),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.login(testEmail, testPassword),
          throwsA(isA<AuthException>()),
        );
      });
    });
    final mockRepo = MockAuthenticationRepository();
    group('AuthenticationRepository', () {
      setUp(() {
        when(
          () => mockRepo.register(testEmail, testPassword),
        ).thenAnswer((_) => Future.value(MockUser()));
      });
      setUp(() {
        when(
          () => mockRepo.register(testEmail, testPassword),
        ).thenAnswer((_) => Future.value(MockUser()));
      });

      test('calls register', () async {
        await mockRepo.register(testEmail, testPassword);
        verify(
          () => mockRepo.register(testEmail, testPassword),
        ).called(1);
      });

      test('succeeds when register succeeds', () async {
        expect(
          mockRepo.register(testEmail, testPassword),
          completes,
        );
      });

      test(
          'throws AuthException '
          'when createUserWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.register(testEmail, testPassword),
          throwsA(isA<AuthException>()),
        );
      });
    });
  });
}
