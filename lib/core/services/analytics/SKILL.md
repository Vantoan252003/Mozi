# core/services/analytics/ — Event Analytics

## Files to create
```
analytics_service.dart       — Abstract interface
analytics_service_impl.dart  — Firebase Analytics implementation
analytics_events.dart        — All event name constants
analytics_params.dart        — All parameter name constants
```

## AnalyticsService interface
```dart
abstract class AnalyticsService {
  Future<void> logEvent({required String name, Map<String, Object?>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty({required String name, required String? value});
  Future<void> logScreenView({required String screenName, String? screenClass});
}
```

## analytics_events.dart
```dart
class AnalyticsEvents {
  // Auth
  static const String login           = 'login';
  static const String logout          = 'logout';
  static const String register        = 'register';

  // Ride
  static const String rideSearched    = 'ride_searched';
  static const String rideBooked      = 'ride_booked';
  static const String rideCancelled   = 'ride_cancelled';
  static const String rideCompleted   = 'ride_completed';

  // Food
  static const String restaurantViewed  = 'restaurant_viewed';
  static const String itemAddedToCart   = 'add_to_cart';
  static const String checkoutStarted   = 'begin_checkout';
  static const String orderPlaced       = 'purchase';
  static const String orderCancelled    = 'order_cancelled';

  // Voucher
  static const String voucherApplied  = 'voucher_applied';
  static const String voucherFailed   = 'voucher_failed';

  // Wallet
  static const String walletTopUp     = 'wallet_topup';
}
```

## Rules
- Analytics calls must NOT block business logic (fire and forget, never await in critical paths)
- Log errors silently — analytics failure must never crash the app
- Only log events after user has granted analytics consent (if applicable)
- AnalyticsService is @singleton
