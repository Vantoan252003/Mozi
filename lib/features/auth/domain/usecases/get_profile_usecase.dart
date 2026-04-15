import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/errors/failures.dart';
import 'package:mozi_v2/features/auth/domain/entities/user_entity.dart';
import 'package:mozi_v2/features/auth/domain/repositories/auth_repository.dart';

@injectable
class GetProfileUseCase {
  final AuthRepository _repository;
  const GetProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() => _repository.getProfile();
}
