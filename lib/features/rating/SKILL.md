# feature/rating — Post-Order Rating

## Entities
RatingTagEntity { tag: String, icon: String, category: 'driver'|'food'|'speed' }
RatingEntity {
  orderId, orderType: 'ride'|'food',
  targetId: String (driverId or restaurantId),
  targetName: String, targetAvatarUrl: String,
  score: int (1-5), comment?: String, tags: List<String>,
  tipAmount: double (0 if no tip)
}

## UseCases
GetRatingTagsUseCase — call(orderType) → List<RatingTagEntity>
SubmitRatingUseCase  — call(RatingEntity)

## Trigger
RatingPage is pushed when:
  a) TrackingBloc emits TrackingCompleted — auto-pushed after 2s delay
  b) User taps "Đánh giá" in OrderHistoryCard (canRate == true)

## Presentation
Cubit: RatingCubit
  State: { selectedScore: int, selectedTags: Set<String>, comment: String,
           selectedTip: double, isSubmitting: bool, isSubmitted: bool, error? }
  Methods: setScore(int), toggleTag(String), setComment(String), setTip(double), submit()

Pages:
  RatingPage — full-screen modal with overlay background

Widgets:
  StarRatingInput    — 5 large interactive stars, spring animation on tap
  RatingTagChips     — multi-select chips, grouped by category
  RatingCommentField — optional multiline TextField, "Nhận xét thêm..."
  TipSelector        — Row of pills: Không / 5K / 10K / 20K / Khác
  SuccessRatingView  — Lottie confetti + "Cảm ơn đánh giá của bạn!"

## Rules
- After submit: mark orderId as rated in Hive (prevent repeat prompt)
- Can be skipped (link "Bỏ qua") — but reminder shown once in OrderHistoryPage
- Tags differ per orderType: ride → driver-focused; food → restaurant + shipper
- Tip flow: UI only, actual charge is separate API call or wallet deduction
