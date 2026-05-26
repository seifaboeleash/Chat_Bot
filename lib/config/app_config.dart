enum EnvType { development, production }

class AppConfig {
  final EnvType envType;
  final String baseUrl;

  AppConfig({required this.envType, required this.baseUrl});

  factory AppConfig.fromEnv(EnvType envType) {
    switch (envType) {
      case EnvType.development:
        return AppConfig(
          envType: envType,
          baseUrl: "https://api.example.com",
        );
      case EnvType.production:
        return AppConfig(
          envType: envType,
          baseUrl: "https://api.example.com",
        );
    }
  }
}