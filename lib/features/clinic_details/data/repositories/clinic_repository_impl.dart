import 'package:dartz/dartz.dart';
import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/entites/appointment_request_entity.dart';
import '../../domain/entites/clinic_entities.dart';
import '../../domain/entites/time_slot_entity.dart';
import '../../domain/entites/coupon_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../datasources/clinic_local_data_source.dart';
import '../model/clinic_model.dart';
import '../model/coupon_model.dart';
import '../model/time_slot_model.dart';

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
    } catch (e, st) {
      return Left(ErrorHandler.handleException(e, st));
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
    } catch (e, st) {
      return Left(ErrorHandler.handleException(e, st));
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
    } catch (e, st) {
      return Left(ErrorHandler.handleException(e, st));
    }
  }

  @override
  Future<Either<Failure, void>> makeAppointment(AppointmentRequestEntity request) async {
    try {
      await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.bookAppointment,
        body: request.toJson(),
      );
      return const Right(null);
    } catch (e, st) {
      return Left(ErrorHandler.handleException(e, st));
    }
  }

  @override
  Future<Either<Failure, CouponEntity>> applyCoupon(String coupon, String clinicId) async {
    try {
      final response = await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.applyCoupon,
        body: {
          'coupon': coupon,
          'clinical_id': int.tryParse(clinicId) ?? 0,
        },
      );
      final data = response['data'] ?? response;
      return Right(CouponModel.fromJson(data));
    } catch (e, st) {
      return Left(ErrorHandler.handleException(e, st));
    }
  }
}