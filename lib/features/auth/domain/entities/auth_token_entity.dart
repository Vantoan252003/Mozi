class AuthTokenEntity {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String userType;
  final int expiresIn;
  final String tokenType;

  const AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.userType,
    required this.expiresIn,
    required this.tokenType,
  });
}
