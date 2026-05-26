import 'package:chat_bot/core/utils/di.dart';
import 'package:chat_bot/features/auth/ui/screens/register_screen.dart';
import 'package:chat_bot/firebase_options.dart';
import 'package:chat_bot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });
  setUp(() async {
    await getIt.reset();

    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    getIt.registerSingleton<FirebaseAuth>(mockFirebaseAuth);
    setupGetIt();
  });
  // login flow test
  group('Login Screen Flow Test', () {
    testWidgets('Login Flow Test', (tester) async {
      when(() => mockUser.email).thenReturn('newuser@gmail.com');
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'newuser@gmail.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockUserCredential);
      await tester.pumpWidget(ChatBot());
      await tester.pump();
      expect(find.byKey(const Key('logoSvg')), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('onBoardingContinueButton')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('loginEmailField')),
        'newuser@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginPasswordField')),
        'password123',
      );

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chatScreenScaffold')), findsOneWidget);
    });
    testWidgets('RegisterRow navigates to RegisterScreen', (tester) async {
      await pumpToLoginScreen(tester);

      expect(find.byKey(const Key('loginEmailField')), findsOneWidget);
      expect(find.byKey(const Key('loginPasswordField')), findsOneWidget);

      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });

  // validation test
  group('Validation Test', () {
    //Empty fields
    testWidgets('shows error when both fields are empty', (tester) async {
      await pumpToLoginScreen(tester);

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    // Invalid email or short password
    testWidgets('Show error if email or password is short', (tester) async {
      await pumpToLoginScreen(tester);

      await tester.enterText(find.byKey(const Key('loginEmailField')), 'a@b.c');
      await tester.enterText(
        find.byKey(const Key('loginPasswordField')),
        '123',
      );

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });
    //wrong password
    testWidgets('shows error on wrong password', (tester) async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@gmail.com',
          password: 'wrongpass',
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      await pumpToLoginScreen(tester);

      await tester.enterText(
        find.byKey(const Key('loginEmailField')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginPasswordField')),
        'wrongpass',
      );

      await tester.tap(find.byKey(const Key('loginSubmitButton')));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Wrong password provided.'), findsOneWidget);
    });
    // user not found
    testWidgets('shows error when user not found', (tester) async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'nonexistent@gmail.com',
          password: 'password123',
        ),
      ).thenThrow(FirebaseAuthException(code: 'user-not-found'));
      await pumpToLoginScreen(tester);
      await tester.enterText(
        find.byKey(const Key('loginEmailField')),
        'nonexistent@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginPasswordField')),
        'password123',
      );

      await tester.tap(find.byKey(const Key('loginSubmitButton')));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining('No user found for that email.'),
        findsOneWidget,
      );
    });
    // invalid credential
    testWidgets('shows error on invalid credential', (tester) async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@gmail.com',
          password: 'wrongpass',
        ),
      ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      await pumpToLoginScreen(tester);

      await tester.enterText(
        find.byKey(const Key('loginEmailField')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginPasswordField')),
        'wrongpass',
      );

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining('Email or password is incorrect.'),
        findsOneWidget,
      );
    });
  });
}

Future<void> pumpToLoginScreen(WidgetTester tester) async {
  await tester.pumpWidget(ChatBot());
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('onBoardingContinueButton')));
  await tester.pumpAndSettle();
}
