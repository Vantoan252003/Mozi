# onboarding/presentation/
## pages/
OnboardingPage — full-screen PageView, 3 slides

## widgets/
OnboardingSlideWidget   — takes OnboardingSlideEntity, shows Lottie + text
OnboardingDotIndicator  — takes pageCount + currentPage
OnboardingNavButtons    — isLastPage toggles "Next" ↔ "Bắt đầu"

## cubit/
OnboardingCubit(CompleteOnboardingUseCase)
  state: OnboardingState { currentPage, totalPages, isLastPage }
  nextPage(), complete() → calls usecase then context.go(RouteConstants.login)
