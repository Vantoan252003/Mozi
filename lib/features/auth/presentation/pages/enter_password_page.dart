import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';
import 'package:mozi_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/login_cubit.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/login_state.dart';
import 'package:mozi_v2/features/auth/presentation/widgets/numeric_keypad_widget.dart';
import 'package:mozi_v2/features/auth/presentation/widgets/pin_dots_widget.dart';

class EnterPasswordPage extends StatefulWidget {
  final String phoneNumber;
  const EnterPasswordPage({super.key, required this.phoneNumber});

  @override
  State<EnterPasswordPage> createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  String _pin = '';

  void _appendDigit(String digit) {
    if (_pin.length < 6) {
      setState(() => _pin += digit);
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  Future<void> _triggerBiometric() async {
    try {
      final canAuth = await _localAuth.canCheckBiometrics;
      if (!canAuth) return;
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Xác thực để đăng nhập vào Mozi',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated && mounted) {
        context.read<LoginCubit>().currentPhone = widget.phoneNumber;
        await context.read<LoginCubit>().loginWithBiometricPin();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<AuthBloc>().add(LoggedIn(state.userId));
        } else if (state is LoginError) {
          setState(() => _pin = '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.primary),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'GoMove',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Avatar placeholder
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerLow,
                          border: Border.all(
                              color: AppColors.surfaceContainerLowest,
                              width: 4),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x14000000), blurRadius: 8)
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 48,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Đăng nhập',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Chào mừng quay trở lại,\n${widget.phoneNumber}',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // PIN dots
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.outlineVariant.withOpacity(0.1)),
                        ),
                        child: PinDotsWidget(filledCount: _pin.length),
                      ),
                      const SizedBox(height: 16),
                      // Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Quên mật khẩu?',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Đăng nhập bằng OTP',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Biometric button
                      GestureDetector(
                        onTap: _triggerBiometric,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondaryContainer
                                .withOpacity(0.3),
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login button
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is LoginLoading;
                          return GestureDetector(
                            onTap: isLoading || _pin.length != 6
                                ? null
                                : () {
                                    context
                                        .read<LoginCubit>()
                                        .currentPhone = widget.phoneNumber;
                                    context
                                        .read<LoginCubit>()
                                        .loginWithPassword(_pin);
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _pin.length == 6
                                      ? [
                                          AppColors.primaryContainer,
                                          AppColors.onPrimaryFixedVariant,
                                        ]
                                      : [
                                          AppColors.surfaceContainerHigh,
                                          AppColors.surfaceContainerHigh,
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              alignment: Alignment.center,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Đăng nhập',
                                      style:
                                          AppTypography.labelLarge.copyWith(
                                        color: _pin.length == 6
                                            ? Colors.white
                                            : AppColors.onSurfaceVariant,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Numeric keypad at bottom
              Container(
                color: AppColors.surfaceContainerLowest.withOpacity(0.8),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: NumericKeypadWidget(
                  onDigitTap: _appendDigit,
                  onBackspace: _removeDigit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
