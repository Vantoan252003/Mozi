# onboarding/domain/
## entities/
OnboardingSlideEntity {
  final int index;
  final String title;
  final String description;
  final String animationAssetPath;  // Lottie JSON path
  final Color backgroundColor;
}
## usecases/
HasSeenOnboardingUseCase    — call() → Future<Either<Failure, bool>>
CompleteOnboardingUseCase   — call() → Future<Either<Failure, void>>
