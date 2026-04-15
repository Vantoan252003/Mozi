part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String userId;
  LoggedIn(this.userId);
}

class LoggedOut extends AuthEvent {}
