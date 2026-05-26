import 'package:chat_bot/core/utils/di.dart';
import 'package:chat_bot/features/auth/ui/screens/login_screen.dart';
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

  // register flow test
  group('Register Screen Flow Test', () {
    testWidgets('Register Flow Test', (tester) async {
      when(() => mockUser.email).thenReturn('seif123@gmail.com');
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'seif123@gmail.com',
          password: '1234512345',
        ),
      ).thenAnswer((_) async => mockUserCredential);
      await pumpToRegisterScreen(tester);

      expect(find.byType(RegisterScreen), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('registerEmailField')),
        'seif123@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        '1234512345',
      );

      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chatScreenScaffold')), findsOneWidget);
    });

    testWidgets('LoginRow navigates to LoginScreen', (tester) async {
      // Navigate: Splash → OnBoarding → LoginScreen → tap Register → RegisterScreen → tap Login
      await pumpToLoginScreen(tester);
      expect(find.byKey(const Key('loginEmailField')), findsOneWidget);
      expect(find.byKey(const Key('loginPasswordField')), findsOneWidget);

      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('registerEmailField')), findsOneWidget);
      expect(find.byKey(const Key('registerPasswordField')), findsOneWidget);

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  // validation test
  group('Validation Test', () {
    //Empty fields
    testWidgets('shows error when both fields are empty', (tester) async {
      await pumpToRegisterScreen(tester);

      expect(find.byType(RegisterScreen), findsOneWidget);

      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    // Invalid email or short password
    testWidgets('Show error if email or password is short', (tester) async {
      await pumpToRegisterScreen(tester);

      expect(find.byType(RegisterScreen), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('registerEmailField')),
        'a@b.c',
      );
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        '123',
      );

      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });
    // invalid-credential
    testWidgets('shows error on invalid credential', (tester) async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@gmail.com',
          password: 'wrongpass',
        ),
      ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      await pumpToRegisterScreen(tester);

      await tester.enterText(
        find.byKey(const Key('registerEmailField')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'wrongpass',
      );

      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining('Email or password is incorrect.'),
        findsOneWidget,
      );
    });
    //email-already-in-use
    testWidgets('show error on email-already-in-use ', (tester) async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@gmail.com',
          password: 'password123',
        ),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      await pumpToRegisterScreen(tester);
      await tester.enterText(
        find.byKey(const Key('registerEmailField')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('registerPasswordField')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('registerSubmitButton')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('Email already in use.'), findsOneWidget);
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

Future<void> pumpToRegisterScreen(WidgetTester tester) async {
  await pumpToLoginScreen(tester);
  await tester.tap(find.byKey(const Key('registerButton')));
  await tester.pumpAndSettle();
}
