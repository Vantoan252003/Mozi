# feature/order_history — Order History

## Entities
OrderSummaryEntity {
  id, orderType: OrderType ('ride'|'food'),
  title: String,        // ride: destination name; food: restaurant name
  statusLabel: String,  // localized display
  statusColor: Color,   // mapped from status
  totalPrice: double, createdAt: DateTime, thumbnailUrl?: String,
  canRate: bool, canReorder: bool (food only)
}
OrderType { ride, food }

## UseCases
GetOrderHistoryUseCase — call({orderType?, page}) → List<OrderSummaryEntity>
ReorderUseCase         — call(orderId) → delegated to CartCubit after fetch

## Presentation
Cubit: OrderHistoryCubit
  State: HistoryLoading | HistoryLoaded { orders, hasMore, filter? } | HistoryError
  Methods: load({filter}), loadMore(), changeFilter(OrderType?)

Pages:
  OrderHistoryPage  — TabBar: Tất cả / Đặt xe / Đồ ăn
                    — InfiniteScroll list + PullToRefresh
  OrderDetailPage   — Full order detail (delegates to ride or food detail)

Widgets:
  OrderHistoryCard  — Thumbnail + title + status chip + price + date + actions
  OrderTypeTab      — Custom tab bar filter
  ReorderButton     — "Đặt lại" pill (food only, completed orders)
  EmptyOrderView    — Lottie empty state

## Rules
- Pagination: 20 items/page, hasMore from API meta
- Re-order: call ReorderUseCase → CartCubit.clearCart() + add all items → go to cart
- Rating CTA only when canRate == true
- Rating tap → push RouteConstants.rating with orderType + orderId
