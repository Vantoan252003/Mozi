import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';

/// Location pill widget shown below the header
class LocationBarWidget extends StatelessWidget {
  const LocationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081A6FE8),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VỊ TRÍ CỦA BẠN',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  '23 Lê Lợi, Q.1, TP. Hồ Chí Minh',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.expand_more, color: AppColors.outlineVariant),
        ],
      ),
    );
  }
}
