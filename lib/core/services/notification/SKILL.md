# core/services/notification/ — Push Notification Service

## Purpose
Manages Firebase Cloud Messaging (FCM) setup and local notification display.
Routes notification taps to the correct screen via go_router.

## Files to create

### notification_service.dart
```
@singleton
class NotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifs;
  final GoRouter _router;
  final FlutterSecureStorage _secureStorage;

  NotificationService({
    required FirebaseMessaging fcm,
    required GoRouter router,
    required FlutterSecureStorage secureStorage,
  })  : _fcm = fcm,
        _localNotifs = FlutterLocalNotificationsPlugin(),
        _router = router,
        _secureStorage = secureStorage;

  // ── Initialization ───────────────────────────────────────────
  Future<void> initialize() async {
    // 1. Request permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // 2. Configure local notifications channel (Android)
    const androidChannel = AndroidNotificationChannel(
      'gomove_high_importance',
      'GoMove Notifications',
      importance: Importance.max,
    );
    await _localNotifs
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // 3. Initialize local notifications plugin
    await _localNotifs.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onNotifTap,
    );

    // 4. Handle foreground messages
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // 5. Handle background tap (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotifTap);

    // 6. Handle terminated tap
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _handleNotifTap(initial);
  }

  // ── Token management ─────────────────────────────────────────
  Future<String?> getToken() => _fcm.getToken();

  void onTokenRefresh(void Function(String token) callback) {
    _fcm.onTokenRefresh.listen(callback);
  }

  // ── Internal ─────────────────────────────────────────────────
  void _showLocalNotification(RemoteMessage message) {
    final notif = message.notification;
    if (notif == null) return;
    _localNotifs.show(
      notif.hashCode,
      notif.title,
      notif.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'gomove_high_importance',
          'GoMove Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _onNotifTap(NotificationResponse response) {
    if (response.payload == null) return;
    final data = jsonDecode(response.payload!) as Map<String, dynamic>;
    _navigateFromPayload(data);
  }

  void _handleNotifTap(RemoteMessage message) => _navigateFromPayload(message.data);

  void _navigateFromPayload(Map<String, dynamic> data) {
    final type    = data['type'] as String?;
    final orderId = data['orderId'] as String?;
    switch (type) {
      case 'ride_update':
        if (orderId != null) _router.push('/ride/tracking/$orderId');
      case 'food_update':
        if (orderId != null) _router.push('/food/tracking/$orderId');
      case 'promotion':
        _router.push(RouteConstants.homeVoucher);
      case 'wallet':
        _router.push(RouteConstants.wallet);
      default:
        _router.push(RouteConstants.notifications);
    }
  }
}
```

## Notification Payload Schema (from backend)
```json
{
  "type": "ride_update | food_update | promotion | wallet | system",
  "orderId": "optional order ID",
  "title": "notification title",
  "body": "notification body",
  "imageUrl": "optional banner image URL"
}
```

## Rules
- NotificationService.initialize() is called in main() after Firebase.initializeApp()
- FCM token must be sent to backend immediately after login (RegisterFcmTokenUseCase)
- Refresh token on onTokenRefresh callback
- Never navigate directly from notification service — always use the injected GoRouter
