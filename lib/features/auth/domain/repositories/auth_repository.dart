import 'package:dartz/dartz.dart';
import 'package:mozi_v2/core/errors/failures.dart';
import 'package:mozi_v2/features/auth/domain/entities/auth_token_entity.dart';
import 'package:mozi_v2/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Returns true if phone already registered, false if new user.
  Future<Either<Failure, bool>> checkPhone(String phoneNumber);

  /// Sends OTP to the phone. purpose = 'REGISTRATION' or 'LOGIN'.
  Future<Either<Failure, void>> sendOtp(String phoneNumber, String purpose);

  /// Verifies OTP. Returns true on success.
  Future<Either<Failure, bool>> verifyOtp(
      String phoneNumber, String otp, String purpose);

  /// Login with phone and 6-digit password.
  Future<Either<Failure, AuthTokenEntity>> login(
      String phoneNumber, String password);

  /// Register a new rider with first/last name, phone, 6-digit password.
  Future<Either<Failure, void>> register(
      String firstName, String lastName, String phoneNumber, String password);

  /// Get current logged-in rider profile. Requires valid access token.
  Future<Either<Failure, UserEntity>> getProfile();

  /// Logout by userId. Clears tokens from storage.
  Future<Either<Failure, void>> logout(String userId);
}
