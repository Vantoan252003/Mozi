# feature/settings — App Settings

## Entities
AppSettingsEntity {
  language: 'vi'|'en',
  notificationsEnabled: bool,
  rideNotifications: bool, foodNotifications: bool, promoNotifications: bool,
  biometricEnabled: bool
}

## UseCases
GetSettingsUseCase    — call() → AppSettingsEntity
UpdateSettingsUseCase — call(AppSettingsEntity)
GetAppVersionUseCase  — call() → { version: String, buildNumber: String }
ClearCacheUseCase     — call() → void (clears non-auth Hive boxes)

## Presentation
Cubit: SettingsCubit — load, update, clearCache
  State: SettingsLoading | SettingsLoaded(settings) | SettingsError

Pages:
  SettingsPage — grouped sections:
    "Tài khoản":  Đổi số điện thoại, Bảo mật sinh trắc học
    "Thông báo":  Master toggle + per-type toggles
    "Ứng dụng":  Ngôn ngữ, Xóa cache, Phiên bản
    "Hỗ trợ":    Câu hỏi thường gặp, Liên hệ hỗ trợ, Điều khoản sử dụng
    "Tài khoản": Đăng xuất (red)

Widgets:
  SettingsSectionHeader — Group title label
  SettingsToggleTile    — Label + Switch widget
  SettingsNavTile       — Label + trailing value/badge + arrow
  AppVersionTile        — "Phiên bản 1.0.0 (build 42)" + check for update
  LogoutTile            — Red destructive tile, shows confirmation dialog

## Rules
- Settings stored in Hive prefsBox — no remote sync needed
- Language change: update locale in MaterialApp (no restart needed with l10n)
- clearCache: delete userBox, cartBox, searchBox, voucherBox — keep prefsBox and auth
- Biometric: store bool in SecureStorageKeys.biometricKey, integrate with local_auth package
