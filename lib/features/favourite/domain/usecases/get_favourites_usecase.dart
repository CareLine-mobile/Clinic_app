import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/clinic_summary.dart';
import '../repositories/favourite_repository.dart';

class GetFavouritesUseCase {
  final FavouriteRepository _repository;
  const GetFavouritesUseCase(this._repository);

  Future<Either<Failure, List<ClinicSummary>>> call() =>
      _repository.getFavourites();
}