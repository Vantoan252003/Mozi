import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';

/// A single restaurant / recently-ordered card
class RestaurantCardWidget extends StatelessWidget {
  final String name;
  final String deliveryTime;
  final String rating;
  final String deliveryCost;

  const RestaurantCardWidget({
    super.key,
    required this.name,
    required this.deliveryTime,
    required this.rating,
    required this.deliveryCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              Container(
                height: 128,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    deliveryTime,
                    style: AppTypography.labelSmall,
                  ),
                ),
              ),
            ],
          ),
          // Info row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.titleSmall
                      .copyWith(color: AppColors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFBBF24),
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(rating, style: AppTypography.bodySmall),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.outlineVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.delivery_dining,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Text(deliveryCost, style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal scroll list of restaurant cards
class RecentOrdersSectionWidget extends StatelessWidget {
  const RecentOrdersSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          RestaurantCardWidget(
            name: 'The Salad Place - Phan Xích Long',
            deliveryTime: '25 Phút',
            rating: '4.8',
            deliveryCost: 'Miễn phí',
          ),
          SizedBox(width: 16),
          RestaurantCardWidget(
            name: "McDonald's - Trần Hưng Đạo",
            deliveryTime: '15 Phút',
            rating: '4.5',
            deliveryCost: '15k',
          ),
        ],
      ),
    );
  }
}
