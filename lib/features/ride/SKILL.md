# feature/ride — Ride Booking

## Full User Flow
1. RideHomePage: map + PickupDestinationBar + recent locations
2. User taps destination → go to MapPickerPage → returns PlaceEntity
3. GetRideEstimateUseCase → show pricing list (Moto / Car4 / Car7)
4. User selects service type, optionally applies voucher, selects payment
5. RideConfirmPage → BookRideUseCase → orderId
6. RideTrackingPage: socket updates driver location + ride status
7. On completion → RatingPage

## Entities
RideServiceType          { motorbike, car4, car7 }
  + displayName, iconAsset, maxPassengers

RideEstimateEntity {
  serviceType: RideServiceType,
  basePrice: double, surgeMultiplier: double,
  finalPrice: double, distanceMeters: int,
  durationSeconds: int, polylineEncoded: String
}

RideOrderEntity {
  id: String,
  status: RideStatus (enum below),
  pickup: PlaceEntity, destination: PlaceEntity,
  serviceType: RideServiceType,
  driver?: DriverEntity,
  totalPrice: double, discountAmount: double,
  paymentMethod: String,
  createdAt: DateTime, completedAt?: DateTime
}

RideStatus {
  pending, driverAccepted, driverArrived,
  inProgress, completed, cancelled
}

DriverEntity {
  id, name, phone, avatarUrl, rating,
  vehicleType, plate, currentLat, currentLng, heading
}

## UseCases
GetRideEstimateUseCase   — call({pickup, destination}) → List<RideEstimateEntity>
BookRideUseCase          — call({pickup, dest, serviceType, paymentMethod, voucherId?}) → RideOrderEntity
CancelRideUseCase        — call(orderId, {reason?}) → void
GetRideDetailUseCase     — call(orderId) → RideOrderEntity
GetRideHistoryUseCase    — call({page}) → List<RideOrderEntity>

## Presentation
BLoC: RideBloc — full booking end-to-end state machine
Events:
  PickupSelected(place), DestinationSelected(place),
  ServiceTypeSelected(type), VoucherApplied(voucher), PaymentMethodSelected(method),
  BookingConfirmed, BookingCancelled(reason?)
States:
  RideIdle, RidePickupSet, RideDestinationSet, RideEstimating,
  RideEstimatesReady(estimates, selected, subtotal), RideConfirming,
  RideBooked(orderId), RideCancelled, RideError(message)

Pages:
  RideHomePage     — map + location + PickupDestinationBar
  RideConfirmPage  — summary + service selector + payment + voucher + "Đặt xe"
  RideTrackingPage — live map + DriverInfoCard + StatusBar + cancel btn

Widgets:
  RideServiceCard      — card per service type (icon, name, price, ETA)
  RideServiceSelector  — horizontal list of RideServiceCard
  DriverInfoCard       — avatar + name + plate + rating + call/chat buttons
  RideStatusBar        — step indicator: pending→accepted→arrived→inProgress→done
  RideSurgeNotice      — warning when surgeMultiplier > 1.2x
  PaymentSelector      — dropdown: BeWallet, MoMo, ZaloPay, Cash
  SurgeMultiplierBadge — "×1.5" badge on estimate card

## Surge Pricing
surgeMultiplier > 1.0 → show SurgeNotice banner + RideSurgeMultiplierBadge on card
finalPrice = basePrice × surgeMultiplier

## Rules
- RideBloc is @injectable (new instance per ride session, not singleton)
- DriverEntity only lives in RideBloc state — never cached to Hive
- Use TrackingBloc (from feature/tracking) for socket updates in RideTrackingPage
- Camera auto-follows driver if user hasn't manually moved the map (track a bool userMovedMap)
