// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mozi_v2/core/network/interceptors/auth_interceptor.dart'
    as _i865;
import 'package:mozi_v2/core/network/interceptors/error_interceptor.dart'
    as _i18;
import 'package:mozi_v2/core/network/network_module.dart' as _i486;
import 'package:mozi_v2/core/storage/secure_storage_service.dart' as _i444;
import 'package:mozi_v2/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i704;
import 'package:mozi_v2/features/auth/data/repositories/auth_repository_impl.dart'
    as _i221;
import 'package:mozi_v2/features/auth/domain/repositories/auth_repository.dart'
    as _i52;
import 'package:mozi_v2/features/auth/domain/usecases/check_phone_usecase.dart'
    as _i1041;
import 'package:mozi_v2/features/auth/domain/usecases/get_profile_usecase.dart'
    as _i10;
import 'package:mozi_v2/features/auth/domain/usecases/login_usecase.dart'
    as _i184;
import 'package:mozi_v2/features/auth/domain/usecases/logout_usecase.dart'
    as _i1000;
import 'package:mozi_v2/features/auth/domain/usecases/register_usecase.dart'
    as _i653;
import 'package:mozi_v2/features/auth/domain/usecases/send_otp_usecase.dart'
    as _i162;
import 'package:mozi_v2/features/auth/domain/usecases/verify_otp_usecase.dart'
    as _i980;
import 'package:mozi_v2/features/auth/presentation/bloc/auth_bloc.dart'
    as _i797;
import 'package:mozi_v2/features/auth/presentation/cubit/login_cubit.dart'
    as _i861;
import 'package:mozi_v2/features/auth/presentation/cubit/otp_cubit.dart'
    as _i144;
import 'package:mozi_v2/features/auth/presentation/cubit/set_password_cubit.dart'
    as _i1069;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.factory<_i18.ErrorInterceptor>(() => _i18.ErrorInterceptor());
    gh.lazySingleton<_i444.SecureStorageService>(
        () => _i444.SecureStorageService());
    gh.factory<_i865.AuthInterceptor>(
        () => _i865.AuthInterceptor(gh<_i444.SecureStorageService>()));
    gh.singleton<_i797.AuthBloc>(
        () => _i797.AuthBloc(gh<_i444.SecureStorageService>()));
    gh.singleton<_i361.Dio>(() => networkModule.dio(
          gh<_i865.AuthInterceptor>(),
          gh<_i18.ErrorInterceptor>(),
        ));
    gh.lazySingleton<_i704.AuthRemoteDataSource>(
        () => _i704.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i52.AuthRepository>(() => _i221.AuthRepositoryImpl(
          gh<_i704.AuthRemoteDataSource>(),
          gh<_i444.SecureStorageService>(),
        ));
    gh.factory<_i653.RegisterUseCase>(
        () => _i653.RegisterUseCase(gh<_i52.AuthRepository>()));
    gh.factory<_i1041.CheckPhoneUseCase>(
        () => _i1041.CheckPhoneUseCase(gh<_i52.AuthRepository>()));
    gh.factory<_i184.LoginUseCase>(
        () => _i184.LoginUseCase(gh<_i52.AuthRepository>()));
    gh.factory<_i1000.LogoutUseCase>(
        () => _i1000.LogoutUseCase(gh<_i52.AuthRepository>()));
    gh.factory<_i10.GetProfileUseCase>(
        () => _i10.GetProfileUseCase(gh<_i52.AuthRepository>()));
    gh.factory<_i162.SendOtpUseCase>(
        () => _i162.SendOtpUseCase(gh<_i52.AuthRepository>()));
    gh.factory<_i980.VerifyOtpUseCase>(
        () => _i980.VerifyOtpUseCase(gh<_i52.AuthRepository>()));
    gh.factory<_i861.LoginCubit>(() => _i861.LoginCubit(
          gh<_i1041.CheckPhoneUseCase>(),
          gh<_i162.SendOtpUseCase>(),
          gh<_i184.LoginUseCase>(),
          gh<_i444.SecureStorageService>(),
        ));
    gh.factory<_i144.OtpCubit>(() => _i144.OtpCubit(
          gh<_i980.VerifyOtpUseCase>(),
          gh<_i162.SendOtpUseCase>(),
        ));
    gh.factory<_i1069.SetPasswordCubit>(() => _i1069.SetPasswordCubit(
          gh<_i653.RegisterUseCase>(),
          gh<_i184.LoginUseCase>(),
        ));
    return this;
  }
}

class _$NetworkModule extends _i486.NetworkModule {}
