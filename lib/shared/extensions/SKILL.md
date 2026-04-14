# shared/extensions/ — Dart Extension Methods

## context_extensions.dart (on BuildContext)
```
ThemeData      get theme         => Theme.of(this)
ColorScheme    get colors        => Theme.of(this).colorScheme
TextTheme      get textTheme     => Theme.of(this).textTheme
MediaQueryData get mq            => MediaQuery.of(this)
double         get screenWidth   => mq.size.width
double         get screenHeight  => mq.size.height
double         get topPadding    => mq.padding.top
double         get bottomPadding => mq.padding.bottom
bool           get isTablet      => screenWidth >= 600
bool           get isDark        => theme.brightness == Brightness.dark
void           showSuccess(String msg) => AppSnackBar.success(this, msg)
void           showError(String msg)   => AppSnackBar.error(this, msg)
void           showInfo(String msg)    => AppSnackBar.info(this, msg)
Future<T?>     showAppBottomSheet<T>(Widget child, {String? title})
```

## string_extensions.dart (on String)
```
String  get capitalize    => isEmpty ? this : this[0].toUpperCase() + substring(1)
String  get titleCase     => split(' ').map((w) => w.capitalize).join(' ')
bool    get isValidVNPhone => RegExp(r'^(0[3|5|7|8|9])[0-9]{8}$').hasMatch(this)
bool    get isValidEmail
bool    get isValidOtp     => RegExp(r'^[0-9]{6}$').hasMatch(this)
String  get maskPhone      => FormatUtils.maskPhone(this)
String  truncate(int max)  => length <= max ? this : '${substring(0, max)}...'
String  get toSlug         => toLowerCase().replaceAll(' ', '-')
```

## datetime_extensions.dart (on DateTime)
```
bool    get isToday
bool    get isYesterday
bool    get isTomorrow
String  get toVNDate         // "25/12/2024"
String  get toVNDateTime     // "14:30 25/12/2024"
String  get toTimeOnly       // "14:30"
String  get timeAgo          // "5 phút trước"
String  get toRelativeDate   // "Hôm nay" | "Hôm qua" | "25/12/2024"
```

## num_extensions.dart (on num)
```
String  get toCurrency       // "50.000 ₫"
String  get toDistanceLabel  // "1.5 km" | "500 m"
String  get toDurationLabel  // "2g 30p" | "45 phút"
String  get toPercent        // "25%"
double  get toRadians        // for map rotation/animation
```

## widget_extensions.dart (on Widget)
```
Padding   padAll(double v)
Padding   padHorizontal(double h)
Padding   padVertical(double v)
Padding   padOnly({double left=0, right=0, top=0, bottom=0})
GestureDetector onTap(VoidCallback fn)
Visibility withVisibility(bool visible)
Center    centered()
Expanded  expanded({int flex = 1})
SizedBox  withSize({double? width, double? height})
```

## list_extensions.dart (on List<T>)
```
Map<K, List<T>> groupBy<K>(K Function(T) key)
T?              safeGet(int index)
List<Widget>    intersperse(Widget separator)  // on List<Widget>
```
