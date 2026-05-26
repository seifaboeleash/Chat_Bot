import 'package:chat_bot/core/utils/di.dart';
import 'package:chat_bot/features/chat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_input_text_field.dart';
import 'package:chat_bot/features/chat/ui/widgets/custom_app_bar.dart';
import 'package:chat_bot/features/chat/ui/widgets/send_messages_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Provides [ChatCubit] and renders [ChatScreenView].
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>(),
      child: const ChatScreenView(),
    );
  }
}

class ChatScreenView extends StatefulWidget {
  const ChatScreenView({super.key});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // Fixed: was leaking before
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: const Key('chatScreenScaffold'),
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SendMessageBlocConsumer(
                  scrollController: _scrollController,
                ),
              ),
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: ChatInput(
                  controller: _controller,
                  onSendMessage: (text) {
                    // Cubit owns the message list — just forward the text.
                    context.read<ChatCubit>().sendMessage(text);
                    _controller.clear();
                    if(isAtBottom()){
                      _scrollToBottom();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  bool isAtBottom() {
  return _scrollController.offset >=
      _scrollController.position.maxScrollExtent - 50;
}
}
