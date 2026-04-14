# feature/voucher — Vouchers & Promotions

## Entities
DiscountType { percent, fixed }
VoucherService { all, ride, food, delivery }
VoucherEntity {
  id, code, title, description,
  discountType: DiscountType, discountValue: double,
  minOrderValue: double, maxDiscountAmount?: double,
  expiryDate: DateTime, applicableService: VoucherService,
  isUsed: bool, usageLimit: int, usedCount: int,
  // computed:
  bool get isExpired       => DateTime.now().isAfter(expiryDate)
  bool get isAvailable     => !isUsed && !isExpired && usedCount < usageLimit
  bool get isExpiringSoon  => expiryDate.difference(DateTime.now()).inHours < 24
  double calculateDiscount(double orderValue) {
    if (orderValue < minOrderValue) return 0;
    final raw = discountType == DiscountType.percent
        ? orderValue * discountValue / 100
        : discountValue;
    return maxDiscountAmount != null ? raw.clamp(0, maxDiscountAmount!) : raw;
  }
}

## UseCases
GetMyVouchersUseCase    — call() → List<VoucherEntity>
ApplyVoucherUseCase     — call(code, orderValue, serviceType) → VoucherEntity
GetVoucherDetailUseCase — call(voucherId) → VoucherEntity

## Presentation
Cubit: VoucherCubit
  State: VoucherInitial | VoucherLoading | VoucherLoaded { available[], used[], expired[] }
       | VoucherApplying | VoucherApplied(voucher, discountAmount) | VoucherError(msg)
  Methods: loadVouchers(), applyCode(code, orderValue, serviceType), clearApplied()

Pages:
  VoucherListPage  — TabBar: "Có thể dùng" / "Đã dùng" / "Hết hạn"
                   — Code input row at top
  VoucherDetailPage — Full conditions + barcode

Widgets:
  VoucherCard     — Left accent border (blue/orange/green) + code + discount + expiry
                  — countdown chip if isExpiringSoon
  VoucherCodeInput — TextField + "Áp dụng" button
  DiscountBadge   — "-20%" or "-30.000₫" pill
  ExpiryCountdown — "Còn 23:45:12" countdown for near-expiry

## Rules
- Voucher server validates applicability — client calculateDiscount() is preview only
- Cache vouchers in Hive voucherBox with 5-minute TTL
- isExpiringSoon banner shown in VoucherCard and VoucherListPage header
