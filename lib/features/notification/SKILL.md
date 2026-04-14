# feature/notification — In-App Notifications

## Entities
NotificationEntity {
  id, title, body, type: NotificationType, payload?: Map<String,dynamic>,
  isRead: bool, createdAt: DateTime, imageUrl?: String
}
NotificationType { rideUpdate, foodUpdate, promotion, wallet, system }

## UseCases
GetNotificationsUseCase — call({page}) → List<NotificationEntity>
MarkAsReadUseCase       — call(notificationId)
MarkAllReadUseCase      — call()
GetUnreadCountUseCase   — call() → int
RegisterFcmTokenUseCase — call(token: String) — called after login

## FCM Integration (see core/services/notification/SKILL.md)
This feature only handles the LIST and READ operations.
Actual FCM setup is in NotificationService (core/services/).

## Presentation
Cubit: NotificationCubit
  State: NotifInitial | NotifLoading | NotifLoaded { items, unreadCount, hasMore }
       | NotifError(message)
  Methods: load(), loadMore(), markRead(id), markAllRead()
  Note: Listens to SocketService for new_notification events to refresh count

Pages:
  NotificationsPage — List grouped by date ("Hôm nay", "Hôm qua", older)
                    — SwipeToRead (Dismissible)
                    — "Đánh dấu tất cả đã đọc" button in AppBar

Widgets:
  NotificationTile         — Icon (type-based) + title + body + timestamp + unread dot
  NotificationBadge        — Red circle with count, used in HomeTopBar bell icon
  EmptyNotificationView    — Lottie + "Chưa có thông báo"
  NotificationDateDivider  — "Hôm nay" / "Hôm qua" group header
