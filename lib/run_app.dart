import 'package:chat_bot/config/app_config.dart';
import 'package:chat_bot/core/utils/di.dart';
import 'package:chat_bot/main.dart';
import 'package:flutter/material.dart';

runChatApp(AppConfig appConfig) async{
    WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();
  runApp(const ChatBot());
}