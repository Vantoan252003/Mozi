import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mozi_v2/core/constants/storage_keys.dart';
import 'package:mozi_v2/core/storage/secure_storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorageService _secureStorage;

  AuthBloc(this._secureStorage) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      // Read the stored userId if available; fall back to a placeholder
      final userId =
          await _secureStorage.read(StorageKeys.userPhone) ?? '';
      emit(Authenticated(userId));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) {
    emit(Authenticated(event.userId));
  }

  Future<void> _onLoggedOut(
      LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // Best-effort logout — ignore errors in bloc layer
    await _secureStorage.deleteAll();
    emit(Unauthenticated());
  }
}
