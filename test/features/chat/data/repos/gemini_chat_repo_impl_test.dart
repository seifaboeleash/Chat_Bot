import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/models/chat_message_part_model.dart';
import 'package:chat_bot/features/chat/data/repos/gemini_chat_repo_impl.dart';
import 'package:chat_bot/features/chat/data/services/gemini_chat_service.dart';
import 'package:chat_bot/core/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late GeminiChatRepoImpl geminiChatRepoImpl;
  late MockedGeminiChatServices mockedGeminiChatServices;

  setUp(() {
    mockedGeminiChatServices = MockedGeminiChatServices();
    geminiChatRepoImpl = GeminiChatRepoImpl(
      geminiChatService: mockedGeminiChatServices,
    );
  });
  setUpAll(() {});

  final validMessages = [
    ChatMessageModel(parts: [ChatMessagePartModel(text: 'Hello')], role: 'user'),
  ];

  final validResponse = ChatMessageModel(
    parts: [ChatMessagePartModel(text: 'Hi!')],
    role: 'model',
  );

  // INPUT VALIDATION
  group('Input Validation', () {
    test('should throw if messages list is empty', () {
      expect(
        () => geminiChatRepoImpl.sendMessage(messages: []),
        throwsA(isA<NetworkException>()),
      );

      verifyNever(
        () => mockedGeminiChatServices.sendMessage(
          messages: any(named: 'messages'),
        ),
      );
    });

    test('should throw if message text is empty', () {
      expect(
        () => geminiChatRepoImpl.sendMessage(
          messages: [
            ChatMessageModel(parts: [ChatMessagePartModel(text: '')], role: 'user'),
          ],
        ),
        throwsA(isA<NetworkException>()),
      );

      verifyNever(
        () => mockedGeminiChatServices.sendMessage(
          messages: any(named: 'messages'),
        ),
      );
    });
  });

  // OUTPUT VALIDATION
  group('Output Validation', () {
    test('should throw if response text is empty', () async {
      when(
        () => mockedGeminiChatServices.sendMessage(messages: validMessages),
      ).thenAnswer(
        (_) async => ChatMessageModel(
          parts: [ChatMessagePartModel(text: '')],
          role: 'model',
        ),
      );

      expect(
        () => geminiChatRepoImpl.sendMessage(messages: validMessages),
        throwsException,
      );

      verify(
        () => mockedGeminiChatServices.sendMessage(messages: validMessages),
      ).called(1);
    });
  });

  // SUCCESS CASE
  group('Success Case', () {
    test('should return valid response', () async {
      when(
        () => mockedGeminiChatServices.sendMessage(messages: validMessages),
      ).thenAnswer((_) async => validResponse);

      final result = await geminiChatRepoImpl.sendMessage(
        messages: validMessages,
      );

      expect(result, equals(validResponse));

      verify(
        () => mockedGeminiChatServices.sendMessage(messages: validMessages),
      ).called(1);
    });
  });
}

class MockedGeminiChatServices extends Mock implements GeminiChatService {}
