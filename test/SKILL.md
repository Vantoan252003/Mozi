# test/ — Testing

## Structure
Mirror lib/features/ and lib/core/ exactly:
  test/features/<name>/domain/usecases/   — UseCase unit tests
  test/features/<name>/data/repositories/ — RepositoryImpl unit tests
  test/features/<name>/presentation/      — BLoC/Cubit unit tests
  test/core/utils/                        — Utility function tests
  test/shared/widgets/                    — Widget tests

## Test File Naming
Source:  lib/features/auth/domain/usecases/verify_otp_usecase.dart
Test:    test/features/auth/domain/usecases/verify_otp_usecase_test.dart

## Coverage Targets
Domain (UseCases + Entities): ≥ 90%
Data (RepositoryImpl):        ≥ 80%
Presentation (BLoC/Cubit):    ≥ 70%
Core Utils:                   ≥ 90%

## Standard UseCase Test Pattern
```dart
@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepo;
  late VerifyOtpUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase  = VerifyOtpUseCase(mockRepo);
  });

  group('VerifyOtpUseCase', () {
    const tPhone = '0901234567';
    const tOtp   = '123456';
    final tUser  = UserEntity(id: '1', phone: tPhone, ...);

    test('should return UserEntity on success', () async {
      when(mockRepo.verifyOtp(any, any)).thenAnswer((_) async => Right(tUser));
      final result = await useCase(phone: tPhone, otp: tOtp);
      expect(result, Right(tUser));
      verify(mockRepo.verifyOtp(tPhone, tOtp));
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ServerFailure on server error', () async {
      const failure = ServerFailure(message: 'OTP expired');
      when(mockRepo.verifyOtp(any, any)).thenAnswer((_) async => Left(failure));
      final result = await useCase(phone: tPhone, otp: tOtp);
      expect(result, const Left(failure));
    });
  });
}
```

## Standard BLoC Test Pattern (bloc_test)
```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, Authenticated] when AppStarted and token is valid',
  build: () {
    when(mockGetCurrentUser()).thenAnswer((_) async => Right(tUser));
    return AuthBloc(getCurrentUser: mockGetCurrentUser, logout: mockLogout);
  },
  act: (bloc) => bloc.add(AppStarted()),
  expect: () => [AuthLoading(), Authenticated(tUser)],
);
```

## Rules
- Use mockito @GenerateMocks, run build_runner to generate .mocks.dart files
- Test files for generated mocks: <name>_test.mocks.dart (gitignored)
- Each test file has one top-level group named after the class under test
- No shared mutable state between tests — always use setUp()
- Widget tests: use pumpWidget with necessary BLoC providers mocked
