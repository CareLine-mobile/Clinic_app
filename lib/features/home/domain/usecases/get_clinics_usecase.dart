// lib/features/home/domain/usecases/get_clinics_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';

class GetClinicsUseCase {
  final HomeRepository repository;
   int count = 0;
  GetClinicsUseCase(this.repository);

  Future<Either<Failure, List<ClinicSummary>>> call({int page = 1}) async {
    count++;
    print('GetClinicsUseCase called : $count');
    try {
      final clinics = await repository.getAllClinics(page: page);
      clinics.forEach((element) {
      //  print('all clinics : ${element.toString()}');
      });
      return Right(clinics);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}