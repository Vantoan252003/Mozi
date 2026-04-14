# core/network/interceptors/ — Dio Interceptors

## Files to create

### auth_interceptor.dart
Attaches Bearer token to every request. Handles 401 by refreshing token.

```
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;
  final _queue = <RequestOptions>[];

  AuthInterceptor({required Dio dio, required FlutterSecureStorage storage})
      : _dio = dio, _storage = storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: SecureStorageKeys.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_isRefreshing) {
        _queue.add(err.requestOptions);
        return; // will retry after refresh
      }
      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry original + queued requests
          final token = await _storage.read(key: SecureStorageKeys.accessToken);
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(err.requestOptions);
          handler.resolve(response);
        } else {
          // Refresh failed → force logout
          handler.reject(DioException(
            requestOptions: err.requestOptions,
            type: DioExceptionType.unknown,
            error: TokenRefreshFailedException(),
          ));
        }
      } finally {
        _isRefreshing = false;
        _queue.clear();
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: SecureStorageKeys.refreshToken);
      if (refreshToken == null) return false;
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': null}), // skip auth on this call
      );
      final newAccess  = response.data['accessToken']  as String;
      final newRefresh = response.data['refreshToken'] as String;
      await _storage.write(key: SecureStorageKeys.accessToken,  value: newAccess);
      await _storage.write(key: SecureStorageKeys.refreshToken, value: newRefresh);
      return true;
    } catch (_) {
      return false;
    }
  }
}
```

### error_interceptor.dart
Maps DioException types to app-level Exception types thrown to DataSource.

```
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception mapped;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      mapped = const TimeoutException();
    } else if (err.type == DioExceptionType.connectionError) {
      mapped = const NetworkException();
    } else if (err.response != null) {
      final status = err.response!.statusCode ?? 0;
      final msg = err.response!.data['message'] as String? ?? 'Server error';
      if (status == 401) mapped = const UnauthorizedException();
      else if (status == 404) mapped = NotFoundException(message: msg);
      else if (status == 400) mapped = BadRequestException(message: msg);
      else mapped = ServerException(message: msg, statusCode: status);
    } else {
      mapped = const NetworkException();
    }
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: mapped,
    ));
  }
}
```

### logging_interceptor.dart
Logs requests and responses. Disabled in release builds.

```
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    if (kDebugMode) debugPrint('[→] ${o.method} ${o.uri}');
    h.next(o);
  }
  @override
  void onResponse(Response r, ResponseInterceptorHandler h) {
    if (kDebugMode) debugPrint('[←] ${r.statusCode} ${r.requestOptions.uri}');
    h.next(r);
  }
  @override
  void onError(DioException e, ErrorInterceptorHandler h) {
    if (kDebugMode) debugPrint('[✗] ${e.message} ${e.requestOptions.uri}');
    h.next(e);
  }
}
```

## Rules
- AuthInterceptor uses a boolean lock + queue to prevent concurrent refresh calls
- NEVER skip AuthInterceptor by default — use Options(headers: {'Authorization': null}) only for the refresh call itself
- LoggingInterceptor MUST check kDebugMode — never log in release builds
- ErrorInterceptor always re-throws a typed app Exception, never a raw DioException
