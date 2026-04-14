# core/theme/ — Design System

## Files to create

### app_colors.dart
```
class AppColors {
  // ── Brand ───────────────────────────────────────────────────
  static const primary        = Color(0xFF1A6FE8);  // Vivid blue (main brand)
  static const primaryDark    = Color(0xFF0A4DB5);  // Darker blue
  static const primaryLight   = Color(0xFFE8F1FD);  // Very light blue tint
  static const accent         = Color(0xFFFF6B35);  // Orange — CTAs, highlights
  static const accentLight    = Color(0xFFFFF0EB);

  // ── Semantic ────────────────────────────────────────────────
  static const success        = Color(0xFF27AE60);
  static const successLight   = Color(0xFFE8F8EF);
  static const error          = Color(0xFFE74C3C);
  static const errorLight     = Color(0xFFFDECEA);
  static const warning        = Color(0xFFF39C12);
  static const warningLight   = Color(0xFFFEF9E7);
  static const info           = Color(0xFF1A6FE8);  // same as primary
  static const infoLight      = Color(0xFFE8F1FD);

  // ── Neutral ─────────────────────────────────────────────────
  static const background     = Color(0xFFF4F7FD);  // Light blue-gray page bg
  static const surface        = Color(0xFFFFFFFF);  // Card / modal bg
  static const surfaceVariant = Color(0xFFF0F4FB);  // Subtle tinted surface
  static const divider        = Color(0xFFE8ECF4);
  static const border         = Color(0xFFD9E1F2);
  static const borderDark     = Color(0xFFB0BDD9);

  // ── Text ────────────────────────────────────────────────────
  static const textPrimary    = Color(0xFF0D1B3E);  // Near-black navy
  static const textSecondary  = Color(0xFF6B7A9B);
  static const textHint       = Color(0xFFADB8CC);
  static const textDisabled   = Color(0xFFCDD3E0);
  static const textOnPrimary  = Color(0xFFFFFFFF);  // White text on blue bg

  // ── Status chips ────────────────────────────────────────────
  static const statusActive   = Color(0xFF1A6FE8);
  static const statusPending  = Color(0xFFFF6B35);
  static const statusSuccess  = Color(0xFF27AE60);
  static const statusCancelled= Color(0xFFE74C3C);
  static const statusGray     = Color(0xFF6B7A9B);

  // ── Map overlays ────────────────────────────────────────────
  static const routePolyline  = Color(0xFF1A6FE8);
  static const originPin      = Color(0xFF27AE60);
  static const destinationPin = Color(0xFFE74C3C);
  static const driverMarker   = Color(0xFF1A6FE8);
  static const locationPulse  = Color(0x331A6FE8);  // 20% opacity blue
}
```

### app_typography.dart
```
class AppTypography {
  static const String fontFamily = 'BeVietnamPro';

  // Display
  static const TextStyle displayLarge  = TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.25);
  static const TextStyle displayMedium = TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3);

  // Headings
  static const TextStyle h1 = TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3);
  static const TextStyle h2 = TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.35);
  static const TextStyle h3 = TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);
  static const TextStyle h4 = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);

  // Body
  static const TextStyle body1 = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.6);
  static const TextStyle body2 = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.6);

  // Labels / Captions
  static const TextStyle label  = TextStyle(fontFamily: fontFamily, fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
  static const TextStyle caption = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textHint);

  // Special
  static const TextStyle button  = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3);
  static const TextStyle price   = TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary);
  static const TextStyle priceLg = TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary);
  static const TextStyle code    = TextStyle(fontFamily: 'monospace', fontSize: 15, letterSpacing: 2, color: AppColors.textPrimary);
}
```

### app_dimensions.dart
```
class AppDimensions {
  // Spacing
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 24;
  static const double x3l = 32;
  static const double x4l = 40;
  static const double x5l = 48;

  // Border radius
  static const double radiusXs  = 4;
  static const double radiusSm  = 8;
  static const double radiusMd  = 12;
  static const double radiusLg  = 16;
  static const double radiusXl  = 20;
  static const double radiusFull = 999; // pill

  // Component sizes
  static const double buttonHeight     = 52;
  static const double buttonHeightSm   = 40;
  static const double inputHeight      = 52;
  static const double appBarHeight     = 56;
  static const double bottomNavHeight  = 72;
  static const double cardElevation    = 4;
  static const double avatarSm         = 36;
  static const double avatarMd         = 48;
  static const double avatarLg         = 72;
  static const double iconSm           = 16;
  static const double iconMd           = 24;
  static const double iconLg           = 32;

  // Page padding
  static const EdgeInsets pagePadding  = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets cardPadding  = EdgeInsets.all(16);
  static const EdgeInsets sectionGap   = EdgeInsets.only(bottom: 24);
}
```

### app_shadows.dart
```
class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x141A6FE8), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> cardHover = [
    BoxShadow(color: Color(0x1F1A6FE8), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> bottomSheet = [
    BoxShadow(color: Color(0x280D1B3E), blurRadius: 32, offset: Offset(0, -8)),
  ];
  static const List<BoxShadow> fab = [
    BoxShadow(color: Color(0x3D1A6FE8), blurRadius: 16, offset: Offset(0, 6)),
  ];
  static const List<BoxShadow> mapControl = [
    BoxShadow(color: Color(0x1A0D1B3E), blurRadius: 12, offset: Offset(0, 2)),
  ];
}
```

### app_theme.dart
Composes the above into ThemeData light and dark.

```
class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    colorScheme: const ColorScheme.light(
      primary:   AppColors.primary,
      secondary: AppColors.accent,
      surface:   AppColors.surface,
      error:     AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.h3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      textStyle: AppTypography.button,
      elevation: 0,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      side: const BorderSide(color: AppColors.primary),
    )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        side: const BorderSide(color: AppColors.divider, width: 0.5),
      ),
    ),
  );

  static ThemeData get dark => light; // TODO: implement dark theme
}
```

## Rules
- NEVER hardcode Color hex values in widgets — always use AppColors.xxx
- NEVER hardcode fontSize — always use AppTypography.xxx
- NEVER hardcode padding/spacing with literal numbers — use AppDimensions.xxx
- NEVER hardcode border radius — use AppDimensions.radiusXxx
