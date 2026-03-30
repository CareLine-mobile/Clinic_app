import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/favourite_repository.dart';

class ToggleFavouriteUseCase {
  final FavouriteRepository _repository;
  const ToggleFavouriteUseCase(this._repository);

  Future<Either<Failure, bool>> call(int clinicId) =>
      _repository.toggleFavourite(clinicId);
}