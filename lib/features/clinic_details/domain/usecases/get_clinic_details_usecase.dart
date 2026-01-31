// lib/features/clinics/domain/usecases/get_clinic_details_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../entites/clinic_entities.dart';
import '../repositories/clinic_repository.dart';

class GetClinicDetailsUseCase {
  final ClinicRepository repository;

  GetClinicDetailsUseCase(this.repository);

  Future<Either<Failure, ClinicEntity>> call(int clinicId, {String? day}) async {
    try {
      final clinic = await repository.getClinicDetails(clinicId,);
      return Right(clinic);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}
