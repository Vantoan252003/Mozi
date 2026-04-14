# feature/tracking — Realtime Order Tracking (Shared Module)

## Purpose
Provides a single TrackingBloc consumed by both RideTrackingPage and
FoodTrackingPage. Manages Socket.IO room lifecycle and emits location/status updates.

## Socket Event Flow
JOIN:
  Client → Server: join_order_room { orderId, orderType: 'ride'|'food' }

RECEIVE:
  driver_location     → { orderId, lat, lng, heading, speed }
  order_status_changed→ { orderId, newStatus, timestamp }
  eta_updated         → { orderId, etaSeconds }
  order_cancelled     → { orderId, reason, cancelledBy }

LEAVE:
  Client → Server: leave_order_room { orderId }

## Entities
TrackingEntity {
  orderId: String, orderType: String ('ride'|'food'), status: String,
  driverLat?: double, driverLng?: double, driverHeading?: double,
  etaSeconds?: int, polylineEncoded?: String
}

## Repository: TrackingRepository
startTracking(orderId, orderType) → Future<Either<Failure, void>>
stopTracking(orderId)             → Future<Either<Failure, void>>
watchUpdates(orderId)             → Stream<TrackingEntity>

## UseCases
StartTrackingUseCase — call({orderId, orderType})
StopTrackingUseCase  — call(orderId)
WatchTrackingUseCase — call(orderId) → Stream<TrackingEntity>

## TrackingBloc
@injectable (new instance per tracking session)
Events:
  StartTracking { orderId, orderType, initialPolyline? }
  StopTracking
  DriverLocationReceived { lat, lng, heading }
  OrderStatusReceived { newStatus }
  EtaUpdated { etaSeconds }
  OrderCancelled { reason }

States:
  TrackingIdle
  TrackingConnecting { orderId }
  TrackingActive {
    orderId, status, driverLat, driverLng, driverHeading,
    etaSeconds?, polylineDecoded: List<LatLng>
  }
  TrackingCompleted { orderId }
  TrackingCancelled { reason }
  TrackingError { message }

## Integration with MapCubit
TrackingBloc (DriverLocationReceived) should call:
  mapCubit.updateDriverMarker(lat, lng, heading)
  mapCubit.animateCameraTo(lat, lng) — only if !userMovedMap

## Rules
- TrackingBloc is @injectable — create a new instance on route push
- Call StopTracking in page dispose() / GoRoute onExit
- TrackingCompleted → wait 2s → push RatingPage
- SocketService is injected via DI — TrackingBloc must not create socket directly
