import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();
  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {
  final int secondsRemaining;
  const OtpInitial({this.secondsRemaining = 60});
  @override
  List<Object?> get props => [secondsRemaining];
}

class OtpLoading extends OtpState {}

class OtpVerified extends OtpState {}

class OtpError extends OtpState {
  final String message;
  const OtpError(this.message);
  @override
  List<Object?> get props => [message];
}
