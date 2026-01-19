// lib/features/clinic_details/data/datasources/clinic_remote_data_source.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/api/api_error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../model/clinic_model.dart';
import '../model/time_slot_model.dart';
import 'fake/clinic_fake_data.dart';

abstract class ClinicRemoteDataSource {
  /// Get clinic details by ID
  /// [day] parameter filters doctor available slots by specific day (e.g., 'sunday', 'monday')
  Future<ClinicModel> getClinicDetails(int clinicId, {String? day});
  Future<List<TimeSlotModel>> getDoctorSlots({required int doctorId,required String day});
  Future< bool> toggleFavorite(String clinicId);
}

class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  final ApiService apiService;
  final bool useFakeData;

  ClinicRemoteDataSourceImpl({
    required this.apiService,
    this.useFakeData = false,
  });

  @override
  Future<ClinicModel> getClinicDetails(int clinicId, {String? day}) async {
    if (useFakeData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate fake clinic details with the provided clinicId and day filter
      return ClinicFakeData.generateClinicDetails(
        id: clinicId,
      );
    }

    try {
      // Build query parameters
      final queryParams = day != null ? {'day': day} : null;

      final response = await apiService.get(
        '/clinicals/$clinicId',
        queryParameters: queryParams,
      );

      // Handle both response formats:
      // 1. { "data": { ... } }
      // 2. { ... } direct data
      final data = response.data['data'] ?? response.data;
      return ClinicModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.clinic.details'.tr());
    }
  }

  @override
  Future<List<TimeSlotModel>> getDoctorSlots({required int doctorId, required String day}) async {
    if (useFakeData) {
      await Future.delayed(const Duration(milliseconds: 800));
      // Return fake data if needed
      return [];
    }

    try {
      // API Call matching the Postman image
      final response = await apiService.get(
        '/doctors/$doctorId/slots', // Path variable :doctor
        queryParameters: {
          'day': day, // Query param ?day=...
        },
      );

      // Accessing data inside { "data": [...] }
      final List<TimeSlotModel> slotsJson = response.data['data'] ?? response.data;

      // Ideally map this to a model, e.g., DoctorSlotModel.fromJson(json)
      return slotsJson;

    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.doctor.slots'.tr());
    }
  }

  @override
  Future<bool> toggleFavorite(String clinicId) async {

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return true;


  }

}
