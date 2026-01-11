import 'package:clinic_app/core/errors/exceptions.dart';
import 'package:clinic_app/core/errors/failures.dart';
import 'package:clinic_app/core/errors/result_handler.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/remotedatasource/remote_data_source.dart';


class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ClinicSummary>>> getFeaturedClinics() async {
    return ResultHandler.handle(() async {
      final clinics = await remoteDataSource.getFeaturedClinics();
      return clinics.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<ClinicSummary>>> getNearbyClinics() async {
    return ResultHandler.handle(() async {
      final clinics = await remoteDataSource.getNearbyClinics();
      return clinics.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<ClinicSummary>>> getAllClinics({
    int page = 1,
  }) async {
    return ResultHandler.handle(() async {
      final response = await remoteDataSource.getAllClinics(page: page);
      return response.clinics.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(int clinicId) async {
    return ResultHandler.handleVoid(() async {
      await remoteDataSource.toggleFavorite(clinicId);
    });
  }

  @override
  Future<Either<Failure, Unit>> bookAppointment(int clinicId) async {
    return ResultHandler.handleVoid(() async {
      await remoteDataSource.bookAppointment(clinicId);
    });
  }
}