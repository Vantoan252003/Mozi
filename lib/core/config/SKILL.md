# core/config/ — Environment Configuration

## Purpose
Reads environment variables injected at build time via `--dart-define` flags
and exposes them as a typed singleton. Manages build flavors.

## Files to create

### app_config.dart
```
class AppConfig {
  static late final AppConfig _instance;
  static AppConfig get instance => _instance;

  final String baseUrl;
  final String socketUrl;
  final String googleMapsApiKey;
  final String firebaseProjectId;
  final String momoPartnerCode;
  final String zalopayAppId;
  final AppFlavor flavor;

  factory AppConfig.fromEnvironment() { ... }
  static void initialize() { _instance = AppConfig.fromEnvironment(); }
}
```

### flavor_config.dart
```
enum AppFlavor { dev, staging, production }

class FlavorConfig {
  static bool get isDev       => AppConfig.instance.flavor == AppFlavor.dev;
  static bool get isProduction => AppConfig.instance.flavor == AppFlavor.production;
}
```

## Environment Variables (injected via --dart-define)
```
BASE_URL           = https://api.gomove.vn/v1      (or dev URL)
SOCKET_URL         = wss://socket.gomove.vn
GOOGLE_MAPS_KEY    = AIzaSy...
FIREBASE_PROJECT   = gomove-prod
MOMO_PARTNER_CODE  = MOMO_PARTNER
ZALOPAY_APP_ID     = 2553
FLAVOR             = dev | staging | production
```

## Usage
```dart
// In main.dart:
AppConfig.initialize();
runApp(const GoMoveApp());

// Anywhere:
final baseUrl = AppConfig.instance.baseUrl;
```

## Rules
- Call AppConfig.initialize() as first line of main() before any other setup
- Never hardcode URLs — always read from AppConfig
- .env file is gitignored; only .env.example is committed
