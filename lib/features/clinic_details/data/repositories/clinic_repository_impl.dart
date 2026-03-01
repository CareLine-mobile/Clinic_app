import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';

import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/http_method.dart';
import '../../domain/entites/time_slot_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../datasources/clinic_local_data_source.dart';
import '../model/clinic_model.dart';
import '../model/time_slot_model.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final BaseApiServices apiServices;
  final ClinicLocalDataSource localDataSource;

  ClinicRepositoryImpl({
    required this.apiServices,
    required this.localDataSource,
  });

  @override
  Future<ClinicEntity> getClinicDetails(int clinicId, {String? day}) async {
    // Build query parameters
    final queryParams = day != null ? {'day': day} : null;

    // Make API call (might throw exception)
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: '/clinicals/$clinicId',
      queryParams: queryParams,
    );

    // Handle response data
    final data = response['data'] ?? response;
    final clinicModel = ClinicModel.fromJson(data);

    // Cache the result
    await localDataSource.cacheClinic(clinicModel);

    return clinicModel;
  }

  @override
  Future<List<TimeSlotEntity>> getDoctorSlots(int doctorId, String day) async {
    // Make API call (might throw exception)
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: '/doctors/$doctorId/slots',
      queryParams: {'day': day},
    );

    // Handle response data
    final List<dynamic> slotsData = response['data'] ?? response;

    // Map to TimeSlotModel
    final slots = slotsData
        .map((json) => TimeSlotModel.fromJson(json))
        .toList();

    return slots;
  }

  @override
  Future<bool> toggleFavorite(String clinicId) async {
    // Make API call (might throw exception)
    await apiServices.request(
      method: HttpMethod.post,
      url: '/clinicals/$clinicId/favorite',
    );

    // If no exception thrown, it was successful
    return true;
  }
}

