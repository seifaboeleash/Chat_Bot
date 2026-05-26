import 'package:chat_bot/core/constants/app_constants.dart';
import 'package:chat_bot/core/networking/dio_api_client.dart';
import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:dio/dio.dart';


class GeminiChatService {
  final DioApiClient _apiClient;

  GeminiChatService({required DioApiClient apiClient})
    : _apiClient = apiClient;

  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) async {
    dynamic exception;
    for (int i = 0; i < 3; i++) {
      try {
        var response = await _apiClient.post(
          '/gemini-3-flash-preview:generateContent',
          data: {
            "contents": messages.map((message) => message.toJson()).toList(),
          },
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "x-goog-api-key": AppConstants.geminiApiKey,
            },
          ),
        );
        return ChatMessageModel.fromJson(response.data);
      } catch (e) {
        exception = e;
      }
    }
    throw exception;
  }
}