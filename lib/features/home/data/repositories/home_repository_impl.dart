import 'package:clinic_app/core/errors/failures.dart';
import 'package:clinic_app/core/errors/result_handler.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/remotedatasource/remote_data_source.dart';


// lib/features/home/data/repositories/home_repository_impl.dart
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<Failure, List<ClinicSummary>>> getFeaturedClinics({
    int page = 1,
  }) async {
    return ResultHandler.handle(() async {
      final clinics = await remoteDataSource.getFeaturedClinics();
      return clinics.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(int clinicId) async {
    return ResultHandler.handleVoid(() async {
      await remoteDataSource.toggleFavorite(clinicId);
    });
  }

  @override
  Future<Either<Failure, List<ClinicSummary>>> latestClinics() {
    return ResultHandler.handle(() async {
      final response = await remoteDataSource.latestClinics();
      return response.clinics.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<ClinicSummary>>> nearbyClinics({
    required double latitude,
    required double longitude,
  }) {
    return ResultHandler.handle(() async {
      final response = await remoteDataSource.nearByClinics(latitude: latitude, longitude: longitude);
      return response.clinics.map((model) => model.toEntity()).toList();
    });
  }

}