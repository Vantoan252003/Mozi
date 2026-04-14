# map/presentation/

## BLoC: LocationBloc
location_bloc.dart — manages GPS stream lifecycle
Events: RequestLocation, StartTracking, StopTracking, LocationUpdated(location)
States: LocationInitial, LocationLoading, LocationGranted(location),
        LocationDenied, LocationServiceDisabled, LocationError(message)
On StartTracking: subscribe to LocationService.startTracking()
On StopTracking:  LocationService.stopTracking()
On dispose:       cancel subscription + stopTracking

## Cubit: MapCubit
map_cubit.dart — controls the GoogleMap controller
State: MapState {
  controller: GoogleMapController?,
  markers: Set<Marker>,
  polylines: Set<Polyline>,
  isLoading: bool
}
Methods:
  onMapCreated(controller)
  setOriginMarker(PlaceEntity)      — green pin
  setDestinationMarker(PlaceEntity) — red pin
  setDriverMarker(id, lat, lng, heading) — animated driver marker
  drawRoute(RouteEntity)            — decode polyline, add blue Polyline
  clearRoute()
  animateCameraTo(lat, lng, {zoom})
  fitBoundsToMarkers()              — camera shows all markers with padding
  updateDriverMarker(lat, lng)      — called every TrackingBloc location update

## Cubit: PlaceSearchCubit
place_search_cubit.dart — autocomplete search
State: PlaceSearchState {
  query: String, predictions: List<PlacePrediction>,
  isLoading: bool, selectedPlace?: PlaceEntity, error?: String,
  sessionToken: String  // UUID, reset on new session
}
Methods: search(query) — debounce 300ms, selectPrediction(p), clearSearch()
Note: generate new sessionToken when user starts typing after a clearSearch()

## Pages: MapPickerPage
map_picker_page.dart
  Args: MapPickerArgs { mode: PickerMode, initialLocation?: LocationEntity }
  Returns: PlaceEntity (popped via context.pop(result))
  Layout:
    - Full-screen GoogleMap
    - PlaceSearchBar pinned at top (floating)
    - When user drags map: center pin, reverse geocode on drag end
    - When user selects autocomplete: animate camera
    - "Xác nhận điểm này" button at bottom
    - LocationPermissionWidget shown if no GPS

## Widgets
app_map_view.dart              — GoogleMap wrapper (markers, polylines, my-location btn)
place_search_bar.dart          — TextField with debounce + clear button
place_suggestion_list.dart     — ListView of PlacePredictionEntity rows
location_permission_widget.dart — "Allow location" prompt with settings button
map_marker_widget.dart         — Custom marker builder (color + icon + label)
route_info_chip.dart           — Pill: distance + duration
pickup_destination_bar.dart    — Two inputs with swap button (used in RideBookingPage)
