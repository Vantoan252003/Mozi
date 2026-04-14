# feature/onboarding — First-Launch Onboarding

## Purpose
Display 3 intro slides the first time the user opens the app.
After completing or skipping, persist the "seen" flag so it never shows again.
The route guard in core/router/ reads this flag.

## Domain
Entities:
  OnboardingSlideEntity  — index, title, description, animationPath, backgroundColor

UseCases:
  HasSeenOnboardingUseCase  — call() → bool (reads from Hive prefsBox)
  CompleteOnboardingUseCase — call() → void (writes flag to Hive)

Repository:
  OnboardingRepository (abstract) → OnboardingRepositoryImpl

## Data
DataSource:
  OnboardingLocalDataSource — reads/writes HiveConstants.keyHasSeenOnboarding
  No remote datasource (slides are hardcoded or from remote config)

Model:
  No model needed — slides are static content

## Presentation
Cubit:
  OnboardingCubit
    state: OnboardingState { currentPage: int, isLastPage: bool }
    methods: nextPage(), skipToEnd(), complete()

Page:
  OnboardingPage
    - PageView of OnboardingSlideWidget
    - smooth dot indicator
    - "Skip" button top-right (visible on first 2 pages)
    - "Next" / "Bắt đầu" button bottom

Widgets:
  OnboardingSlideWidget  — Lottie animation + title + description
  OnboardingDotIndicator — current page dots
  OnboardingNavButtons   — Skip + Next/Start
