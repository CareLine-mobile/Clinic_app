// lib/features/home/domain/usecases/get_latest_clinics_usecase.dart
// Use this when backend adds separate featured endpoint
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';


class GetLatestClinicsUseCase {
  final HomeRepository repository;

  GetLatestClinicsUseCase(this.repository);

  Future<Either<Failure, List<ClinicSummary>>> call() async {
    try {
      final clinics = await repository.latestClinics();
      // clinics.forEach((element) {
      //     print('GetLatestClinicsUseCase : ${element.toString()}');
      // });
      return Right(clinics);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}


