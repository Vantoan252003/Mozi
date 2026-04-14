# tracking/data/
## datasources/
tracking_socket_datasource.dart
  Inject: SocketService singleton
  startTracking(orderId, orderType) → socket.joinRoom(...)
  stopTracking(orderId)             → socket.leaveRoom(...)
  watchUpdates(orderId)             → merges 3 socket streams:
    socket.onMap(SocketEvents.driverLocation)
    socket.onMap(SocketEvents.orderStatusChange)
    socket.onMap(SocketEvents.etaUpdated)
    socket.onMap(SocketEvents.orderCancelled)
  Maps each event to TrackingModel
## repositories/
tracking_repository_impl.dart
