import 'package:equatable/equatable.dart';

abstract class SetPasswordState extends Equatable {
  const SetPasswordState();
  @override
  List<Object?> get props => [];
}

class SetPasswordInitial extends SetPasswordState {
  final String newPin;
  final String confirmPin;
  final bool isConfirmActive;
  const SetPasswordInitial({
    this.newPin = '',
    this.confirmPin = '',
    this.isConfirmActive = false,
  });
  @override
  List<Object?> get props => [newPin, confirmPin, isConfirmActive];
}

class SetPasswordLoading extends SetPasswordState {}

class SetPasswordSuccess extends SetPasswordState {}

class SetPasswordError extends SetPasswordState {
  final String message;
  const SetPasswordError(this.message);
  @override
  List<Object?> get props => [message];
}
