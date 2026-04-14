# auth/domain/

## entities/
user_entity.dart — id, phone, name?, email?, avatarUrl?, isVerified, walletBalance, memberLevel
auth_token_entity.dart — accessToken, refreshToken, expiresAt
  computed: bool get isExpired => DateTime.now().isAfter(expiresAt)

## repositories/
auth_repository.dart — abstract, all methods return Future<Either<Failure, T>>
  sendOtp(String phone)
  verifyOtp(String phone, String otp) → AuthTokenEntity
  getCurrentUser() → UserEntity
  logout()
  refreshToken(String refreshToken) → AuthTokenEntity

## usecases/
send_otp_usecase.dart           — call(String phone)
verify_otp_usecase.dart         — call({required String phone, required String otp})
get_current_user_usecase.dart   — call()
logout_usecase.dart             — call()
refresh_token_usecase.dart      — call(String refreshToken)
  Note: RefreshTokenUseCase is called by AuthInterceptor directly, not by BLoC
