import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/errors/failures.dart';
import 'package:mozi_v2/features/auth/domain/repositories/auth_repository.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepository _repository;
  const VerifyOtpUseCase(this._repository);

  Future<Either<Failure, bool>> call(
          String phoneNumber, String otp, String purpose) =>
      _repository.verifyOtp(phoneNumber, otp, purpose);
}
