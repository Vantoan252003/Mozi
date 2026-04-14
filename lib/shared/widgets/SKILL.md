# shared/widgets/ — UI Components

## Buttons
app_button.dart
  Variants: AppButtonVariant { primary, secondary, outline, text, danger }
  Props: label, onPressed?, isLoading, variant, icon?, fullWidth
  primary  = blue filled + white text + pill shape
  secondary= orange filled + white text
  outline  = blue border + blue text
  danger   = red border + red text

app_icon_button.dart
  Props: icon, onPressed?, size, backgroundColor?, foregroundColor?, tooltip?

## Form Inputs
app_text_field.dart
  Props: controller, label?, hint?, errorText?, prefixIcon?, suffixIcon?,
         obscureText, keyboardType, validator?, onChanged?, onSubmitted?,
         readOnly, maxLines, enabled
  Uses InputDecorationTheme from AppTheme

app_search_field.dart
  Props: onChanged(debounced 300ms), onClear, hint, autofocus
  Has leading search icon + clear button when non-empty

## Loading / Feedback
app_loading_indicator.dart
  Props: size (sm/md/lg), color?
  Default: CircularProgressIndicator with AppColors.primary

app_skeleton.dart
  Props: width, height, borderRadius
  Shimmer animation — use for placeholder while loading

app_error_widget.dart
  Props: message, onRetry?
  Shows error icon + message + optional retry button

app_empty_state.dart
  Props: animationPath?, title, subtitle?, actionLabel?, onAction?
  Lottie animation + title + subtitle + CTA

## Overlays
app_bottom_sheet.dart
  Static method: AppBottomSheet.show(context, child, title?, isDismissible)
  Adds drag handle + standard padding + safe area handling

app_dialog.dart
  Static method: AppDialog.show(context, title, message, confirmLabel, cancelLabel?,
                                onConfirm, onCancel?, isDestructive)

app_snack_bar.dart
  Static method: AppSnackBar.success(context, message)
  Static method: AppSnackBar.error(context, message)
  Static method: AppSnackBar.info(context, message)
  Uses ScaffoldMessenger, auto-dismiss 3s

## Display Components
app_network_image.dart
  Props: url?, width, height, borderRadius, fit, placeholder?, errorWidget?
  Uses CachedNetworkImage + ShimmerPlaceholder

app_avatar.dart
  Props: imageUrl?, name (for initials fallback), size, onTap?
  Circle avatar — shows initials if no image

star_display.dart
  Props: rating (0.0–5.0), size, color?, showText
  Read-only star rating. Supports half-stars.

price_text.dart
  Props: amount, style?, strikethrough (for original price)
  Always calls FormatUtils.currency() — never formats manually

status_chip.dart
  Props: label, type: StatusType { active, pending, success, cancelled, neutral }
  Colored pill chip, colors from AppColors.statusXxx

info_row.dart
  Props: icon, label, value, valueColor?
  Standard label-value row used in detail pages

## Layout
section_header.dart
  Props: title, actionLabel?, onAction?
  Row: title Text + optional TextButton("Xem thêm")

app_divider.dart
  Thin 0.5px divider with standard horizontal padding

app_card.dart
  Props: child, padding?, onTap?, margin?
  White surface + border + shadow from AppShadows.card + radiusLg

## Map-related
location_dot.dart
  Animated pulsing blue dot for current location on map
  Uses AnimationController for pulse effect

driver_eta_chip.dart
  Pill: "3 phút • 900m" — shown floating on map during tracking

## Barrel export
Create shared/widgets/widgets.dart that exports all widgets:
  export 'app_button.dart';
  export 'app_text_field.dart';
  // ... all files
