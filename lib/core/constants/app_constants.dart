import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/';
}
