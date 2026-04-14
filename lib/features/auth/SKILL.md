# feature/auth — Authentication

## Login Flow
1. User enters phone number → LoginPage
2. App calls SendOtpUseCase → POST /auth/login (backend sends SMS)
3. User enters 6-digit OTP → OtpVerificationPage
4. App calls VerifyOtpUseCase → POST /auth/verify-otp
5. Backend returns { accessToken, refreshToken, user }
6. Tokens saved to FlutterSecureStorage
7. AuthBloc emits Authenticated(user) → router redirects to /home/ride

## Entities
UserEntity {
  id, phone, name?, email?, avatarUrl?, isVerified: bool,
  walletBalance: double, createdAt: DateTime, memberLevel: String
}
AuthTokenEntity {
  accessToken: String, refreshToken: String, expiresAt: DateTime
}

## Repository Interface
AuthRepository {
  sendOtp(phone) → Future<Either<Failure, void>>
  verifyOtp(phone, otp) → Future<Either<Failure, AuthTokenEntity>>
  getCurrentUser() → Future<Either<Failure, UserEntity>>
  logout() → Future<Either<Failure, void>>
  refreshToken(refreshToken) → Future<Either<Failure, AuthTokenEntity>>
}

## Root-Level BLoC: AuthBloc
This BLoC is provided at MaterialApp level (root).
It determines the auth state for the entire app and drives route guards.
Events:
  AppStarted         — check if valid token exists on app launch
  LoggedIn(user)     — emitted after successful OTP verification
  LoggedOut          — clear tokens, disconnect socket, clear caches
States:
  AuthInitial
  AuthLoading
  Authenticated(UserEntity user)
  Unauthenticated({ String? message })

## Other Presentation
Cubit: LoginCubit — handles phone input, validation, loading, error
Cubit: OtpCubit   — handles OTP input, countdown timer (60s), resend

Pages:
  SplashPage           — triggers AppStarted, shows logo animation
  LoginPage            — phone input + country code selector (+84)
  OtpVerificationPage  — 6-box OTP + 60s countdown + resend

Widgets:
  PhoneInputWidget     — Row(country code selector, phone TextField)
  OtpInputWidget       — 6 PinCodeTextField boxes, auto-submit on complete
  CountdownTimerWidget — Animated 60s countdown, fires onResend callback

## Rules
- Tokens: ONLY FlutterSecureStorage — never Hive, never SharedPreferences
- AuthBloc connects SocketService on Authenticated, disconnects on LoggedOut
- After LoggedOut: clear userBox, cartBox, searchBox in StorageService
- RefreshToken flow is handled inside AuthInterceptor — NOT by AuthBloc
