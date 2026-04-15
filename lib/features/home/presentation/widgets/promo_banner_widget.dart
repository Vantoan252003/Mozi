import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';

/// A single promo banner card with gradient background
class PromoBannerWidget extends StatelessWidget {
  final String badge;
  final String title;
  final LinearGradient gradient;
  final IconData icon;

  const PromoBannerWidget({
    super.key,
    required this.badge,
    required this.title,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    badge.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTypography.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: Colors.white, size: 64),
        ],
      ),
    );
  }
}

/// Horizontal PageView of promo banners
class PromoBannerSectionWidget extends StatelessWidget {
  const PromoBannerSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144,
      child: PageView(
        children: const [
          PromoBannerWidget(
            badge: 'Ưu đãi mới',
            title: 'Giảm 50%\nchuyến đầu',
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
            ),
            icon: Icons.local_activity_rounded,
          ),
          PromoBannerWidget(
            badge: 'Thanh toán',
            title: 'Hoàn 20K\nqua Ví MoMo',
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A5F), Color(0xFF1565C0)],
            ),
            icon: Icons.account_balance_wallet_rounded,
          ),
        ],
      ),
    );
  }
}
