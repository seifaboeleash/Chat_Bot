import 'package:chat_bot/config/app_config.dart';
import 'package:chat_bot/core/utils/di.dart';
import 'package:chat_bot/firebase_options.dart';
import 'package:chat_bot/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

runChatApp(AppConfig appConfig) async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  setupGetIt();
  runApp(const ChatBot());
}