import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/constants/storage_keys.dart';
import 'package:mozi_v2/core/errors/exceptions.dart';
import 'package:mozi_v2/core/errors/failures.dart';
import 'package:mozi_v2/core/storage/secure_storage_service.dart';
import 'package:mozi_v2/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mozi_v2/features/auth/domain/entities/auth_token_entity.dart';
import 'package:mozi_v2/features/auth/domain/entities/user_entity.dart';
import 'package:mozi_v2/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, bool>> checkPhone(String phoneNumber) async {
    try {
      final result = await _remoteDataSource.checkPhone(phoneNumber);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(
      String phoneNumber, String purpose) async {
    try {
      await _remoteDataSource.sendOtp(phoneNumber, purpose);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(
      String phoneNumber, String otp, String purpose) async {
    try {
      final result =
          await _remoteDataSource.verifyOtp(phoneNumber, otp, purpose);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokenEntity>> login(
      String phoneNumber, String password) async {
    try {
      final tokenModel = await _remoteDataSource.login(phoneNumber, password);
      // Store tokens securely
      await _secureStorage.write(
          StorageKeys.accessToken, tokenModel.accessToken);
      await _secureStorage.write(
          StorageKeys.refreshToken, tokenModel.refreshToken);
      await _secureStorage.write(StorageKeys.userPhone, phoneNumber);
      return Right(tokenModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> register(String firstName, String lastName,
      String phoneNumber, String password) async {
    try {
      await _remoteDataSource.register(
          firstName, lastName, phoneNumber, password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userModel = await _remoteDataSource.getProfile();
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout(String userId) async {
    try {
      await _remoteDataSource.logout(userId);
      await _secureStorage.deleteAll();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
