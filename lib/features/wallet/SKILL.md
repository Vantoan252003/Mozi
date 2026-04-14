# feature/wallet — GoWallet & Payments

## Entities
WalletEntity { balance: double, currency: 'VND', pendingBalance: double }

TransactionType { topup, payment, refund, bonus, withdrawal }
TransactionEntity {
  id, type: TransactionType, amount: double, description: String,
  referenceId?: String, createdAt: DateTime,
  status: 'completed'|'pending'|'failed'
}

PaymentMethodType { wallet, momo, zalopay, vnpay, cash }
PaymentMethodEntity {
  id, type: PaymentMethodType, displayName: String,
  iconAsset: String, isDefault: bool, isAvailable: bool
}

TopUpRequestEntity {
  requestId: String, amount: double, method: PaymentMethodType,
  paymentUrl: String, expiredAt: DateTime, status: String
}

## UseCases
GetWalletBalanceUseCase      — call() → WalletEntity
GetTransactionHistoryUseCase — call({page, type?}) → List<TransactionEntity>
CreateTopUpRequestUseCase    — call(amount, method) → TopUpRequestEntity
GetPaymentMethodsUseCase     — call() → List<PaymentMethodEntity>
SetDefaultPaymentUseCase     — call(methodId)

## TopUp Flow (deep link)
1. CreateTopUpRequestUseCase → TopUpRequestEntity.paymentUrl
2. url_launcher.launchUrl(paymentUrl) — opens MoMo/ZaloPay app
3. After payment, payment app redirects to: gomove://payment/result?status=success&ref=xxx
4. GoRouter handles deep link → navigate to WalletPage
5. GetWalletBalanceUseCase called to refresh balance

Deep link is registered:
  Android: intent-filter in AndroidManifest.xml
  iOS:     CFBundleURLSchemes in Info.plist

## Presentation
Cubit: WalletCubit     — loadWallet(), loadMore(), state: Loading|Loaded|Error
Cubit: TopUpCubit      — selectAmount(), selectMethod(), createRequest(),
                          state: Idle|AmountSelected|MethodSelected|Creating|UrlReady(url)|Error

Pages:
  WalletPage              — BalanceCard + QuickActions + TransactionList
  TopUpPage               — Amount grid + PaymentMethod list + Confirm
  TransactionDetailPage   — Single transaction detail

Widgets:
  BalanceCard             — Large balance + "Nạp tiền" + "Lịch sử" buttons
  TransactionTile         — Icon (type) + description + amount (+/-) + date
  TopUpAmountGrid         — Preset: 50k 100k 200k 500k 1M + Custom input
  PaymentMethodCard       — Logo + name + default badge + radio select

## Rules
- NEVER store card numbers or sensitive payment info locally
- Refresh balance after every successful payment (polling or socket event)
- TopUpCubit handles deep link result via NavigationService injection
