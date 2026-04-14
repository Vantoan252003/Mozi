# tracking/domain/
## entities/
tracking_entity.dart — orderId, orderType, status, driver coords, heading, etaSeconds, polyline
## repositories/
tracking_repository.dart — startTracking, stopTracking, watchUpdates (Stream)
## usecases/
start_tracking_usecase.dart
stop_tracking_usecase.dart
watch_tracking_usecase.dart — returns Stream<TrackingEntity>, not Future<Either>
