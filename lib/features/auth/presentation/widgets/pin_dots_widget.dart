import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';

/// Row of 6 PIN dots — filled in primary blue, empty in outline-variant
class PinDotsWidget extends StatelessWidget {
  final int filledCount; // 0-6
  final bool isActive; // highlights with a different shade when active

  const PinDotsWidget({
    super.key,
    required this.filledCount,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < filledCount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? AppColors.primary
                : (isActive
                    ? AppColors.outlineVariant
                    : AppColors.surfaceDim),
          ),
        );
      }),
    );
  }
}
