import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/models/gemini_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(super.initialState, this.chatRepo);

  final ChatRepo chatRepo;
  Future<void> sendMessages({
    required List<GeminiMessageModel> messages,
  }) async {
    emit(ChatLoading());
    try {
      final chatMessage = await chatRepo.sendMessage(messages: messages);
      emit(ChatSuccess(chatMessage: chatMessage));
    } catch (e) {
      emit(ChatFailure(errMsg: e.toString()));
    }
  }
}












//// import 'package:chat_bot/features/chat/data/models/messages.dart';
// import 'package:chat_bot/features/chat/data/gemini_chat_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';

// part 'chat_state.dart';

// class ChatCubit extends Cubit<ChatState> {
//   final GeminiChatService geminiRepository;
//   ChatCubit(this.geminiRepository) : super(ChatInitial());

  

//   void sendMessage(String text) async {
//     if (text.trim().isEmpty) return;

//     _messages.add(MessageModel(text: text, isUser: true));
//     emit(ChatSuccess(messages: List.from(_messages)));

//     emit(ChatLoading(messages: List.from(_messages)));

//     try {
//       final response = await geminiRepository.sendMessage(text);

//       _messages.add(MessageModel(text: response, isUser: false));

//       emit(ChatSuccess(messages: List.from(_messages)));
//     } catch (e) {
//       _messages.add(
//         MessageModel(
//           text: "some thing went wrong , Please try again",
//           isUser: false,
//         ),
//       );
//       emit(ChatSuccess(messages: List.from(_messages)));
    
//       Future.delayed(const Duration(seconds: 2), () {
//         emit(ChatSuccess(messages: List.from(_messages)));
//       });
//     }
//   }
// }
