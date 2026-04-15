import 'package:mozi_v2/features/auth/domain/entities/auth_token_entity.dart';

class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.userId,
    required super.userType,
    required super.expiresIn,
    required super.tokenType,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userType: json['userType']?.toString() ?? 'CUSTOMER',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
    );
  }
}
