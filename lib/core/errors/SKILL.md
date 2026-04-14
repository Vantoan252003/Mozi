# core/errors/ — Error Handling

## Purpose
Defines the two-tier error system used throughout the app:
- **Exceptions** (Data layer throws these)
- **Failures** (Domain/Presentation receives these)

## Files to create

### exceptions.dart
Low-level exceptions thrown ONLY by DataSources (remote and local).
Never propagate past the Repository layer.

```
// HTTP / API errors
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException({required this.message});
}

class BadRequestException implements Exception {
  final String message;
  const BadRequestException({required this.message});
}

// Network errors
class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});
}

class TimeoutException implements Exception {
  const TimeoutException();
}

// Local storage errors
class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});
}

class CacheNotFoundException implements Exception {
  final String key;
  const CacheNotFoundException({required this.key});
}

// Location errors
class LocationPermissionDeniedException implements Exception {}
class LocationServiceDisabledException implements Exception {}
class LocationTimeoutException implements Exception {}

// Auth errors
class TokenExpiredException implements Exception {}
class TokenRefreshFailedException implements Exception {}
```

### failures.dart
High-level Failures returned by Repository and consumed by BLoC/Cubit.
All are immutable, Equatable, with a human-readable message field.

```
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});
  @override
  List<Object?> get props => [message];
}

// Network / Server
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});
  @override List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timed out'});
}

// Auth
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Session expired. Please log in again.'});
}

class TokenRefreshFailure extends Failure {
  const TokenRefreshFailure({super.message = 'Could not refresh session'});
}

// Data / Validation
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

// Local storage
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

// Location
class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure({super.message = 'Location permission denied'});
}

class LocationServiceFailure extends Failure {
  const LocationServiceFailure({super.message = 'Location service is disabled'});
}

// Unknown
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred'});
}
```

## Exception → Failure Mapping (used in every RepositoryImpl)
```
Failure _mapException(Object e) {
  if (e is NetworkException)                   return NetworkFailure(message: e.message);
  if (e is TimeoutException)                   return const TimeoutFailure();
  if (e is UnauthorizedException)              return const UnauthorizedFailure();
  if (e is NotFoundException)                  return NotFoundFailure(message: e.message);
  if (e is BadRequestException)                return BadRequestFailure(message: e.message);
  if (e is ServerException)                    return ServerFailure(message: e.message, statusCode: e.statusCode);
  if (e is CacheException)                     return CacheFailure(message: e.message);
  if (e is LocationPermissionDeniedException)  return const LocationPermissionFailure();
  if (e is LocationServiceDisabledException)   return const LocationServiceFailure();
  return const UnexpectedFailure();
}
```

## Rules
- Exceptions: thrown only in DataSource, caught only in RepositoryImpl
- Failures: returned only by Repository/UseCase, consumed by BLoC/Cubit
- NEVER use try/catch in UseCase, BLoC, or Widget
- NEVER let Exception propagate to presentation layer
