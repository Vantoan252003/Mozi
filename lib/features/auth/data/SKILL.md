# auth/data/

## models/
user_model.dart       — extends UserEntity, adds fromJson() / toJson()
auth_token_model.dart — extends AuthTokenEntity, adds fromJson() / toJson()

## datasources/
auth_remote_datasource.dart
  sendOtp(phone)        → POST /auth/login  (throws ServerException on failure)
  verifyOtp(phone, otp) → POST /auth/verify-otp → AuthTokenModel
  getProfile()          → GET  /users/me         → UserModel
  refreshToken(token)   → POST /auth/refresh      → AuthTokenModel

auth_local_datasource.dart
  saveTokens(access, refresh) → SecureStorageService.write()
  getAccessToken()            → SecureStorageService.read()
  getRefreshToken()
  clearTokens()
  cacheUser(UserModel)        → Hive userBox
  getCachedUser()             → Hive userBox

## repositories/
auth_repository_impl.dart
  Inject: AuthRemoteDataSource, AuthLocalDataSource
  verifyOtp: call remote → save tokens → get profile → cache user → return entity
  logout: call remote logout (best-effort) → clearTokens() → Hive clear
  Exception mapping: see core/errors/SKILL.md
