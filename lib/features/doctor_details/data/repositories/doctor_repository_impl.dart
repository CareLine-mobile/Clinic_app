import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../datasources/doctor_remote_data_source.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DoctorProfileEntity>> getDoctorDetails(
      int doctorId) async {
    try {
      final doctor = await remoteDataSource.getDoctorDetails(doctorId);
      return Right(doctor);
    } catch (e, st) {
      return Left(ErrorHandler.handleException(e, st));
    }
  }

  @override
  Future<Either<Failure, double>> rateDoctor(
      int doctorId, double rating) async {
    try {
      final newRating = await remoteDataSource.rateDoctor(doctorId, rating);
      return Right(newRating);
    } catch (e, st) {
      return Left(ErrorHandler.handleException(e, st));
    }
  }
}
