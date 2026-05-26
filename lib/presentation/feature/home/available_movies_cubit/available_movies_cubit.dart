import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/domain/app_error.dart';
import 'package:movies/presentation/feature/movie_detail/movie_detail_cubit.dart';

import '../../../../domain/entity/movie_entity.dart';
import '../../../../domain/usecase/add_movie_to_history_use_case.dart';
import '../../../../domain/usecase/get_latest_movies_use_case.dart';

part 'available_movies_state.dart';

@injectable
class AvailableMoviesCubit extends Cubit<AvailableMoviesState> {
  AvailableMoviesCubit({
    required this.getLatestMoviesUseCase,
    required this.addMovieToHistoryUseCase,
  }) : super(AvailableMoviesState());
  final GetLatestMoviesUseCase getLatestMoviesUseCase;
  final AddMovieToHistoryUseCase addMovieToHistoryUseCase;

  void getAvailableMovies() async {
    emit(state.copyWith(isLoading: true));
    final result = await getLatestMoviesUseCase();
    result.fold(
      (error) {
        switch (error) {
          case NoInternetError():
            emit(state.copyWith(isLoading: false, internetAvailable: false));
          case NetworkError():
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: error.message,
                internetAvailable: true,
              ),
            );

          case LocalError():
          case AuthError():
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: error.message,
                internetAvailable: true,
              ),
            );
        }
      },
      (movies) {
        emit(state.copyWith(isLoading: false, movies: movies));
      },
    );
  }

  Future<void> recordMovieInHistory(MovieUiState movie) async {
    final result = await addMovieToHistoryUseCase(
      MovieEntity(
        id: movie.id,
        rating: double.parse(movie.rating),
        imageUrl: movie.imageUrl,
      ),
    );
    result.fold(
      (err) => emit(state.copyWith(errorMessage: err.message)),
      (_) {},
    );
  }
}
