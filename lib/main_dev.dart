import 'package:chat_bot/config/app_config.dart';
import 'package:chat_bot/run_app.dart';

void main(){
  AppConfig appConfig = AppConfig.fromEnv(EnvType.development); 
  runChatApp(appConfig);
}