import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/errors/failures.dart';
import 'package:mozi_v2/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call(String userId) =>
      _repository.logout(userId);
}
