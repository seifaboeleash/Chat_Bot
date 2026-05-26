import 'package:chat_bot/core/networking/dio_api_client.dart';
import 'package:chat_bot/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/repos/gemini_chat_repo_impl.dart';
import 'package:chat_bot/features/chat/data/services/gemini_chat_service.dart';
import 'package:chat_bot/features/chat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<DioApiClient>(DioApiClient());

  getIt.registerSingleton<GeminiChatService>(
    GeminiChatService(apiClient: getIt<DioApiClient>()),
  );

  getIt.registerSingleton<ChatRepo>(
    GeminiChatRepoImpl(geminiChatService: getIt<GeminiChatService>()),
  );

  // ChatCubit only depends on the ChatRepo abstraction — not the service directly.
  getIt.registerFactory<ChatCubit>(
    () => ChatCubit(chatRepo: getIt<ChatRepo>()),
  );

  // Auth — only register FirebaseAuth if a test hasn't already injected a mock.
  if (!getIt.isRegistered<FirebaseAuth>()) {
    getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  }
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<FirebaseAuth>()));
}
