# core/services/permission/ — Permission Service

## Purpose
Unified wrapper over `permission_handler` package. Consolidates all
runtime permission requests in one place for easier management and testing.

## Files to create

### permission_service.dart
```
@lazySingleton
class PermissionService {

  // ── Location ─────────────────────────────────────────────────
  Future<PermissionState> checkLocation() =>
      _check(Permission.location);

  Future<PermissionState> requestLocation() =>
      _request(Permission.location);

  Future<PermissionState> requestLocationAlways() =>
      _request(Permission.locationAlways);

  // ── Notification ─────────────────────────────────────────────
  Future<PermissionState> checkNotification() =>
      _check(Permission.notification);

  Future<PermissionState> requestNotification() =>
      _request(Permission.notification);

  // ── Camera / Gallery ─────────────────────────────────────────
  Future<PermissionState> requestCamera() => _request(Permission.camera);
  Future<PermissionState> requestPhotos() => _request(Permission.photos);

  // ── System settings ──────────────────────────────────────────
  Future<void> openAppSettings() => openAppSettings();

  // ── Internal ─────────────────────────────────────────────────
  Future<PermissionState> _check(Permission p) async {
    final status = await p.status;
    return _mapStatus(status);
  }

  Future<PermissionState> _request(Permission p) async {
    final status = await p.request();
    return _mapStatus(status);
  }

  PermissionState _mapStatus(PermissionStatus s) {
    if (s.isGranted)           return PermissionState.granted;
    if (s.isDenied)            return PermissionState.denied;
    if (s.isPermanentlyDenied) return PermissionState.permanentlyDenied;
    if (s.isRestricted)        return PermissionState.restricted;
    return PermissionState.denied;
  }
}

enum PermissionState { granted, denied, permanentlyDenied, restricted }
```

## Rules
- Always check before request — avoids prompting if already granted
- permanentlyDenied → show "Open Settings" dialog (UI responsibility)
- Camera permission required for avatar upload
- Location permission gating is handled in LocationService internally, but UI can pre-check via PermissionService to show explanation dialog before LocationService call
