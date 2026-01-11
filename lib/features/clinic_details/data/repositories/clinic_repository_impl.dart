// lib/features/clinics/data/repositories/clinic_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entites/clinic_entities.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import '../datasources/clinic_remote_data_source.dart';
import '../datasources/clinic_local_data_source.dart';

// class ClinicRepositoryImpl implements ClinicRepository {
//   final ClinicRemoteDataSource remoteDataSource;
//   final ClinicLocalDataSource localDataSource;
//
//   ClinicRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//   });
//
//   @override
//   Future<Either<Failure, ClinicDetails>> getClinicDetails(String clinicId) async {
//     try {
//       final clinicModel = await remoteDataSource.getClinicDetails(clinicId);
//       await localDataSource.cacheClinic(clinicModel);
//       return Right(clinicModel);
//     } on ServerException {
//       return Left(ServerFailure('Failed to fetch clinic details'));
//     } on CacheException {
//       return Left(CacheFailure('Cache error'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, List<Doctor>>> getDoctors(String clinicId) async {
//     try {
//       final doctors = await remoteDataSource.getDoctors(clinicId);
//       return Right(doctors);
//     } on ServerException {
//       return Left(ServerFailure('Failed to fetch doctors'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, bool>> toggleFavorite(String clinicId) async {
//     try {
//       final result = await remoteDataSource.toggleFavorite(clinicId);
//       return Right(result);
//     } on ServerException {
//       return Left(ServerFailure('Failed to toggle favorite'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, bool>> bookAppointment(BookingParams params) async {
//     try {
//       final result = await remoteDataSource.bookAppointment(params);
//       return Right(result);
//     } on ServerException {
//       return Left(ServerFailure('Failed to book appointment'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }

// lib/features/clinics/data/repositories/clinic_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entites/clinic_entities.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import '../datasources/clinic_local_data_source.dart';
import '../datasources/clinic_remote_data_source.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final ClinicRemoteDataSource remoteDataSource;
  final ClinicLocalDataSource localDataSource;

  ClinicRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ClinicDetails>> getClinicDetails(int clinicId) async {
    try {
      // Try to get from remote
      final remoteClinic = await remoteDataSource.getClinicDetails(clinicId);

      // Cache the result
      await localDataSource.cacheClinic(remoteClinic);

      // Convert model to entity
      return Right(remoteClinic);
    } catch (e) {
      // If remote fails, try cache
      try {
        final cachedClinic = await localDataSource.getCachedClinic(clinicId);
        if (cachedClinic != null) {
          return Right(cachedClinic);
        }
        return const Left(CacheFailure( 'لا توجد بيانات محفوظة'));
      } catch (e) {
        return Left(ServerFailure('فشل في تحميل البيانات: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getDoctors(int clinicId) async {
    try {
      final doctors = await remoteDataSource.getDoctors(clinicId);
      return Right(doctors.map((model) => model).toList());
    } catch (e) {
      return Left(ServerFailure( 'فشل في تحميل الأطباء: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(int clinicId) async {
    try {
      final result = await remoteDataSource.toggleFavorite(clinicId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure( 'فشل في تغيير الحالة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> bookAppointment(BookingParams params) async {
    try {
      final result = await remoteDataSource.bookAppointment(params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('فشل في الحجز: ${e.toString()}'));
    }
  }
}