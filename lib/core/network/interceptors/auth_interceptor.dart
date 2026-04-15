import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/constants/storage_keys.dart';
import 'package:mozi_v2/core/storage/secure_storage_service.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
