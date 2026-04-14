# ride/presentation/
## bloc/
ride_bloc.dart + ride_event.dart + ride_state.dart (full state machine described in root SKILL.md)
## cubit/
ride_history_cubit.dart — load(page), loadMore(), state: Loading|Loaded(orders, hasMore)|Error
## pages/
ride_home_page.dart    — Map + search bar + recent addresses + PickupDestinationBar
ride_confirm_page.dart — Service selector + payment row + voucher row + price breakdown + CTA
ride_tracking_page.dart — GoogleMap (live) + DriverInfoCard + RideStatusBar + cancel button
## widgets/
ride_service_card.dart, ride_service_selector.dart, driver_info_card.dart,
ride_status_bar.dart, ride_surge_notice.dart, payment_selector.dart, surge_multiplier_badge.dart
