import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_bubble_reciever.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_bubble_sender.dart';
import 'package:chat_bot/features/chat/ui/widgets/error_bubble.dart';
import 'package:chat_bot/features/chat/ui/widgets/loading_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isLoading,
    required this.errorMessage,
  });

  final ScrollController scrollController;
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final itemCount =
        messages.length + (isLoading || errorMessage != null ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Loading indicator at the end of the list
        if (isLoading && index == messages.length) {
          return const LoadingBubble();
        }

        // Error bubble with retry button
        if (errorMessage != null && index == messages.length) {
          return ErrorBubble(
            errorMessage: errorMessage,
            onPressed: () => context.read<ChatCubit>().retryLastMessage(),
          );
        }

        // Normal message
        final message = messages[index];
        return message.isUser
            ? ChatBubbleSender(text: message.displayText)
            : ChatBubbleReciever(text: message.displayText);
      },
    );
  }
}
