import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';
import 'package:mozi_v2/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:mozi_v2/features/home/presentation/widgets/home_header_widget.dart';
import 'package:mozi_v2/features/home/presentation/widgets/location_bar_widget.dart';
import 'package:mozi_v2/features/home/presentation/widgets/promo_banner_widget.dart';
import 'package:mozi_v2/features/home/presentation/widgets/recent_orders_section_widget.dart';
import 'package:mozi_v2/features/home/presentation/widgets/service_grid_widget.dart';
import 'package:mozi_v2/features/home/presentation/widgets/suggested_section_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
      body: CustomScrollView(
        slivers: [
          // Sticky gradient header
          const SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: HomeHeaderWidget(),
            ),
          ),
          // Scrollable content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LocationBarWidget(),
                  const SizedBox(height: 24),
                  const ServiceGridWidget(),
                  const SizedBox(height: 24),
                  const PromoBannerSectionWidget(),
                  const SizedBox(height: 24),
                  // Section header: Recent orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đặt gần đây',
                        style: AppTypography.titleLarge
                            .copyWith(color: AppColors.onSurface),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_right,
                            color: AppColors.primary, size: 18),
                        label: Text(
                          'Xem tất cả',
                          style: AppTypography.labelMedium
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const RecentOrdersSectionWidget(),
                  const SizedBox(height: 24),
                  // Section header: Suggested
                  Text(
                    'Gợi ý hôm nay',
                    style: AppTypography.titleLarge
                        .copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 12),
                  const SuggestedSectionWidget(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
