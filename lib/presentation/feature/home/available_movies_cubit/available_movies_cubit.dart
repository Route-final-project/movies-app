import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/domain/app_error.dart';

import '../../../../domain/entity/movie_entity.dart';
import '../../../../domain/usecase/get_latest_movies_use_case.dart';

part 'available_movies_state.dart';

@injectable
class AvailableMoviesCubit extends Cubit<AvailableMoviesState> {
  AvailableMoviesCubit({required this.getLatestMoviesUseCase})
    : super(AvailableMoviesState());
  final GetLatestMoviesUseCase getLatestMoviesUseCase;

  void getAvailableMovies() async {
    emit(state.copyWith(isLoading: true));
    final result = await getLatestMoviesUseCase();
    result.fold((error){
      switch (error) {
        case NoInternetError():
          emit(
            state.copyWith(
              isLoading: false,
              internetAvailable: false,
            ),
          );
        case NetworkError():
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: error.message,
              internetAvailable: true,
            ),
          );

        case LocalError():
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: error.message,
              internetAvailable: true,
            ),
          );
      }
    }, (movies){
      emit(state.copyWith(isLoading: false, movies: movies));
    }
    );
  }
}
