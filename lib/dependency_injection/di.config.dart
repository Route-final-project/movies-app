// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data_source/remote_data_source/dio_module.dart' as _i279;
import '../data_source/remote_data_source/remoteDataSource.dart' as _i514;
import '../data_source/repository_imp/movieRepositoryImp.dart' as _i288;
import '../domain/repository_interface/movieRepository.dart' as _i603;
import '../domain/usecase/get_latest_movies_use_case.dart' as _i729;
import '../domain/usecase/search_movies_use_case.dart' as _i762;
import '../presentation/feature/home/available_movies_cubit/available_movies_cubit.dart'
    as _i774;
import '../presentation/feature/search/search_cubit.dart' as _i962;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i514.RemoteDataSource>(
      () => _i514.RemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i603.MovieRepository>(
      () => _i288.MovieRepositoryImp(
        remoteDataSource: gh<_i514.RemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i729.GetLatestMoviesUseCase>(
      () => _i729.GetLatestMoviesUseCase(
        movieRepository: gh<_i603.MovieRepository>(),
      ),
    );
    gh.lazySingleton<_i762.SearchMoviesUseCase>(
      () => _i762.SearchMoviesUseCase(
        movieRepository: gh<_i603.MovieRepository>(),
      ),
    );
    gh.factory<_i962.SearchCubit>(
      () => _i962.SearchCubit(
        searchMoviesUseCase: gh<_i762.SearchMoviesUseCase>(),
      ),
    );
    gh.factory<_i774.AvailableMoviesCubit>(
      () => _i774.AvailableMoviesCubit(
        getLatestMoviesUseCase: gh<_i729.GetLatestMoviesUseCase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i279.NetworkModule {}
