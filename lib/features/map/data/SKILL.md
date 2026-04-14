# map/data/
## models/
place_model.dart, place_prediction_model.dart, route_model.dart — fromJson(Google API response format)
## datasources/
map_remote_datasource.dart   — Dio calls to backend proxy endpoints (see ApiConstants map section)
location_datasource.dart     — Wraps LocationService.getCurrentLocation()
  Note: LocationService is injected, not instantiated here
## repositories/
map_repository_impl.dart
  Inject: MapRemoteDataSource, LocationDataSource
  Special: LocationPermissionDeniedException → LocationPermissionFailure
           LocationServiceDisabledException  → LocationServiceFailure
