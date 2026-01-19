// lib/features/clinics/data/repositories/clinic_repository_impl.dart
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result_handler.dart';
import '../../domain/entites/time_slot_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../datasources/clinic_remote_data_source.dart';
import '../datasources/clinic_local_data_source.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final ClinicRemoteDataSource remoteDataSource;
  final ClinicLocalDataSource localDataSource;

  ClinicRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ClinicEntity>> getClinicDetails(int clinicId) async {
    return ResultHandler.handle(() async {
      try {
        // Try to get from remote
        final remoteClinic = await remoteDataSource.getClinicDetails(clinicId);

        // Cache the result
        await localDataSource.cacheClinic(remoteClinic);

        return remoteClinic;
      } catch (e) {
        // If remote fails, try cache
        final cachedClinic = await localDataSource.getCachedClinic(clinicId);

        if (cachedClinic != null) {
          return cachedClinic;
        }

        // If cache also fails, rethrow the original error
        rethrow;
      }
    });
  }

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> getDoctorSlots(
      int doctorId,
      String day,
      ) async {
    return ResultHandler.handle(() async {
      final slots = await remoteDataSource.getDoctorSlots(
        doctorId: doctorId,
        day: day,
      );

      return slots;
    });
  }

@override
Future<Either<Failure, bool>> toggleFavorite(String clinicId) async {
  try {
    final result = await remoteDataSource.toggleFavorite(clinicId);
    return Right(result);
  } catch (e) {
    return Left(ServerFailure( 'فشل في تغيير الحالة: ${e.toString()}'));
  }
}

}

