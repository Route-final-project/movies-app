import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../repository_interface/profile_repository.dart';

@lazySingleton
class RemoveMovieFromWishlistUseCase {
 final ProfileRepository _repository;

 RemoveMovieFromWishlistUseCase(this._repository);
 Future<Either<AppError, void>> call(int id) async{
   return await _repository.removeMovieFromWishlist(id);
 }
}