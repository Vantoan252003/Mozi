# assets/ — Static Assets

## Naming Conventions
- images/    → img_<description>.png  (e.g. img_onboarding_1.png)
- icons/     → ic_<description>.svg   (e.g. ic_ride.svg)
- animations/→ anim_<description>.json (Lottie)
- fonts/     → [family]-[weight].ttf

## Required Fonts (BeVietnamPro)
fonts/BeVietnamPro-Regular.ttf   weight 400
fonts/BeVietnamPro-Medium.ttf    weight 500
fonts/BeVietnamPro-SemiBold.ttf  weight 600
fonts/BeVietnamPro-Bold.ttf      weight 700
fonts/BeVietnamPro-ExtraBold.ttf weight 800

## Required Images
img_logo.png, img_logo_white.png, img_splash_bg.png
img_onboarding_1.png, img_onboarding_2.png, img_onboarding_3.png
img_avatar_default.png, img_placeholder_food.png, img_placeholder_restaurant.png
img_map_placeholder.png, img_empty_cart.png
img_payment_momo.png, img_payment_zalopay.png, img_payment_vnpay.png, img_payment_cash.png

## Required SVG Icons
ic_ride.svg, ic_car_4.svg, ic_car_7.svg, ic_food.svg, ic_delivery.svg
ic_wallet.svg, ic_voucher.svg, ic_notification.svg, ic_home.svg, ic_profile.svg
ic_history.svg, ic_settings.svg, ic_location_pin.svg
ic_pickup_pin.svg (green), ic_destination_pin.svg (red)
ic_driver_moto.svg (map marker), ic_driver_car.svg, ic_shipper.svg
ic_star_filled.svg, ic_star_half.svg, ic_star_empty.svg
ic_phone.svg, ic_chat.svg, ic_shield.svg, ic_camera.svg
ic_check_circle.svg, ic_close_circle.svg, ic_warning.svg

## Required Lottie Animations
anim_splash.json            — Logo splash animation
anim_searching_driver.json  — Radar pulse while finding driver
anim_driver_coming.json     — Animated driver coming towards you
anim_food_preparing.json    — Chef cooking
anim_delivery_coming.json   — Shipper on scooter
anim_completed.json         — Confetti / checkmark success
anim_rating_success.json    — Confetti after rating submitted
anim_loading.json           — Generic loading spinner
anim_empty_ride.json        — Empty state for ride tab
anim_empty_food.json        — Empty state for food tab
anim_empty_notification.json— Empty notifications
anim_empty_cart.json        — Empty cart
anim_empty_order.json       — No order history
anim_no_internet.json       — No connection
anim_location_searching.json— GPS acquiring

## Rules
- All Lottie files must be ≤ 200KB (optimize at lottiefiles.com)
- SVG icons use outline style, 24×24 viewBox
- PNG images provide @2x and @3x resolution where possible
- All fonts and assets declared in pubspec.yaml flutter.assets / flutter.fonts
