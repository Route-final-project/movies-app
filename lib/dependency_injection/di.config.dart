// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../data_source/auth_data_source/auth_remote_data_source.dart' as _i770;
import '../data_source/auth_data_source/auth_remote_data_source_imp.dart'
    as _i669;
import '../data_source/remote_data_source/dio_module.dart' as _i279;
import '../data_source/remote_data_source/remoteDataSource.dart' as _i514;
import '../data_source/repository_imp/auth_repository_imp.dart' as _i780;
import '../data_source/repository_imp/movieRepositoryImp.dart' as _i288;
import '../domain/repository_interface/auth_repository.dart' as _i432;
import '../domain/repository_interface/movieRepository.dart' as _i603;
import '../domain/usecase/forget_password_use_case.dart' as _i598;
import '../domain/usecase/get_latest_movies_use_case.dart' as _i729;
import '../domain/usecase/google_sign_in_use_case.dart' as _i804;
import '../domain/usecase/register_use_case.dart' as _i491;
import '../domain/usecase/sign_in_use_case.dart' as _i50;
import '../presentation/feature/auth/cubit/auth_cubit.dart' as _i1060;
import '../presentation/feature/home/available_movies_cubit/available_movies_cubit.dart'
    as _i774;
import 'firebase_module.dart' as _i616;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i514.RemoteDataSource>(
      () => _i514.RemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i770.AuthRemoteDataSource>(
      () => _i669.AuthRemoteDataSourceImp(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i603.MovieRepository>(
      () => _i288.MovieRepositoryImp(
        remoteDataSource: gh<_i514.RemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i432.AuthRepository>(
      () => _i780.AuthRepositoryImp(gh<_i770.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i729.GetLatestMoviesUseCase>(
      () => _i729.GetLatestMoviesUseCase(
        movieRepository: gh<_i603.MovieRepository>(),
      ),
    );
    gh.lazySingleton<_i598.ForgetPasswordUseCase>(
      () => _i598.ForgetPasswordUseCase(
        authRepository: gh<_i432.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i804.GoogleSignInUseCase>(
      () =>
          _i804.GoogleSignInUseCase(authRepository: gh<_i432.AuthRepository>()),
    );
    gh.lazySingleton<_i491.RegisterUseCase>(
      () => _i491.RegisterUseCase(authRepository: gh<_i432.AuthRepository>()),
    );
    gh.lazySingleton<_i50.SignInUseCase>(
      () => _i50.SignInUseCase(authRepository: gh<_i432.AuthRepository>()),
    );
    gh.factory<_i774.AvailableMoviesCubit>(
      () => _i774.AvailableMoviesCubit(
        getLatestMoviesUseCase: gh<_i729.GetLatestMoviesUseCase>(),
      ),
    );
    gh.factory<_i1060.AuthCubit>(
      () => _i1060.AuthCubit(
        signInUseCase: gh<_i50.SignInUseCase>(),
        googleSignInUseCase: gh<_i804.GoogleSignInUseCase>(),
        registerUseCase: gh<_i491.RegisterUseCase>(),
        forgetPasswordUseCase: gh<_i598.ForgetPasswordUseCase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i279.NetworkModule {}

class _$FirebaseModule extends _i616.FirebaseModule {}
