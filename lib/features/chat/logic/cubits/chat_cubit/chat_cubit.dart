import 'package:chat_bot/core/errors/app_exception.dart';
import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo _chatRepo;

  /// Internal mutable list — never exposed directly to the UI.
  final List<ChatMessageModel> _messages = [];

  ChatCubit({required ChatRepo chatRepo})
    : _chatRepo = chatRepo,
      super(const ChatInitial());

  /// Sends [text] as the next user message and awaits the model's reply.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(
      ChatMessageModel.fromUserMessage(text),
    );
    emit(ChatLoading(messages: List.unmodifiable(_messages)));

    try {
      final reply = await _chatRepo.sendMessage(messages: _messages);
      _messages.add(reply);
      emit(ChatSuccess(messages: List.unmodifiable(_messages)));
    } catch (e) {
      emit(
        ChatFailure(
          messages: List.unmodifiable(_messages),
          errMsg: _mapError(e),
        ),
      );
    }
  }

  /// Re-sends with the existing message history (used by the retry button).
  Future<void> retryLastMessage() async {
    if (_messages.isEmpty) return;
    emit(ChatLoading(messages: List.unmodifiable(_messages)));
    try {
      final reply = await _chatRepo.sendMessage(messages: _messages);
      _messages.add(reply);
      emit(ChatSuccess(messages: List.unmodifiable(_messages)));
    } catch (e) {
      emit(
        ChatFailure(
          messages: List.unmodifiable(_messages),
          errMsg: _mapError(e),
        ),
      );
    }
  }

  String _mapError(Object e) => switch (e) {
    NetworkException() => 'No internet connection. Check your network.',
    ServerException(statusCode: 429) =>
      'Rate limit reached. Please try again later.',
    ServerException(:final message) => message,
    ParseException(:final message) => message,
    _ => e.toString(),
  };
}
