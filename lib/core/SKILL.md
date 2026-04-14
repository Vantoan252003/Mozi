# core/ — Infrastructure Layer

## Purpose
Contains all cross-cutting infrastructure code that does NOT belong to any
single business feature. Every feature imports from core; core never imports
from features.

## Subdirectories

| Directory        | Responsibility                                             |
|------------------|------------------------------------------------------------|
| `config/`        | Environment config, build flavors (dev/staging/prod)       |
| `constants/`     | All string/int constants (API paths, route names, keys)    |
| `di/`            | GetIt registration + Injectable setup                      |
| `di/modules/`    | @Module abstract classes for 3rd-party library instances   |
| `errors/`        | Exception hierarchy + Failure hierarchy                    |
| `network/`       | Dio client factory, base options                           |
| `network/interceptors/` | Auth, logging, error-mapping interceptors           |
| `router/`        | go_router GoRouter instance + route guard logic            |
| `services/`      | Long-lived singleton services (location, socket, FCM, permission) |
| `storage/`       | Hive + SecureStorage abstraction services                  |
| `theme/`         | AppColors, AppTypography, AppDimensions, ThemeData         |
| `utils/`         | Stateless pure utility functions                           |

## Rules
- core/ MUST NOT import from lib/features/ — ever
- core/ MUST NOT contain Widget classes or BLoC/Cubit
- All singletons (Dio, Socket, Hive boxes, SecureStorage) are registered in di/
- No business logic anywhere in core/
