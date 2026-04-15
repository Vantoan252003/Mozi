import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/errors/exceptions.dart';

@injectable
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      throw NetworkException();
    }

    final statusCode = err.response?.statusCode;
    final message = _extractMessage(err.response?.data) ??
        err.message ??
        'An unexpected error occurred';

    throw ServerException(message, statusCode: statusCode);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString();
    }
    return null;
  }
}
