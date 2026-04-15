import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mozi_v2/core/constants/route_constants.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';
import 'package:mozi_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/set_password_cubit.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/set_password_state.dart';
import 'package:mozi_v2/features/auth/presentation/widgets/numeric_keypad_widget.dart';
import 'package:mozi_v2/features/auth/presentation/widgets/pin_dots_widget.dart';

class SetPasswordPage extends StatelessWidget {
  final String phoneNumber;

  const SetPasswordPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetPasswordCubit, SetPasswordState>(
      listener: (context, state) {
        if (state is SetPasswordSuccess) {
          // Auto-login done inside cubit — trigger AuthBloc
          context.read<AuthBloc>().add(LoggedIn(phoneNumber));
          context.go(RouteConstants.home);
        } else if (state is SetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubitState =
            state is SetPasswordInitial ? state : const SetPasswordInitial();
        final isLoading = state is SetPasswordLoading;

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
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
                    padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thiết lập mật khẩu',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nhập 6 chữ số để bảo mật tài khoản của bạn.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Bento: New password card
                        _PinFieldCard(
                          label: 'MẬT KHẨU MỚI',
                          filledCount: cubitState.newPin.length,
                          isActive: !cubitState.isConfirmActive,
                        ),
                        const SizedBox(height: 16),
                        // Bento: Confirm password card
                        _PinFieldCard(
                          label: 'XÁC NHẬN MẬT KHẨU',
                          filledCount: cubitState.confirmPin.length,
                          isActive: cubitState.isConfirmActive,
                          labelColor: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        // Hint
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                color: AppColors.tertiary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Sử dụng các con số dễ nhớ nhưng bảo mật.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // CTA
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  context
                                      .read<SetPasswordCubit>()
                                      .submit(
                                        firstName: 'Mozi', // placeholder
                                        lastName: 'User',
                                        phoneNumber: phoneNumber,
                                      );
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryContainer,
                                  AppColors.onPrimaryFixedVariant,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x221A6FE8),
                                  blurRadius: 32,
                                  offset: Offset(0, 8),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'Hoàn tất đăng ký',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Keypad at bottom
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest.withOpacity(0.9),
                    border: const Border(
                      top: BorderSide(
                          color: AppColors.outlineVariant, width: 0.5),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: NumericKeypadWidget(
                    onDigitTap: (digit) =>
                        context.read<SetPasswordCubit>().appendDigit(digit),
                    onBackspace: () =>
                        context.read<SetPasswordCubit>().removeDigit(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PinFieldCard extends StatelessWidget {
  final String label;
  final int filledCount;
  final bool isActive;
  final Color labelColor;

  const _PinFieldCard({
    required this.label,
    required this.filledCount,
    required this.isActive,
    this.labelColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.primary.withOpacity(0.05)
                : Colors.transparent,
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isActive ? labelColor : AppColors.onSurfaceVariant,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          PinDotsWidget(filledCount: filledCount, isActive: isActive),
        ],
      ),
    );
  }
}
