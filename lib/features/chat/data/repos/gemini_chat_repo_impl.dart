import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/services/gemini_chat_service.dart';
import 'package:chat_bot/features/chat/data/models/gemini_message_model.dart';


class GeminiChatRepoImpl extends ChatRepo{
  GeminiChatService _geminiChatService = GeminiChatService();
  
  @override
  Future<GeminiMessageModel> sendMessage({required List<GeminiMessageModel> messages}) {
    return _geminiChatService.sendMessages(messages: messages);
  }
  
}