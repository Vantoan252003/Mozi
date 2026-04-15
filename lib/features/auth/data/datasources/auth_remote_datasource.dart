import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/constants/api_constants.dart';
import 'package:mozi_v2/core/errors/exceptions.dart';
import 'package:mozi_v2/features/auth/data/models/auth_token_model.dart';
import 'package:mozi_v2/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> checkPhone(String phoneNumber);
  Future<void> sendOtp(String phoneNumber, String purpose);
  Future<bool> verifyOtp(String phoneNumber, String otp, String purpose);
  Future<AuthTokenModel> login(String phoneNumber, String password);
  Future<void> register(
      String firstName, String lastName, String phoneNumber, String password);
  Future<UserModel> getProfile();
  Future<void> logout(String userId);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<bool> checkPhone(String phoneNumber) async {
    final response = await _dio.get(
      '${ApiConstants.checkPhone}/$phoneNumber',
    );
    return _extractData<bool>(response);
  }

  @override
  Future<void> sendOtp(String phoneNumber, String purpose) async {
    await _dio.post(
      ApiConstants.sendOtp,
      data: {
        'phoneNumber': phoneNumber,
        'purpose': purpose,
        'userType': 'CUSTOMER',
      },
    );
  }

  @override
  Future<bool> verifyOtp(
      String phoneNumber, String otp, String purpose) async {
    final response = await _dio.post(
      ApiConstants.verifyOtp,
      data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
        'purpose': purpose,
        'userType': 'CUSTOMER',
      },
    );
    return _extractData<bool>(response);
  }

  @override
  Future<AuthTokenModel> login(String phoneNumber, String password) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {
        'emailOrPhone': phoneNumber,
        'password': password,
      },
    );
    final data = _extractData<Map<String, dynamic>>(response);
    return AuthTokenModel.fromJson(data);
  }

  @override
  Future<void> register(
      String firstName, String lastName, String phoneNumber, String password) async {
    await _dio.post(
      ApiConstants.register,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'password': password,
        'userType': 'CUSTOMER',
      },
    );
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await _dio.get(ApiConstants.me);
    final data = _extractData<Map<String, dynamic>>(response);
    return UserModel.fromJson(data);
  }

  @override
  Future<void> logout(String userId) async {
    await _dio.post(
      ApiConstants.logout,
      queryParameters: {'userId': userId},
    );
  }

  T _extractData<T>(Response response) {
    final body = response.data;
    if (body is Map<String, dynamic> && body.containsKey('data')) {
      return body['data'] as T;
    }
    throw ServerException('Unexpected response format',
        statusCode: response.statusCode);
  }
}
