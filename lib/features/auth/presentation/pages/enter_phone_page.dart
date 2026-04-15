import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mozi_v2/core/constants/route_constants.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/login_cubit.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/login_state.dart';

class EnterPhonePage extends StatefulWidget {
  const EnterPhonePage({super.key});

  @override
  State<EnterPhonePage> createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends State<EnterPhonePage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginPhoneChecked) {
          if (state.phoneExists) {
            // Existing user → password screen
            context.push(RouteConstants.authPassword,
                extra: _controller.text.trim());
          } else {
            // New user → send OTP then go to OTP screen
            context
                .read<LoginCubit>()
                .sendOtpForRegistration(_controller.text.trim());
          }
        } else if (state is LoginOtpSent) {
          context.push(RouteConstants.authOtp, extra: {
            'phone': _controller.text.trim(),
            'purpose': 'REGISTRATION',
          });
        } else if (state is LoginError) {
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
        body: Stack(
          children: [
            // Kinetic dot background
            Positioned.fill(
              child: CustomPaint(painter: _KineticBgPainter()),
            ),
            SafeArea(
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
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero Image Placeholder
                          Container(
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFD8E2FF),
                                  Color(0xFFAEC6FF),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.directions_car_rounded,
                                size: 80,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Headline
                          Text(
                            'Chào mừng bạn!',
                            style: AppTypography.headlineLarge.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nhập số điện thoại để tiếp tục.',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Phone label
                          Text(
                            'SỐ ĐIỆN THOẠI',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Phone input
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                // Country code
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: AppColors.outlineVariant,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFDA251D),
                                              Color(0xFFDA251D),
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '★',
                                            style: TextStyle(
                                              color: Color(0xFFFFFF00),
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+84',
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Phone text field
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    autofocus: true,
                                    keyboardType: TextInputType.phone,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '000 000 000',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Legal text
                          RichText(
                            text: TextSpan(
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              children: const [
                                TextSpan(
                                    text:
                                        'Bằng cách tiếp tục, bạn đồng ý với '),
                                TextSpan(
                                  text: 'Điều khoản & Chính sách',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' của chúng tôi.'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // CTA Button
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              final isLoading = state is LoginLoading;
                              return GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () {
                                        final phone =
                                            _controller.text.trim();
                                        if (phone.isNotEmpty) {
                                          context
                                              .read<LoginCubit>()
                                              .checkPhone(phone);
                                        }
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
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
                                        color: Color(0x331A6FE8),
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
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Tiếp tục',
                                          style:
                                              AppTypography.labelLarge.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 40),
                          // Help footer
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.help_outline,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'BẠN CẦN HỖ TRỢ?',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KineticBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A6FE8).withOpacity(0.05)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
