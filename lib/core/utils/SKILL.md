# core/utils/ — Utility Functions

## Purpose
Pure, stateless utility functions. No side effects. No imports from features.
All functions are `static` methods inside a class, or top-level functions.

## Files to create

### format_utils.dart
```
class FormatUtils {
  // Currency
  static String currency(num amount) =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(amount);

  // Distance
  static String distance(double meters) =>
      meters >= 1000 ? '${(meters / 1000).toStringAsFixed(1)} km' : '${meters.toInt()} m';

  // Duration (minutes → "2g 30p" or "45 phút")
  static String duration(int minutes) =>
      minutes >= 60 ? '${minutes ~/ 60}g ${minutes % 60}p' : '$minutes phút';

  // Rating
  static String rating(double r) => r.toStringAsFixed(1);

  // Phone masking
  static String maskPhone(String p) =>
      p.length < 6 ? p : p.replaceRange(3, p.length - 2, '****');

  // Percentage
  static String percent(double p) => '${(p * 100).toStringAsFixed(0)}%';

  // Truncate string
  static String truncate(String s, {int maxLength = 30}) =>
      s.length <= maxLength ? s : '${s.substring(0, maxLength)}...';
}
```

### date_utils.dart
```
class AppDateUtils {
  static String formatDateTime(DateTime dt) =>
      DateFormat('HH:mm dd/MM/yyyy').format(dt);

  static String formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);
  static String formatDate(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  static String relativeDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours   < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays    < 1) return '${diff.inHours} giờ trước';
    if (diff.inDays    < 2) return 'Hôm qua';
    if (diff.inDays    < 7) return '${diff.inDays} ngày trước';
    return formatDate(dt);
  }

  static bool isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  static bool isYesterday(DateTime dt) =>
      isToday(dt.add(const Duration(days: 1)));
}
```

### location_utils.dart
```
class LocationUtils {
  /// Haversine formula — returns distance in meters
  static double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  /// Bearing in degrees (0 = North, 90 = East)
  static double bearing(double lat1, double lon1, double lat2, double lon2) {
    final dLon = _rad(lon2 - lon1);
    final y = sin(dLon) * cos(_rad(lat2));
    final x = cos(_rad(lat1)) * sin(_rad(lat2)) -
               sin(_rad(lat1)) * cos(_rad(lat2)) * cos(dLon);
    return (degrees(atan2(y, x)) + 360) % 360;
  }

  static double _rad(double deg) => deg * pi / 180;
}
```

### map_utils.dart
```
class MapUtils {
  /// Decode Google encoded polyline → List<LatLng>
  static List<LatLng> decodePolyline(String encoded) {
    return PolylinePoints()
        .decodePolyline(encoded)
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
  }

  /// Calculate LatLngBounds that fits all given points
  static LatLngBounds boundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude,  maxLat = points.first.latitude;
    double minLng = points.first.longitude, maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude  < minLat) minLat = p.latitude;
      if (p.latitude  > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Suggest camera zoom based on distance to show
  static double zoomForDistance(double meters) {
    if (meters < 500)   return 16.5;
    if (meters < 2000)  return 15.0;
    if (meters < 5000)  return 13.5;
    if (meters < 15000) return 12.0;
    return 10.5;
  }

  /// Add padding to LatLngBounds (in degrees)
  static LatLngBounds expandBounds(LatLngBounds b, {double padding = 0.002}) =>
      LatLngBounds(
        southwest: LatLng(b.southwest.latitude  - padding, b.southwest.longitude - padding),
        northeast: LatLng(b.northeast.latitude  + padding, b.northeast.longitude + padding),
      );
}
```

### validation_utils.dart
```
class ValidationUtils {
  static bool isValidVietnamesePhone(String phone) =>
      RegExp(r'^(0[3|5|7|8|9])[0-9]{8}$').hasMatch(phone);

  static bool isValidEmail(String email) =>
      RegExp(r'^[w-.]+@([w-]+.)+[w-]{2,4}$').hasMatch(email);

  static bool isValidOtp(String otp) =>
      RegExp(r'^[0-9]{6}$').hasMatch(otp);

  static String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (!isValidVietnamesePhone(v)) return 'Số điện thoại không hợp lệ';
    return null;
  }

  static String? validateRequired(String? v, String fieldName) {
    if (v == null || v.trim().isEmpty) return '$fieldName không được để trống';
    return null;
  }
}
```

### app_logger.dart
```
/// App-wide logging wrapper. Only logs in debug/staging modes.
class AppLogger {
  static void debug(String msg, {String? tag})   => _log('DEBUG', tag, msg);
  static void info(String msg, {String? tag})    => _log('INFO',  tag, msg);
  static void warning(String msg, {String? tag}) => _log('WARN',  tag, msg);
  static void error(String msg, {Object? error, StackTrace? stack, String? tag}) {
    _log('ERROR', tag, msg);
    if (error != null && kDebugMode) debugPrint('  Error: $error');
    if (stack != null && kDebugMode) debugPrint('  Stack: $stack');
  }

  static void _log(String level, String? tag, String msg) {
    if (kReleaseMode) return;
    final prefix = tag != null ? '[$level][$tag]' : '[$level]';
    debugPrint('$prefix $msg');
  }
}
```

## Rules
- All functions must be pure — no side effects, no global state
- No imports from features/ — only core/ imports allowed
- No Flutter widgets — only dart:math, dart:core, utility packages
