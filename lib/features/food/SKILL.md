# feature/food — Food Ordering

## Full User Flow
1. FoodHomePage: search bar + category chips + restaurant list
2. RestaurantDetailPage: menu grouped by category
3. MenuItemCard: tap → MenuOptionSheet (toppings, size) → add to CartCubit
4. CartPage: review + note + voucher → FoodCheckoutPage
5. FoodCheckoutPage: delivery address + payment → PlaceFoodOrderUseCase
6. FoodTrackingPage: socket status updates + shipper location
7. On completion → RatingPage

## Cart: GLOBAL SINGLETON
CartCubit is @singleton, provided at MaterialApp level.
ALL food pages share the same CartCubit instance.
Cart is persisted to Hive cartBox to survive app restarts.

## Entities
RestaurantEntity {
  id, name, logoUrl, bannerUrl, address, lat, lng,
  rating, ratingCount, estimatedDeliveryMinutes,
  deliveryFee, minimumOrderAmount, distanceKm,
  cuisineTypes: List<String>, tags: List<String>,
  isOpen: bool, isFeatured: bool, isNew: bool
}

MenuCategoryEntity { id, name, displayOrder, restaurantId }

MenuItemEntity {
  id, name, price, imageUrl?, description?,
  categoryId, isAvailable: bool, isBestseller: bool,
  optionGroups: List<MenuOptionGroupEntity>
}

MenuOptionGroupEntity {
  name: String, isRequired: bool, maxSelect: int,
  options: List<MenuOptionEntity>
}

MenuOptionEntity { id: String, name: String, extraPrice: double }

CartItemEntity {
  menuItem: MenuItemEntity,
  quantity: int,
  selectedOptions: List<MenuOptionEntity>,
  note?: String
  // computed:
  double get optionsExtraPrice => selectedOptions.fold(0, (s,o) => s + o.extraPrice)
  double get unitPrice         => menuItem.price + optionsExtraPrice
  double get subtotal          => unitPrice * quantity
}

FoodOrderStatus {
  pending, confirmed, preparing, pickedUp, delivering, delivered, cancelled
}

FoodOrderEntity {
  id, status: FoodOrderStatus, restaurant: RestaurantEntity,
  items: List<CartItemEntity>, deliveryAddress: String,
  deliveryLat: double, deliveryLng: double,
  subtotal: double, deliveryFee: double, discount: double, total: double,
  paymentMethod: String, note?: String,
  shipper?: ShipperEntity, createdAt: DateTime
}

ShipperEntity { id, name, phone, avatarUrl, rating, currentLat?, currentLng? }

## UseCases
GetRestaurantsUseCase       — call({lat, lng, category?, query?, sort?, page})
GetRestaurantDetailUseCase  — call(restaurantId)
GetMenuUseCase              — call(restaurantId)
PlaceFoodOrderUseCase       — call({restaurantId, items, deliveryAddr, payment, note?, voucherId?})
GetFoodOrderDetailUseCase   — call(orderId)
GetFoodOrderHistoryUseCase  — call({page})
CancelFoodOrderUseCase      — call(orderId)
ReorderUseCase              — call(orderId) → List<CartItemEntity> (rebuild cart from old order)

## CartCubit — Global State
IMPORTANT: @singleton in DI, provided at root level.
State: CartState
  CartEmpty
  CartLoaded { restaurant, items, subtotal, deliveryFee, discountAmount, total }
  CartRestaurantConflict { currentRestaurant, newRestaurant, pendingItem }

Methods:
  addItem(restaurant, menuItem, {qty, options, note?})
    → if different restaurant: emit CartRestaurantConflict
    → if same item exists: increment qty
    → persist to Hive
  removeItem(menuItemId)
  updateQuantity(menuItemId, qty)
  updateNote(menuItemId, note)
  applyVoucher(VoucherEntity)
  clearCart()
  restoreFromCache()  — called on app startup

## Presentation
Cubit: RestaurantListCubit — load, filter(category), search(query), sort, loadMore
Cubit: RestaurantDetailCubit — loadRestaurant(id), loadMenu(id), grouped menu
Cubit: FoodCheckoutCubit — deliveryAddress, payment, note, priceCalc
BLoC: FoodOrderBloc — PlaceOrder flow
  Events: PlaceOrder, OrderConfirmed, OrderCancelled
  States: OrderIdle, OrderPlacing, OrderPlaced(orderId), OrderError(message)

Pages:
  FoodHomePage           — search + category + restaurant list + featured section
  RestaurantDetailPage   — SliverAppBar hero + info + menu by category
  CartPage               — Items + qty controls + note + voucher row + totals
  FoodCheckoutPage       — Address + payment + note + order summary + "Đặt hàng"
  FoodTrackingPage       — Status stepper + shipper card + map

Widgets:
  RestaurantCard           — photo + name + rating + delivery info + tags
  FoodCategoryChips        — horizontal scrollable chips (All, Bún phở, Cơm, ...)
  MenuItemCard             — photo + name + price + bestseller badge + "+" button
  MenuOptionSheet          — BottomSheet for toppings/size selection
  CartItemTile             — photo + name + options summary + qty stepper + note
  CartBadge                — Floating badge on food tab icon
  CartSummaryBar           — Persistent bottom bar: qty + subtotal + "Xem giỏ hàng"
  FoodStatusStepper        — Horizontal: confirmed→preparing→picked_up→delivering→done
  ShipperInfoCard          — Avatar + name + rating + call button

## Rules
- CartCubit.restoreFromCache() must be called in main() after StorageService.init()
- Menu loaded lazily (only when user opens RestaurantDetailPage)
- MenuOptionSheet: required groups must be satisfied before addItem is enabled
- FoodTrackingPage uses TrackingBloc from feature/tracking
