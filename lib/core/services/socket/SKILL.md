# core/services/socket/ — Socket.IO Service

## Purpose
Manages the single Socket.IO WebSocket connection for the entire app.
Provides room management (join/leave per order) and typed event streams.

## Files to create

### socket_service.dart
```
@singleton
class SocketService {
  final String _url;
  IO.Socket? _socket;
  bool _isConnected = false;

  SocketService({required String url}) : _url = url;

  bool get isConnected => _isConnected;

  // ── Lifecycle ────────────────────────────────────────────────
  /// Connect with JWT token for authentication on handshake.
  void connect(String accessToken) {
    if (_isConnected) return;
    _socket = IO.io(
      _url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .setExtraHeaders({'Authorization': 'Bearer $accessToken'})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!
      ..onConnect((_) {
        _isConnected = true;
        debugPrint('[Socket] Connected');
      })
      ..onDisconnect((_) {
        _isConnected = false;
        debugPrint('[Socket] Disconnected');
      })
      ..onConnectError((e) => debugPrint('[Socket] Connection error: $e'))
      ..connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }

  // ── Room management ──────────────────────────────────────────
  /// Join a room to receive real-time updates for an order.
  void joinRoom(String orderId, String orderType) {
    _socket?.emit(SocketEvents.joinRoom, {'orderId': orderId, 'orderType': orderType});
  }

  void leaveRoom(String orderId) {
    _socket?.emit(SocketEvents.leaveRoom, {'orderId': orderId});
  }

  // ── Emit ─────────────────────────────────────────────────────
  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  // ── Listen ───────────────────────────────────────────────────
  /// Returns a broadcast stream for the given event name.
  /// The generic type T is parsed from the raw data by the provided parser.
  Stream<T> on<T>(String event, T Function(dynamic data) parser) {
    final controller = StreamController<T>.broadcast();
    _socket?.on(event, (data) {
      try {
        controller.add(parser(data));
      } catch (e) {
        debugPrint('[Socket] Parse error on $event: $e');
      }
    });
    return controller.stream;
  }

  /// Convenience: returns Stream<Map<String,dynamic>> for an event.
  Stream<Map<String, dynamic>> onMap(String event) =>
      on(event, (data) => Map<String, dynamic>.from(data as Map));
}
```

## Usage in TrackingBloc
```dart
// In TrackingBloc constructor / StartTracking handler:
_socketService.joinRoom(orderId, orderType);

_locationSub = _socketService.onMap(SocketEvents.driverLocation)
    .where((data) => data['orderId'] == orderId)
    .listen((data) => add(DriverLocationReceived(
        lat: data['lat'] as double,
        lng: data['lng'] as double,
    )));

_statusSub = _socketService.onMap(SocketEvents.orderStatusChange)
    .where((data) => data['orderId'] == orderId)
    .listen((data) => add(OrderStatusReceived(status: data['newStatus'] as String)));
```

## Rules
- SINGLETON — one socket connection for the whole app
- Connect on login (after token obtained), disconnect on logout
- Always check _isConnected before emitting
- TrackingBloc owns stream subscriptions, not SocketService itself
- Reconnection config: max 5 attempts, 2s delay (built into socket.io-client)
