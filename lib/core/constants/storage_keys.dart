class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';
  static const String userPhone = 'user_phone';
  // key pattern: 'pin_{phoneNumber}'
  static String pinKey(String phone) => 'pin_$phone';
}
