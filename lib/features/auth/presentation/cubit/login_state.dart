import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginPhoneChecked extends LoginState {
  final bool phoneExists;
  const LoginPhoneChecked({required this.phoneExists});
  @override
  List<Object?> get props => [phoneExists];
}

class LoginOtpSent extends LoginState {}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
  @override
  List<Object?> get props => [message];
}

class LoginSuccess extends LoginState {
  final String userId;
  const LoginSuccess(this.userId);
  @override
  List<Object?> get props => [userId];
}
