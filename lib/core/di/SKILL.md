# core/di/ — Dependency Injection

## Stack: get_it + injectable

## How it works
1. Annotate classes with `@injectable`, `@singleton`, `@lazySingleton`
2. Run `build_runner` to generate `injection_container.config.dart`
3. Call `configureDependencies()` in `main()` before `runApp()`

## Files to create

### injection_container.dart
```
final sl = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => sl.$initGetIt();
```

### injection_container.config.dart
**AUTO-GENERATED** by build_runner. Never edit manually.
Add to .gitignore.

## Scope Rules
| Annotation        | Lifetime         | Use for                                    |
|-------------------|------------------|--------------------------------------------|
| `@singleton`      | App lifetime     | Dio, SocketService, LocationService, SecureStorage, Hive boxes |
| `@lazySingleton`  | First-use lifetime | Repositories, DataSources                |
| `@injectable`     | New instance each time | UseCases, BLoC, Cubit              |

## Module Convention
Each 3rd-party library that needs construction logic gets its own module
in `di/modules/`. Example:
```dart
@module
abstract class NetworkModule {
  @singleton
  Dio get dio => ApiClientFactory.create();          // adds all interceptors

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @singleton
  SocketService get socketService => SocketService(AppConfig.instance.socketUrl);
}
```

## Rules
- NEVER call `sl<T>()` inside a Widget — inject via BLoC constructor or `context.read<T>()`
- NEVER use `sl<T>()` in domain layer — domain is pure, knows nothing about DI
- Register ALL singletons in modules/ to keep injection_container.dart clean
- BLoC/Cubit annotated @injectable are created fresh each route (not singletons)
- CartCubit is the exception — @singleton because it's global app state
