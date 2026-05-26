import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../repository_interface/profile_repository.dart';

@lazySingleton
class GetWishlistUseCase {
 final ProfileRepository _repository;

 GetWishlistUseCase(this._repository);
 Future<Either<AppError, List<int>>> call() async{
   return await _repository.getWishlist();
 }
}