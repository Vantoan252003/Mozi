# ride/domain/
## entities/
ride_service_type.dart — enum + extension (displayName, iconAsset, maxPassengers)
ride_estimate_entity.dart — serviceType, basePrice, surgeMultiplier, finalPrice, distanceMeters, durationSeconds, polylineEncoded
ride_order_entity.dart    — full order (see root SKILL.md)
ride_status.dart          — enum RideStatus + extension (displayLabel, color)
driver_entity.dart        — id, name, phone, avatarUrl, rating, vehicleType, plate, currentLat?, currentLng?
## repositories/
ride_repository.dart — 5 abstract methods
## usecases/
get_ride_estimate_usecase.dart
book_ride_usecase.dart
cancel_ride_usecase.dart
get_ride_detail_usecase.dart
get_ride_history_usecase.dart
