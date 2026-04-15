import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:mozi_v2/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'otp_state.dart';

@injectable
class OtpCubit extends Cubit<OtpState> {
  final VerifyOtpUseCase _verifyOtp;
  final SendOtpUseCase _sendOtp;

  Timer? _timer;
  int _secondsRemaining = 60;
  String _otp = '';

  OtpCubit(this._verifyOtp, this._sendOtp) : super(const OtpInitial()) {
    _startTimer();
  }

  void appendDigit(String digit) {
    if (_otp.length < 6) {
      _otp += digit;
    }
  }

  void removeDigit() {
    if (_otp.isNotEmpty) {
      _otp = _otp.substring(0, _otp.length - 1);
    }
  }

  String get currentOtp => _otp;

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        emit(OtpInitial(secondsRemaining: _secondsRemaining));
      } else {
        t.cancel();
      }
    });
  }

  Future<void> resendOtp(String phoneNumber, String purpose) async {
    emit(OtpLoading());
    final result = await _sendOtp(phoneNumber, purpose);
    result.fold(
      (failure) => emit(OtpError(failure.message)),
      (_) {
        _otp = '';
        _startTimer();
      },
    );
  }

  Future<void> verifyOtp(String phoneNumber, String purpose) async {
    if (_otp.length != 6) return;
    emit(OtpLoading());
    final result = await _verifyOtp(phoneNumber, _otp, purpose);
    result.fold(
      (failure) => emit(OtpError(failure.message)),
      (isValid) {
        if (isValid) {
          emit(OtpVerified());
        } else {
          emit(const OtpError('Mã OTP không đúng. Vui lòng thử lại.'));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
