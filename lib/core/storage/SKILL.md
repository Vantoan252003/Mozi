# core/storage/ — Local Storage

## Purpose
Two-layer storage abstraction:
- **SecureStorageService** — FlutterSecureStorage (encrypted, for tokens & sensitive data)
- **StorageService** — Hive (fast key-value, for cache, preferences, user data)

## Files to create

### secure_storage_service.dart
```
@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;
  SecureStorageService(this._storage);

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);
  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> delete(String key) => _storage.delete(key: key);
  Future<void> deleteAll() => _storage.deleteAll();

  // Typed helpers
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await write(SecureStorageKeys.accessToken,  accessToken);
    await write(SecureStorageKeys.refreshToken, refreshToken);
  }
  Future<String?> getAccessToken()  => read(SecureStorageKeys.accessToken);
  Future<String?> getRefreshToken() => read(SecureStorageKeys.refreshToken);
  Future<void>    clearTokens()     async {
    await delete(SecureStorageKeys.accessToken);
    await delete(SecureStorageKeys.refreshToken);
  }

  Future<void> saveFcmToken(String token) => write(SecureStorageKeys.fcmToken, token);
  Future<String?> getFcmToken() => read(SecureStorageKeys.fcmToken);
}
```

### storage_service.dart
Hive wrapper — synchronous reads after boxes are opened.

```
@singleton
class StorageService {
  late Box _prefsBox;

  // Call once in main() after Hive.initFlutter()
  Future<void> init() async {
    Hive.initFlutter();
    // Register adapters
    _registerAdapters();
    // Open boxes
    _prefsBox      = await Hive.openBox(HiveConstants.prefsBox);
    await Hive.openBox(HiveConstants.userBox);
    await Hive.openBox(HiveConstants.cartBox);
    await Hive.openBox<dynamic>(HiveConstants.addressBox);
    await Hive.openBox(HiveConstants.searchBox);
    await Hive.openBox(HiveConstants.voucherBox);
    await Hive.openBox(HiveConstants.notifBox);
  }

  // ── Preferences (synchronous after init) ────────────────────
  bool?    getBool(String key)   => _prefsBox.get(key) as bool?;
  String?  getString(String key) => _prefsBox.get(key) as String?;
  double?  getDouble(String key) => _prefsBox.get(key) as double?;
  int?     getInt(String key)    => _prefsBox.get(key) as int?;

  Future<void> setBool(String key, bool value)     => _prefsBox.put(key, value);
  Future<void> setString(String key, String value) => _prefsBox.put(key, value);
  Future<void> setDouble(String key, double value) => _prefsBox.put(key, value);
  Future<void> setInt(String key, int value)       => _prefsBox.put(key, value);

  Future<void> remove(String key)    => _prefsBox.delete(key);
  Future<void> clearPrefs()          => _prefsBox.clear();

  // ── Named box access ─────────────────────────────────────────
  Box<T> box<T>(String name) => Hive.box<T>(name);

  void _registerAdapters() {
    // Register Hive TypeAdapters here
    // e.g. Hive.registerAdapter(UserModelAdapter());
    //      Hive.registerAdapter(CartItemModelAdapter());
  }
}
```

## Which storage for what data
| Data                  | Storage          | Reason                    |
|-----------------------|------------------|---------------------------|
| access_token          | SecureStorage    | Sensitive, must be encrypted |
| refresh_token         | SecureStorage    | Sensitive                  |
| fcm_token             | SecureStorage    | Sensitive                  |
| User profile cache    | Hive userBox     | Fast read, not sensitive   |
| Cart state            | Hive cartBox     | Survive app restart        |
| Saved addresses       | Hive addressBox  | Offline support            |
| App preferences       | Hive prefsBox    | Not sensitive              |
| Search history        | Hive searchBox   | Not sensitive              |
| Voucher cache         | Hive voucherBox  | Short-lived cache          |

## Rules
- NEVER write tokens to Hive — FlutterSecureStorage only
- StorageService.init() must complete before runApp()
- Hive TypeAdapters are generated with @HiveType + build_runner
- Clear userBox, cartBox, searchBox on logout — keep prefsBox (language, etc.)
