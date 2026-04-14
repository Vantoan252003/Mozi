# core/network/ — HTTP Networking

## Purpose
Houses the Dio client factory and network connectivity checker.
All actual API calls are made through DataSources, not here.

## Files to create

### api_client_factory.dart
Factory that constructs the fully-configured Dio instance.
Called from NetworkModule in DI.

```
class ApiClientFactory {
  /// Creates Dio with base options. Interceptors injected by NetworkModule.
  static Dio create({
    required String baseUrl,
    required FlutterSecureStorage secureStorage,
    bool enableLogging = !kReleaseMode,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeoutMs),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'vi',
      },
    ));

    dio.interceptors.addAll([
      AuthInterceptor(dio: dio, secureStorage: secureStorage),
      ErrorInterceptor(),
      if (enableLogging) LoggingInterceptor(),
    ]);

    return dio;
  }
}
```

### network_info.dart
Abstraction over connectivity_plus.

```
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get onConnectivityChanged;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
```

## Rules
- Dio instance is a singleton — never instantiate Dio outside of DI module
- Interceptors are added in ORDER: Auth → Error → Logging
- NetworkInfo is used by DataSources before making calls when offline behaviour matters
