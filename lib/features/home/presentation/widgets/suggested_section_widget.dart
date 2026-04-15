import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';

/// "Just for You" suggested card shown below recent orders
class SuggestedSectionWidget extends StatelessWidget {
  const SuggestedSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DÀNH RIÊNG CHO BẠN',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bạn muốn đi đâu?',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    minimumSize: Size.zero,
                    textStyle: AppTypography.labelSmall,
                  ),
                  child: const Text('Đặt xe ngay'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.electric_moped_rounded,
            size: 80,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
