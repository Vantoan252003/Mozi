// API base URL and all auth endpoint paths
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.0.102:8080';

  // Auth — Rider
  static const String checkPhone = '/api/v1/auth/rider/check-phone';
  static const String sendOtp = '/api/v1/auth/rider/otp/send';
  static const String verifyOtp = '/api/v1/auth/rider/otp/verify';
  static const String register = '/api/v1/auth/rider/register';
  static const String login = '/api/v1/auth/rider/login';
  static const String logout = '/api/v1/auth/rider/logout';
  static const String me = '/api/v1/auth/rider/me';
  static const String changePassword = '/api/v1/auth/rider/change-password';
}
