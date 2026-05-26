import 'package:chat_bot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ChatRobot {
  final WidgetTester tester;

  ChatRobot({required this.tester});

  Future<void> runApp() async {
    await tester.pumpWidget(ChatBot());
    await tester.pumpAndSettle();
  }

  Future<void> enterText({required String text}) async {
    var inputField = find.byType(TextField);
    await tester.enterText(inputField, text);
    await tester.pumpAndSettle();
  }

  Future<void> sendMessage() async {
    var sendButton = find.byIcon(Icons.send_rounded);
    await tester.tap(sendButton);
  }

  Future<void> retrySendingMessage() async {
    var resendButton = find.byIcon(Icons.refresh);
    await tester.tap(resendButton);
    await tester.pumpAndSettle();
  }
}