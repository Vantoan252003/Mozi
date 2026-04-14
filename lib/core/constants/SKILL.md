# core/constants/ — Application Constants

## Purpose
Single source of truth for all constant strings and values used across the app.
No magic strings anywhere else in the codebase.

## Files to create

### api_constants.dart
All HTTP endpoint paths as static const String.
Use {id} placeholder notation for dynamic segments.

```
class ApiConstants {
  // Base
  static String get baseUrl => AppConfig.instance.baseUrl;

  // Auth
  static const login           = '/auth/login';
  static const verifyOtp       = '/auth/verify-otp';
  static const resendOtp       = '/auth/resend-otp';
  static const refreshToken    = '/auth/refresh';
  static const logout          = '/auth/logout';

  // User / Profile
  static const profile         = '/users/me';
  static const updateProfile   = '/users/me';
  static const uploadAvatar    = '/users/me/avatar';
  static const savedAddresses  = '/users/me/addresses';
  static const address         = '/users/me/addresses/{id}';

  // Ride
  static const rideEstimate    = '/ride/estimate';
  static const rideBook        = '/ride/book';
  static const rideDetail      = '/ride/orders/{id}';
  static const rideCancel      = '/ride/orders/{id}/cancel';
  static const rideHistory     = '/ride/history';

  // Food
  static const restaurants     = '/food/restaurants';
  static const restaurantById  = '/food/restaurants/{id}';
  static const menuByRestaurant = '/food/restaurants/{id}/menu';
  static const foodOrder       = '/food/orders';
  static const foodOrderById   = '/food/orders/{id}';
  static const foodOrderCancel = '/food/orders/{id}/cancel';
  static const foodOrderHistory = '/food/orders/history';
  static const reorder         = '/food/orders/{id}/reorder';

  // Voucher
  static const vouchers        = '/vouchers';
  static const applyVoucher    = '/vouchers/apply';

  // Wallet
  static const walletBalance   = '/wallet/balance';
  static const walletTransactions = '/wallet/transactions';
  static const walletTopUp     = '/wallet/topup';
  static const paymentMethods  = '/wallet/payment-methods';

  // Notification
  static const notifications        = '/notifications';
  static const markNotifRead        = '/notifications/{id}/read';
  static const markAllNotifsRead    = '/notifications/read-all';
  static const registerFcmToken     = '/notifications/fcm-token';

  // Home
  static const banners         = '/home/banners';
  static const homeServices    = '/home/services';

  // Rating
  static const submitRating    = '/ratings';
  static const ratingTags      = '/ratings/tags';

  // Map (proxy — never call Google directly from client)
  static const placesAutocomplete = '/map/places/autocomplete';
  static const placeDetail        = '/map/places/{placeId}';
  static const directions         = '/map/directions';
  static const reverseGeocode     = '/map/reverse-geocode';
}
```

### route_constants.dart
All go_router path strings.

```
class RouteConstants {
  static const splash            = '/';
  static const onboarding        = '/onboarding';
  static const login             = '/login';
  static const otp               = '/otp/:phone';
  static const home              = '/home';
  static const homeRide          = '/home/ride';
  static const homeFood          = '/home/food';
  static const homeVoucher       = '/home/voucher';
  static const homeProfile       = '/home/profile';
  static const rideBooking       = '/ride/booking';
  static const rideConfirm       = '/ride/confirm';
  static const rideTracking      = '/ride/tracking/:orderId';
  static const foodSearch        = '/food/search';
  static const restaurantDetail  = '/food/restaurant/:restaurantId';
  static const cart              = '/food/cart';
  static const foodCheckout      = '/food/checkout';
  static const foodTracking      = '/food/tracking/:orderId';
  static const wallet            = '/wallet';
  static const walletTopUp       = '/wallet/topup';
  static const notifications     = '/notifications';
  static const orderHistory      = '/history';
  static const orderDetail       = '/history/:type/:orderId';
  static const rating            = '/rating/:orderType/:orderId';
  static const editProfile       = '/profile/edit';
  static const savedAddresses    = '/profile/addresses';
  static const addAddress        = '/profile/addresses/add';
  static const settings          = '/settings';
  static const mapPicker         = '/map-picker';
}
```

### app_constants.dart
```
class AppConstants {
  static const appName           = 'GoMove';
  static const connectTimeoutMs  = 30000;
  static const receiveTimeoutMs  = 30000;
  static const defaultPageSize   = 20;
  static const otpLength         = 6;
  static const otpResendSeconds  = 60;
  static const cartCacheDuration = Duration(days: 7);
  static const voucherCacheMins  = 5;
  static const deepLinkScheme    = 'gomove';
  static const deepLinkHost      = 'app';
  static const maxSavedAddresses = 10;
  static const driverMarkerZoom  = 16.0;
  static const routePolylineZoom = 13.0;
}
```

### hive_constants.dart
```
class HiveConstants {
  // Box names
  static const userBox        = 'user_box';
  static const cartBox        = 'cart_box';
  static const addressBox     = 'address_box';
  static const prefsBox       = 'prefs_box';
  static const searchBox      = 'search_history_box';
  static const voucherBox     = 'voucher_cache_box';
  static const notifBox       = 'notification_box';

  // Keys inside prefsBox
  static const keyHasSeenOnboarding = 'has_seen_onboarding';
  static const keySelectedLanguage  = 'language';
  static const keyNotifEnabled      = 'notifications_enabled';
  static const keyDefaultPayment    = 'default_payment_method';
  static const keyLastKnownLat      = 'last_known_lat';
  static const keyLastKnownLng      = 'last_known_lng';
}
```

### socket_events.dart
```
/// Socket events — use these constants, never raw strings.
class SocketEvents {
  // Client → Server
  static const joinRoom          = 'join_order_room';
  static const leaveRoom         = 'leave_order_room';
  static const ping              = 'ping';

  // Server → Client
  static const driverLocation    = 'driver_location';
  static const orderStatusChange = 'order_status_changed';
  static const etaUpdated        = 'eta_updated';
  static const orderCancelled    = 'order_cancelled';
  static const newNotification   = 'new_notification';
  static const surgeUpdated      = 'surge_updated';
}
```

### secure_storage_keys.dart
```
/// Keys for FlutterSecureStorage — tokens and sensitive data only.
class SecureStorageKeys {
  static const accessToken    = 'access_token';
  static const refreshToken   = 'refresh_token';
  static const fcmToken       = 'fcm_token';
  static const biometricKey   = 'biometric_enabled';
}
```

## Rules
- Every constant is `static const` — no instances, no mutable state
- Endpoint paths are relative (no base URL) — Dio BaseOptions adds base
- Route paths use `:param` notation to match go_router convention
- Do NOT add logic to constant files — pure data only
