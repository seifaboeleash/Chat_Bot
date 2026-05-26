import 'package:chat_bot/core/errors/app_exception.dart';
import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/services/gemini_chat_service.dart';

class GeminiChatRepoImpl extends ChatRepo {
  final GeminiChatService _geminiChatService;

  GeminiChatRepoImpl({required GeminiChatService geminiChatService})
    : _geminiChatService = geminiChatService;

  @override
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) async {
    if (messages.isEmpty) {
      throw const NetworkException('Messages list cannot be empty.');
    }

    for (final message in messages) {
      if (message.displayText.trim().isEmpty) {
        throw const NetworkException('Message text cannot be empty.');
      }
      if (message.role.trim().isEmpty) {
        throw const NetworkException('Message role cannot be empty.');
      }
    }

    final response = await _geminiChatService.sendMessage(messages: messages);

    if (response.displayText.trim().isEmpty) {
      throw const ParseException('Received an empty response from the API.');
    }

    return response;
  }
}
