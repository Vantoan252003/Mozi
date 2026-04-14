# onboarding/data/
## datasources/
OnboardingLocalDataSource
  hasSeenOnboarding() → bool   (Hive prefsBox read)
  markAsSeen()        → void   (Hive prefsBox write)
## repositories/
OnboardingRepositoryImpl — wraps local datasource, maps CacheException → CacheFailure
