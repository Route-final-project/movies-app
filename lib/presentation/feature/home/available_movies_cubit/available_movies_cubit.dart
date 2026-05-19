import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'available_movies_state.dart';

class AvailableMoviesCubit extends Cubit<AvailableMoviesState> {
  AvailableMoviesCubit() : super(AvailableMoviesInitial());
}
