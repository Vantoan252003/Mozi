# home/presentation/
## pages/
main_shell_page.dart  — ShellRoute scaffold + BottomNavigationBar (5 tabs)
dashboard_page.dart   — Scrollable: HomeTopBar, PromoBannerSlider, ServiceGrid, RecentOrders
## cubit/
home_cubit.dart        state: HomeInitial | HomeLoading | HomeLoaded(feed) | HomeError
bottom_nav_cubit.dart  state: int currentIndex
## widgets/
home_top_bar.dart          — Row(location_pill, spacer, notification_bell)
promo_banner_slider.dart   — PageView.builder + Timer + SmoothPageIndicator
service_grid_widget.dart   — GridView 2×2, navigates on tap
recent_orders_section.dart — "Đặt lại" shortcut cards, horizontal scroll
greeting_card.dart         — Avatar + greeting text
