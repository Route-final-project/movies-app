// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../data_source/auth_data_source/auth_remote_data_source.dart' as _i770;
import '../data_source/auth_data_source/auth_remote_data_source_imp.dart'
    as _i669;
import '../data_source/profile_data_source/profile_remote_data_source.dart'
    as _i18;
import '../data_source/profile_data_source/profile_remote_data_source_imp.dart'
    as _i787;
import '../data_source/remote_data_source/dio_module.dart' as _i279;
import '../data_source/remote_data_source/remoteDataSource.dart' as _i514;
import '../data_source/repository_imp/auth_repository_imp.dart' as _i780;
import '../data_source/repository_imp/movieRepositoryImp.dart' as _i288;
import '../data_source/repository_imp/profile_repository_imp.dart' as _i941;
import '../domain/repository_interface/auth_repository.dart' as _i432;
import '../domain/repository_interface/movieRepository.dart' as _i603;
import '../domain/repository_interface/profile_repository.dart' as _i843;
import '../domain/usecase/add_movie_to_history_use_case.dart' as _i165;
import '../domain/usecase/add_movie_to_wishlist_use_case.dart' as _i397;
import '../domain/usecase/browse_movies_use_case.dart' as _i724;
import '../domain/usecase/delete_account_use_case.dart' as _i895;
import '../domain/usecase/forget_password_use_case.dart' as _i598;
import '../domain/usecase/get_latest_movies_use_case.dart' as _i729;
import '../domain/usecase/get_profile_use_case.dart' as _i937;
import '../domain/usecase/get_movie_details_by_id_user_case.dart' as _i814;
import '../domain/usecase/get_similar_movies_use_case.dart' as _i910;
import '../domain/usecase/google_sign_in_use_case.dart' as _i804;
import '../domain/usecase/register_use_case.dart' as _i491;
import '../domain/usecase/search_movies_use_case.dart' as _i762;
import '../domain/usecase/sign_in_use_case.dart' as _i50;
import '../domain/usecase/sign_out_use_case.dart' as _i885;
import '../domain/usecase/update_profile_use_case.dart' as _i74;
import '../presentation/feature/auth/cubit/auth_cubit.dart' as _i1060;
import '../presentation/feature/browse/browse_cubit.dart' as _i372;
import '../presentation/feature/home/available_movies_cubit/available_movies_cubit.dart'
    as _i774;
import '../presentation/feature/home/home_category_cubit/home_category_cubit.dart'
    as _i284;
import '../presentation/feature/profile/cubit/profile_cubit.dart' as _i559;
import '../presentation/feature/movie_detail/movie_detail_cubit.dart' as _i1058;
import '../presentation/feature/search/search_cubit.dart' as _i962;
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
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i514.RemoteDataSource>(
      () => _i514.RemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i770.AuthRemoteDataSource>(
      () => _i669.AuthRemoteDataSourceImp(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i18.ProfileRemoteDataSource>(
      () => _i787.ProfileRemoteDataSourceImp(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
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
    gh.lazySingleton<_i843.ProfileRepository>(
      () => _i941.ProfileRepositoryImp(gh<_i18.ProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i814.GetMovieDetailsByIdUserCase>(
      () => _i814.GetMovieDetailsByIdUserCase(gh<_i603.MovieRepository>()),
    );
    gh.lazySingleton<_i724.BrowseMoviesUseCase>(
      () => _i724.BrowseMoviesUseCase(
        movieRepository: gh<_i603.MovieRepository>(),
      ),
    );
    gh.lazySingleton<_i729.GetLatestMoviesUseCase>(
      () => _i729.GetLatestMoviesUseCase(
        movieRepository: gh<_i603.MovieRepository>(),
      ),
    );
    gh.lazySingleton<_i910.GetSimilarMoviesUseCase>(
      () => _i910.GetSimilarMoviesUseCase(
        movieRepository: gh<_i603.MovieRepository>(),
      ),
    );
    gh.lazySingleton<_i762.SearchMoviesUseCase>(
      () => _i762.SearchMoviesUseCase(
        movieRepository: gh<_i603.MovieRepository>(),
      ),
    );
    gh.lazySingleton<_i895.DeleteAccountUseCase>(
      () => _i895.DeleteAccountUseCase(
        authRepository: gh<_i432.AuthRepository>(),
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
    gh.lazySingleton<_i885.SignOutUseCase>(
      () => _i885.SignOutUseCase(authRepository: gh<_i432.AuthRepository>()),
    );
    gh.lazySingleton<_i165.AddMovieToHistoryUseCase>(
      () => _i165.AddMovieToHistoryUseCase(
        profileRepository: gh<_i843.ProfileRepository>(),
      ),
    );
    gh.lazySingleton<_i397.AddMovieToWishlistUseCase>(
      () => _i397.AddMovieToWishlistUseCase(
        profileRepository: gh<_i843.ProfileRepository>(),
      ),
    );
    gh.lazySingleton<_i937.GetProfileUseCase>(
      () => _i937.GetProfileUseCase(
        profileRepository: gh<_i843.ProfileRepository>(),
      ),
    );
    gh.lazySingleton<_i74.UpdateProfileUseCase>(
      () => _i74.UpdateProfileUseCase(
        profileRepository: gh<_i843.ProfileRepository>(),
      ),
    );
    gh.factory<_i774.AvailableMoviesCubit>(
      () => _i774.AvailableMoviesCubit(
        getLatestMoviesUseCase: gh<_i729.GetLatestMoviesUseCase>(),
        addMovieToHistoryUseCase: gh<_i165.AddMovieToHistoryUseCase>(),
        addMovieToWishlistUseCase: gh<_i397.AddMovieToWishlistUseCase>(),
      ),
    );
    gh.factory<_i284.HomeCategoryCubit>(
      () => _i284.HomeCategoryCubit(
        browseMoviesUseCase: gh<_i724.BrowseMoviesUseCase>(),
        addMovieToHistoryUseCase: gh<_i165.AddMovieToHistoryUseCase>(),
        addMovieToWishlistUseCase: gh<_i397.AddMovieToWishlistUseCase>(),
      ),
    );
    gh.factoryParam<_i372.BrowseCubit, String?, dynamic>(
      (initialGenre, _) => _i372.BrowseCubit(
        browseMoviesUseCase: gh<_i724.BrowseMoviesUseCase>(),
        addMovieToHistoryUseCase: gh<_i165.AddMovieToHistoryUseCase>(),
        addMovieToWishlistUseCase: gh<_i397.AddMovieToWishlistUseCase>(),
        initialGenre: initialGenre,
      ),
    );
    gh.factory<_i1058.MovieDetailCubit>(
      () => _i1058.MovieDetailCubit(
        getMovieDetailsByIdUserCase: gh<_i814.GetMovieDetailsByIdUserCase>(),
        getSimilarMoviesUseCase: gh<_i910.GetSimilarMoviesUseCase>(),
        movieId: gh<int>(),
      ),
    );
    gh.factory<_i962.SearchCubit>(
      () => _i962.SearchCubit(
        searchMoviesUseCase: gh<_i762.SearchMoviesUseCase>(),
        addMovieToHistoryUseCase: gh<_i165.AddMovieToHistoryUseCase>(),
        addMovieToWishlistUseCase: gh<_i397.AddMovieToWishlistUseCase>(),
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
    gh.factory<_i559.ProfileCubit>(
      () => _i559.ProfileCubit(
        getProfileUseCase: gh<_i937.GetProfileUseCase>(),
        updateProfileUseCase: gh<_i74.UpdateProfileUseCase>(),
        signOutUseCase: gh<_i885.SignOutUseCase>(),
        forgetPasswordUseCase: gh<_i598.ForgetPasswordUseCase>(),
        deleteAccountUseCase: gh<_i895.DeleteAccountUseCase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i279.NetworkModule {}

class _$FirebaseModule extends _i616.FirebaseModule {}
