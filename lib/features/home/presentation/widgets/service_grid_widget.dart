import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';

/// A single bento-style service card in the 2×2 grid
class ServiceCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconBg;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback onTap;

  const ServiceCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconBg,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: iconBg.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            // Label column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(color: titleColor),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(color: subtitleColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 2×2 grid of service cards
class ServiceGridWidget extends StatelessWidget {
  const ServiceGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.25,
      children: [
        ServiceCardWidget(
          title: 'Đặt xe',
          subtitle: 'Di chuyển nhanh',
          icon: Icons.directions_car_rounded,
          bgColor: AppColors.primaryFixed,
          iconBg: AppColors.primary,
          titleColor: AppColors.onPrimaryFixed,
          subtitleColor: AppColors.onPrimaryFixedVariant,
          onTap: () {},
        ),
        ServiceCardWidget(
          title: 'Đồ ăn',
          subtitle: 'Giao ngay 20p',
          icon: Icons.restaurant_rounded,
          bgColor: AppColors.tertiaryFixed,
          iconBg: AppColors.tertiaryContainer,
          titleColor: AppColors.onTertiaryFixed,
          subtitleColor: AppColors.onTertiaryFixedVariant,
          onTap: () {},
        ),
        ServiceCardWidget(
          title: 'Giao hàng',
          subtitle: 'An tâm, giá rẻ',
          icon: Icons.inventory_2_rounded,
          bgColor: AppColors.emeraldLight,
          iconBg: AppColors.emeraldDark,
          titleColor: const Color(0xFF064E3B),
          subtitleColor: const Color(0xFF047857),
          onTap: () {},
        ),
        ServiceCardWidget(
          title: 'BeMarket',
          subtitle: 'Đi chợ hộ bạn',
          icon: Icons.shopping_bag_rounded,
          bgColor: AppColors.purpleLight,
          iconBg: AppColors.purpleDark,
          titleColor: const Color(0xFF3B0764),
          subtitleColor: const Color(0xFF7C3AED),
          onTap: () {},
        ),
      ],
    );
  }
}
