import 'package:chat_bot/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_bot/main.dart';

void main() {
  testWidgets('App launch smoke test - reaches SplashScreen', (WidgetTester tester) async {
    // Set a realistic viewport size matching the design size (375x812) to prevent layout overflows.
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatBot());

    // Verify that SplashScreen is active by finding the logo image by key and type.
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byKey(const Key('logoSvg')), findsOneWidget);

    // Advance the virtual clock by 3 seconds to fire the Splash transition timer.
    await tester.pump(const Duration(seconds: 3));

    // Settle the navigation transition to the OnBoardingScreen.
    await tester.pumpAndSettle();
  });
}
