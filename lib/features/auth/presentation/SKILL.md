# auth/presentation/

## bloc/ — AuthBloc
auth_bloc.dart + auth_event.dart + auth_state.dart
On AppStarted: getAccessToken() → if exists → getCurrentUser → emit Authenticated
On LoggedIn:   emit Authenticated, connect socket
On LoggedOut:  logoutUseCase → clearTokens → disconnect socket → clear caches

## cubit/ — LoginCubit, OtpCubit
login_cubit.dart  state: { phone, isPhoneValid, isLoading, errorMessage? }
otp_cubit.dart    state: { otp, isLoading, errorMessage?, canResend, secondsLeft }
  OtpCubit starts a 60-second Timer in the constructor, ticks every second

## pages/
splash_page.dart           — Logo + Lottie, triggers AppStarted on initState
login_page.dart            — Phone input, "Tiếp tục" button, handle LoginCubit states
otp_verification_page.dart — OTP boxes, countdown, resend button

## widgets/
phone_input_widget.dart    — Country code (flag + +84) + phone TextField
otp_input_widget.dart      — Uses pin_code_fields package, 6 boxes
countdown_timer_widget.dart — AnimatedBuilder counting down, "Gửi lại" on zero
