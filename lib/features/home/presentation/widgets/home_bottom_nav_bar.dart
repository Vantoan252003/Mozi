import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';

/// Custom bottom navigation bar for the home screen
class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Trang chủ'),
      (Icons.directions_car_rounded, Icons.directions_car_outlined, 'Xe'),
      (Icons.restaurant_rounded, Icons.restaurant_outlined, 'Đồ ăn'),
      (Icons.local_activity_rounded, Icons.local_activity_outlined, 'Voucher'),
      (Icons.person_rounded, Icons.person_outlined, 'Tôi'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A6FE8),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = currentIndex == index;
              final item = items[index];
              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.surfaceContainerLow
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? item.$1 : item.$2,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.outline,
                        size: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.$3,
                        style: AppTypography.labelSmall.copyWith(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.outline,
                          letterSpacing: 0.5,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
