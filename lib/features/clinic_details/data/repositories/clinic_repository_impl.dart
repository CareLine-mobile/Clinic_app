import 'package:clinic_app/core/api/model/endpoints.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/appointment_request_entity.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/http_method.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entites/time_slot_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../datasources/clinic_local_data_source.dart';
import '../model/clinic_model.dart';
import '../model/time_slot_model.dart';
import '../../../../core/errors/exceptions.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final BaseApiServices apiServices;
  final ClinicLocalDataSource localDataSource;

  ClinicRepositoryImpl({
    required this.apiServices,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ClinicEntity>> getClinicDetails(int clinicId, {String? day}) async {
    try {
      final queryParams = day != null ? {'day': day} : null;
      final response = await apiServices.request(
        method: HttpMethod.get,
        url: '/clinicals/$clinicId',
        queryParams: queryParams,
      );
      final data = response['data'] ?? response;
      final clinicModel = ClinicModel.fromJson(data);
      await localDataSource.cacheClinic(clinicModel);
      return Right(clinicModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> getDoctorSlots(int doctorId, String day) async {
    try {
      final response = await apiServices.request(
        method: HttpMethod.get,
        url: '/doctors/$doctorId/slots',
        queryParams: {'day': day},
      );
      final List<dynamic> slotsData = response['data'] ?? response;
      final slots = slotsData.map((json) => TimeSlotModel.fromJson(json)).toList();
      return Right(slots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String clinicId) async {
    try {
      await apiServices.request(
        method: HttpMethod.post,
        url: '/clinicals/$clinicId/favorite',
      );
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> makeAppointment(AppointmentRequestEntity request) async {
    try {
      // Convert Entity to Model if needed, or use entity directly if it has toJson()
      await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.bookAppointment,
        body: request.toJson(),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}