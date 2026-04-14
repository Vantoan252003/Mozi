# core/services/ — Long-Lived Singleton Services

## Purpose
Services are **stateful singletons** that live for the entire app lifetime.
They wrap platform capabilities (GPS, WebSocket, push notifications, permissions)
and expose reactive streams or imperative APIs to the rest of the app.

## IMPORTANT: Services vs UseCases
```
Service  → owns a long-lived resource (GPS stream, WS connection, FCM listener)
           → @singleton in DI
           → called by DataSources or directly by BLoC when needed

UseCase  → stateless business logic, created per-use
           → @injectable in DI
           → may call a Service internally
```

## Subdirectories
| Directory        | Service                                         |
|------------------|-------------------------------------------------|
| `location/`      | GPS tracking, permission, geocoding wrapper     |
| `socket/`        | Socket.IO connection manager                    |
| `notification/`  | FCM token, foreground notifications, tap routing|
| `permission/`    | permission_handler unified wrapper              |
