# feature/map — Google Maps, Places Search, Route Drawing

## Purpose
Shared map module used by both ride/ and food/ features.
Handles: GPS-based location, place autocomplete, place detail, directions/polyline,
reverse geocoding, and the full-screen MapPickerPage for selecting pickup/destination.

## Entities
PlaceEntity {
  placeId: String, name: String, address: String,
  lat: double, lng: double, types: List<String>
}
PlacePredictionEntity {
  placeId: String, description: String,
  mainText: String, secondaryText: String
}
RouteEntity {
  polylineEncoded: String, distanceMeters: int,
  durationSeconds: int, steps: List<RouteStep>
}
LocationEntity → same as LocationModel in LocationService

## Repository: MapRepository
searchPlaces(query, sessionToken, {lat?, lng?}) → List<PlacePrediction>
getPlaceDetail(placeId, sessionToken)           → PlaceEntity
getCurrentLocation()                            → LocationEntity
getRoute(originPlaceId, destPlaceId)            → RouteEntity
reverseGeocode(lat, lng)                        → PlaceEntity

## UseCases
SearchPlacesUseCase         — call(query, sessionToken, {lat, lng})
GetPlaceDetailUseCase       — call(placeId, sessionToken)
GetCurrentLocationUseCase   — call() — delegates to LocationService
GetRouteUseCase             — call({origin: PlaceEntity, dest: PlaceEntity})
ReverseGeocodeUseCase       — call(lat, lng)

## Important: Backend Proxy
ALL map API calls go through backend proxy endpoints (see ApiConstants).
The Google Maps API key is NEVER in the Flutter app.
The Google Maps SDK key (for rendering the map widget) is set in AndroidManifest.xml
and Info.plist using AppConfig.googleMapsApiKey — not in Dart code.

## Navigation to MapPickerPage
```dart
// Call from RideBookingPage or anywhere:
final PlaceEntity? picked = await context.push<PlaceEntity>(
  RouteConstants.mapPicker,
  extra: MapPickerArgs(mode: PickerMode.destination, initialLocation: currentLoc),
);
if (picked != null) { bloc.add(DestinationSelected(picked)); }
```

## Session Tokens
Generate a UUID session token at the start of each autocomplete session.
Use the same token for all autocomplete calls in that session, then pass it to
getPlaceDetail. This minimizes backend API costs.
