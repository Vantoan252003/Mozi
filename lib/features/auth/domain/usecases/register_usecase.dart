import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/errors/failures.dart';
import 'package:mozi_v2/features/auth/domain/repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String password,
  }) =>
      _repository.register(firstName, lastName, phoneNumber, password);
}
