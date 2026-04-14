# feature/home — Home Dashboard + Bottom Navigation

## Purpose
The main shell of the app. Hosts the bottom navigation bar and renders the
correct tab page. Also loads promo banners, service shortcuts, and recent orders.

## Shell Architecture
MainShellPage is a ShellRoute in go_router.
It wraps each tab in an IndexedStack so tab state is preserved when switching.
Bottom nav tabs: Ride (index 0), Food (1), Voucher (2), Profile (3).

## Entities
BannerEntity    { id, imageUrl, deepLink?, title, displayOrder }
ServiceEntity   { id, name, iconUrl, serviceType, routePath }
HomeFeedEntity  { banners: List<BannerEntity>, featuredRestaurants: List<RestaurantEntity> }

## UseCases
GetBannersUseCase      — call() → List<BannerEntity>
GetHomeFeedUseCase     — call({ lat, lng }) → HomeFeedEntity

## Presentation
Cubit: HomeCubit — loadFeed(lat, lng)
Cubit: BottomNavCubit — currentIndex, navigate(int)

Pages:
  MainShellPage   — Scaffold + BottomNavigationBar (ShellRoute child)
  DashboardPage   — Header + banners + service grid + recent orders section

Widgets:
  HomeTopBar             — Current address (tap → MapPickerPage) + Bell icon
  PromoBannerSlider      — PageView auto-scroll every 3s + dot indicator
  ServiceGridWidget      — 2×2 grid cards (Ride, Food, Delivery, Market)
  RecentOrdersSection    — Horizontal scroll of last 3 orders
  GreetingCard           — "Xin chào [name]!" + weather/time greeting

## Rules
- DashboardPage fetches location via LocationService before calling GetHomeFeedUseCase
- Banner deepLink is handled by go_router URI parsing
- MainShellPage manages IndexedStack for tab state persistence
