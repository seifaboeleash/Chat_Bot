part of 'chat_cubit.dart';

sealed class ChatState {
  final List<ChatMessageModel> messages;
  const ChatState({this.messages = const []});
}

final class ChatInitial extends ChatState {
  const ChatInitial() : super(messages: const []);
}

final class ChatLoading extends ChatState {
  const ChatLoading({required super.messages});
}

final class ChatSuccess extends ChatState {
  const ChatSuccess({required super.messages});
}

final class ChatFailure extends ChatState {
  final String errMsg;
  const ChatFailure({required super.messages, required this.errMsg});
}
