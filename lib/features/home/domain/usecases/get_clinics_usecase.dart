// lib/features/home/domain/usecases/get_clinics_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';

class GetClinicsUseCase {
  final HomeRepository repository;

  GetClinicsUseCase(this.repository);

  Future<Either<Failure, List<ClinicSummary>>> call({int page = 1}) async {
    try {
      final clinics = await repository.getAllClinics(page: page);
      return Right(clinics);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}