// ------------------- With Cubit ------------------------------------
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/models/gemini_message_model.dart';
import 'package:chat_bot/features/chat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_bubble_reciever.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_bubble_sender.dart';
import 'package:chat_bot/features/chat/ui/widgets/custom_app_bar.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_input_text_field.dart';
import 'package:chat_bot/features/chat/ui/widgets/error_bubble.dart';
import 'package:chat_bot/features/chat/ui/widgets/loading_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(ChatInitial(), context.read<ChatRepo>()),
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
  bool _isScrolling = false;

  final List<GeminiMessageModel> _messages = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && !_isScrolling) {
      _isScrolling = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients && mounted) {
          _scrollController
              .animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              )
              .then((_) => _isScrolling = false);
        } else {
          _isScrolling = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is ChatSuccess) {
                      setState(() {
                        _messages.add(state.chatMessage);
                      });
                      _scrollToBottom();
                    } else if (state is ChatFailure) {
                      
                      _scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    bool isLoading = false;
                    String? errorMessage;

                    if (state is ChatLoading) {
                      isLoading = true;
                    } else if (state is ChatFailure) {
                      errorMessage = state.errMsg;
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
                      itemCount:
                          _messages.length +
                          (isLoading || errorMessage != null ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Loading bubble
                        if (isLoading && index == _messages.length) {
                          return loadingBubble();
                        }

                        // Error bubble
                        if (errorMessage != null && index == _messages.length) {
                          return ErrorBubble(
                            errorMessage: errorMessage,
                            onPressed: () => context
                                .read<ChatCubit>()
                                .sendMessages(messages: _messages),
                          );
                        }

                        // Normal message bubble
                        final message = _messages[index];
                        return message.role != "model"
                            ? ChatBubbleSender(text: message.text)
                            : ChatBubbleReciever(text: message.text);
                      },
                    );
                  },
                ),
              ),
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: ChatInput(
                  controller: _controller,
                  onSendMessage: (text) {
                    if (text.trim().isNotEmpty) {
                      final userMessage = GeminiMessageModel(
                        role: "user",
                        text: text,
                        isSuccess: true,
                      );

                      setState(() {
                        _messages.add(userMessage);
                      });

                      context.read<ChatCubit>().sendMessages(
                        messages: _messages,
                      );

                      _controller.clear();
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
}



//      // -- Without CUBIT ------------
// import 'package:chat_bot/features/chat/presentation/widgets/chat_bubble_reciever.dart';
// import 'package:chat_bot/features/chat/presentation/widgets/chat_bubble_sender.dart';
// import 'package:chat_bot/features/chat/presentation/widgets/custom_app_bar.dart';
// import 'package:chat_bot/features/chat/presentation/widgets/chat_input_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Messages> messages = [];
//   void sendMessage(String text) {
//     if (text.trim().isNotEmpty) {
//       setState(() {
//         messages.add(Messages(message: text, isUser: true));
//         controller.clear();
//       });
//     }
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         messages.add(Messages(message: 'Bot reply 👋', isUser: false, isSuccess: true));
//       });
//     });
//     setState(() {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: const CustomAppBar(),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Divider(),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     return message.isUser
//                         ? ChatBubbleSender(text: message.message)
//                         : ChatBubbleReciever(text: message.message);
//                   },
//                 ),
//               ),

//               Positioned(
//                 left: 16.w,
//                 right: 16.w,
//                 bottom: 16.h,
//                 child: ChatInput(
//                   controller: controller,
//                   onSendMessage: (text) => sendMessage(text),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
