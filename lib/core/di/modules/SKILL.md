# core/di/modules/ — Injectable Modules

## Purpose
Each file in this directory is an `@module abstract class` that tells Injectable
how to construct 3rd-party objects that cannot be annotated directly.

## Files to create

### network_module.dart
Provides: Dio (with full interceptor stack), Connectivity

```
@module
abstract class NetworkModule {
  @singleton
  Dio get dio {
    final d = Dio(BaseOptions(
      baseUrl: AppConfig.instance.baseUrl,
      connectTimeout: Duration(milliseconds: AppConstants.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));
    d.interceptors.addAll([
      AuthInterceptor(secureStorage),   // must inject SecureStorage here
      ErrorInterceptor(),
      LoggingInterceptor(),             // only active in debug/dev
    ]);
    return d;
  }

  @singleton
  Connectivity get connectivity => Connectivity();
}
```

### storage_module.dart
Provides: FlutterSecureStorage, Hive boxes (opened async in setUp)

```
@module
abstract class StorageModule {
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}
// Hive boxes are opened in StorageService.init() during app startup
```

### firebase_module.dart
Provides: FirebaseMessaging, FirebaseAnalytics

```
@module
abstract class FirebaseModule {
  @singleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;
}
```

### socket_module.dart
Provides: SocketService singleton

```
@module
abstract class SocketModule {
  @singleton
  SocketService get socketService => SocketService(
    url: AppConfig.instance.socketUrl,
  );
}
```

### maps_module.dart
Provides: Geolocator (via LocationService wrapper)

## Rules
- Each module file provides one logical group of related singletons
- Do not put business logic in modules — only construction code
- Modules with async setup (Hive) use StorageService.init() in main.dart
