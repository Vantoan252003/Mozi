import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/constants/storage_keys.dart';
import 'package:mozi_v2/core/storage/secure_storage_service.dart';
import 'package:mozi_v2/features/auth/domain/usecases/check_phone_usecase.dart';
import 'package:mozi_v2/features/auth/domain/usecases/login_usecase.dart';
import 'package:mozi_v2/features/auth/domain/usecases/send_otp_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final CheckPhoneUseCase _checkPhone;
  final SendOtpUseCase _sendOtp;
  final LoginUseCase _login;
  final SecureStorageService _secureStorage;

  String? currentPhone;

  LoginCubit(
    this._checkPhone,
    this._sendOtp,
    this._login,
    this._secureStorage,
  ) : super(LoginInitial());

  Future<void> checkPhone(String phone) async {
    emit(LoginLoading());
    currentPhone = phone;
    final result = await _checkPhone(phone);
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (exists) => emit(LoginPhoneChecked(phoneExists: exists)),
    );
  }

  Future<void> loginWithPassword(String password) async {
    if (currentPhone == null) return;
    emit(LoginLoading());
    final result = await _login(currentPhone!, password);
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (token) async {
        // Save PIN for biometric re-use
        await _secureStorage.write(
            StorageKeys.pinKey(currentPhone!), password);
        emit(LoginSuccess(token.userId));
      },
    );
  }

  Future<void> loginWithBiometricPin() async {
    if (currentPhone == null) return;
    final pin = await _secureStorage.read(StorageKeys.pinKey(currentPhone!));
    if (pin == null) {
      emit(const LoginError('Chưa có mật khẩu được lưu cho Biometric'));
      return;
    }
    await loginWithPassword(pin);
  }

  Future<void> sendOtpForRegistration(String phone) async {
    emit(LoginLoading());
    currentPhone = phone;
    final result = await _sendOtp(phone, 'REGISTRATION');
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (_) => emit(LoginOtpSent()),
    );
  }
}
