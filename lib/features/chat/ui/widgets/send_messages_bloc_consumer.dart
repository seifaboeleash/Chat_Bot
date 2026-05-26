import 'package:chat_bot/features/chat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_bot/features/chat/ui/widgets/messages_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageBlocConsumer extends StatelessWidget {
  const SendMessageBlocConsumer({super.key, required this.scrollController});

  final ScrollController scrollController;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // Scroll to bottom whenever new content arrives.
        _scrollToBottom();
      },
      builder: (context, state) {
        return MessagesListView(
          scrollController: scrollController,
          messages: state.messages,
          isLoading: state is ChatLoading,
          errorMessage: state is ChatFailure ? state.errMsg : null,
        );
      },
    );
  }
}
