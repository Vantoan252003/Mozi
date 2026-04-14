# core/services/location/ — Location Service

## Purpose
Unified wrapper over `geolocator` package. Manages:
1. Permission requesting and checking
2. One-time location fetch
3. Continuous GPS stream (for live tracking screens)
4. Last-known location cache (Hive)

## Files to create

### location_service.dart
```
@singleton
class LocationService {
  final StorageService _storage;
  StreamSubscription<Position>? _positionSub;
  final _locationController = StreamController<LocationModel>.broadcast();

  LocationService(this._storage);

  // ── Permission ──────────────────────────────────────────────
  Future<LocationPermissionStatus> checkPermission() async {
    final perm = await Geolocator.checkPermission();
    return _mapPermission(perm);
  }

  Future<LocationPermissionStatus> requestPermission() async {
    final perm = await Geolocator.requestPermission();
    return _mapPermission(perm);
  }

  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  // ── One-time fetch ───────────────────────────────────────────
  /// Returns current position or throws LocationPermissionDeniedException /
  /// LocationServiceDisabledException / LocationTimeoutException
  Future<LocationModel> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    await _assertReady();
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );
      final model = LocationModel.fromPosition(pos);
      _cacheLastKnown(model);
      return model;
    } on TimeoutException {
      throw const LocationTimeoutException();
    }
  }

  // ── Continuous stream ────────────────────────────────────────
  /// Starts emitting GPS updates. Call stopTracking() to cancel.
  Stream<LocationModel> startTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilterMeters = 10,
    Duration intervalAndroid = const Duration(seconds: 2),
  }) {
    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilterMeters,
        intervalDuration: intervalAndroid,
      ),
    ).listen((pos) {
      final model = LocationModel.fromPosition(pos);
      _locationController.add(model);
      _cacheLastKnown(model);
    });
    return _locationController.stream;
  }

  void stopTracking() {
    _positionSub?.cancel();
    _positionSub = null;
  }

  // ── Last known location ──────────────────────────────────────
  LocationModel? getLastKnownLocation() {
    final lat = _storage.getDouble(HiveConstants.keyLastKnownLat);
    final lng = _storage.getDouble(HiveConstants.keyLastKnownLng);
    if (lat == null || lng == null) return null;
    return LocationModel(lat: lat, lng: lng, accuracy: 0);
  }

  void _cacheLastKnown(LocationModel m) {
    _storage.setDouble(HiveConstants.keyLastKnownLat, m.lat);
    _storage.setDouble(HiveConstants.keyLastKnownLng, m.lng);
  }

  Future<void> _assertReady() async {
    if (!await isServiceEnabled()) throw LocationServiceDisabledException();
    final status = await checkPermission();
    if (status == LocationPermissionStatus.denied ||
        status == LocationPermissionStatus.deniedForever) {
      throw LocationPermissionDeniedException();
    }
  }

  LocationPermissionStatus _mapPermission(LocationPermission p) {
    switch (p) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:  return LocationPermissionStatus.granted;
      case LocationPermission.denied:       return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:return LocationPermissionStatus.deniedForever;
      default: return LocationPermissionStatus.denied;
    }
  }

  void dispose() {
    _positionSub?.cancel();
    _locationController.close();
  }
}

enum LocationPermissionStatus { granted, denied, deniedForever }
```

### location_model.dart
```
class LocationModel {
  final double lat;
  final double lng;
  final double accuracy;     // meters
  final double? heading;     // degrees (0 = North)
  final double? speed;       // m/s
  final double? altitude;
  final DateTime? timestamp;

  const LocationModel({
    required this.lat,
    required this.lng,
    required this.accuracy,
    this.heading,
    this.speed,
    this.altitude,
    this.timestamp,
  });

  factory LocationModel.fromPosition(Position p) => LocationModel(
    lat:       p.latitude,
    lng:       p.longitude,
    accuracy:  p.accuracy,
    heading:   p.heading,
    speed:     p.speed,
    altitude:  p.altitude,
    timestamp: p.timestamp,
  );

  bool get isStale =>
    timestamp != null && DateTime.now().difference(timestamp!) > const Duration(minutes: 5);
}
```

## Rules
- LocationService owns the single Geolocator subscription — never create separate ones
- Always call _assertReady() before getCurrentLocation and startTracking
- LocationBloc (in feature/map) consumes LocationService streams — not the other way around
- Cache last-known location so map shows something while GPS warms up
- Stop tracking in dispose() — call stopTracking() when leaving ride/food tracking screen
