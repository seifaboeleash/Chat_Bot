import 'package:chat_bot/features/chat/data/models/gemini_message_model.dart';

abstract class ChatRepo{
  Future<GeminiMessageModel> sendMessage({
    required List<GeminiMessageModel> messages,
  });
}