# 🤖 ChatBot — AI Chat Assistant (Flutter)

A mobile AI chat application built with Flutter, powered by **Google's Gemini API**, following **Clean Architecture** and the **BLoC/Cubit** pattern. Features a smooth onboarding flow and a responsive, modular chat UI.

<!-- Optional: add a banner or screenshot collage here -->
<!-- ![App Screenshots](screenshots/banner.png) -->

## ✨ Features

- 💬 **AI Conversations** — Real-time chat powered by Google's Gemini API
- 🔄 **Retry Handling** — Automatic retry logic on network failures, with manual retry option in the UI
- 📱 **Responsive UI** — Adapts across screen sizes using `flutter_screenutil`
- 🎨 **Onboarding Flow** — Smooth splash and onboarding experience for first-time users
- ✅ **Fully Tested** — Unit test coverage for the chat data layer, zero lint issues

## 🏗️ Architecture

This project follows **Clean Architecture** with a **feature-first** folder structure, separating each feature into `data`, `logic`, and `ui` layers:

```
lib/
├── config/              # App-level configuration
├── core/
│   ├── constants/       # App-wide constants
│   ├── errors/          # Custom exception types
│   ├── networking/      # Dio API client wrapper
│   ├── theme/           # Colors, text styles
│   └── utils/           # Dependency injection (get_it) setup
├── features/
│   ├── chat/            # Core chatbot feature
│   │   ├── data/        # Models, repositories, Gemini API service
│   │   ├── logic/       # ChatCubit — state management
│   │   └── ui/          # Chat screen & widgets
│   ├── on_boarding/     # First-launch onboarding
│   └── splash/          # Splash screen
└── main.dart
```

**State Management:** `flutter_bloc` (Cubit)
**Dependency Injection:** `get_it`
**Networking:** `dio`, with a custom retry-enabled service layer for the Gemini API

## 🛠️ Tech Stack

| Category | Package |
|---|---|
| Framework | Flutter (Dart `^3.9.2`) |
| State Management | `flutter_bloc` |
| Dependency Injection | `get_it` |
| Networking | `dio` |
| Environment Config | `flutter_dotenv` |
| UI / Styling | `flutter_screenutil`, `google_fonts`, `gap`, `flutter_svg` |
| Testing | `flutter_test`, `integration_test`, `mocktail` |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (`^3.9.2` or later)
- A [Google AI Studio](https://aistudio.google.com/) API key for Gemini

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/chat_bot.git
   cd chat_bot
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   Copy the example env file and add your Gemini API key:
   ```bash
   cp .env.example .env
   ```
   Then edit `.env`:
   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
flutter test
flutter analyze
```

Both currently run clean with zero issues.


## 📄 License

This project is for educational/portfolio purposes.

## 👤 Author

**Seif Abo Eleash** — Flutter Developer
