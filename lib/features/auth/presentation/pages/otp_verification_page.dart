import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mozi_v2/core/constants/route_constants.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/otp_state.dart';
import 'package:mozi_v2/features/auth/presentation/widgets/numeric_keypad_widget.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String purpose;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.purpose,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          if (widget.purpose == 'REGISTRATION') {
            context.push(RouteConstants.authSetPassword, extra: {
              'phone': widget.phoneNumber,
            });
          } else {
            context.go(RouteConstants.home);
          }
        } else if (state is OtpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final otp = context.read<OtpCubit>().currentOtp;
        final secondsLeft =
            state is OtpInitial ? state.secondsRemaining : 0;
        final isLoading = state is OtpLoading;

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
                      Text(
                        'GoMove',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          'Xác thực OTP',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            children: [
                              const TextSpan(
                                  text:
                                      'Mã xác thực đã được gửi đến số '),
                              TextSpan(
                                text: _maskPhone(widget.phoneNumber),
                                style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // 6 OTP boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            final hasDigit = index < otp.length;
                            final isCurrent = index == otp.length;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 46,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isCurrent
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: hasDigit
                                  ? Text(
                                      otp[index],
                                      style:
                                          AppTypography.headlineSmall.copyWith(
                                        color: AppColors.onSurface,
                                      ),
                                    )
                                  : isCurrent
                                      ? Container(
                                          width: 2,
                                          height: 24,
                                          color: AppColors.primary,
                                        )
                                      : null,
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: secondsLeft > 0
                              ? Text(
                                  'Gửi lại mã sau ${secondsLeft}s',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    context.read<OtpCubit>().resendOtp(
                                          widget.phoneNumber,
                                          widget.purpose,
                                        );
                                  },
                                  child: Text(
                                    'Gửi lại OTP',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),
                        // Confirm button
                        GestureDetector(
                          onTap: isLoading || otp.length != 6
                              ? null
                              : () {
                                  context.read<OtpCubit>().verifyOtp(
                                        widget.phoneNumber,
                                        widget.purpose,
                                      );
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: otp.length == 6
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
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'Xác nhận',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: otp.length == 6
                                          ? Colors.white
                                          : AppColors.onSurfaceVariant,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Numeric keypad
                Container(
                  color: AppColors.surfaceContainerHighest.withOpacity(0.6),
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
                  child: NumericKeypadWidget(
                    onDigitTap: (digit) {
                      context.read<OtpCubit>().appendDigit(digit);
                      setState(() {}); // Rebuild to show updated OTP boxes
                    },
                    onBackspace: () {
                      context.read<OtpCubit>().removeDigit();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _maskPhone(String phone) {
    if (phone.length < 7) return phone;
    return '${phone.substring(0, 4)} *** ${phone.substring(phone.length - 3)}';
  }
}
