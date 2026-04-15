import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/features/auth/domain/usecases/login_usecase.dart';
import 'package:mozi_v2/features/auth/domain/usecases/register_usecase.dart';
import 'set_password_state.dart';

@injectable
class SetPasswordCubit extends Cubit<SetPasswordState> {
  final RegisterUseCase _register;
  final LoginUseCase _login;

  String _newPin = '';
  String _confirmPin = '';
  bool _isConfirmActive = false;

  SetPasswordCubit(this._register, this._login)
      : super(const SetPasswordInitial());

  void appendDigit(String digit) {
    if (!_isConfirmActive) {
      if (_newPin.length < 6) {
        _newPin += digit;
        if (_newPin.length == 6) {
          // Auto-switch to confirm field
          _isConfirmActive = true;
        }
      }
    } else {
      if (_confirmPin.length < 6) {
        _confirmPin += digit;
      }
    }
    _emitCurrent();
  }

  void removeDigit() {
    if (_isConfirmActive) {
      if (_confirmPin.isNotEmpty) {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
      } else {
        // Switch back to new pin field
        _isConfirmActive = false;
      }
    } else {
      if (_newPin.isNotEmpty) {
        _newPin = _newPin.substring(0, _newPin.length - 1);
      }
    }
    _emitCurrent();
  }

  void _emitCurrent() {
    emit(SetPasswordInitial(
      newPin: _newPin,
      confirmPin: _confirmPin,
      isConfirmActive: _isConfirmActive,
    ));
  }

  Future<void> submit({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    if (_newPin.length != 6 || _confirmPin.length != 6) {
      emit(const SetPasswordError('Vui lòng nhập đủ 6 số cho cả hai ô.'));
      _emitCurrent();
      return;
    }
    if (_newPin != _confirmPin) {
      emit(const SetPasswordError(
          'Mật khẩu xác nhận không khớp. Vui lòng thử lại.'));
      _confirmPin = '';
      _isConfirmActive = true;
      _emitCurrent();
      return;
    }

    emit(SetPasswordLoading());

    // Register user
    final registerResult = await _register(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      password: _newPin,
    );

    await registerResult.fold(
      (failure) async => emit(SetPasswordError(failure.message)),
      (_) async {
        // Auto-login after registration
        final loginResult = await _login(phoneNumber, _newPin);
        loginResult.fold(
          (failure) => emit(SetPasswordError(failure.message)),
          (_) => emit(SetPasswordSuccess()),
        );
      },
    );
  }
}
