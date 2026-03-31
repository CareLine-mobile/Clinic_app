import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/repositories/home_repository.dart';
import '../model/clinics_response.dart';



class HomeRepositoryImpl implements HomeRepository {
  final BaseApiServices apiServices;

  HomeRepositoryImpl({required this.apiServices});

  @override
  Future<List<ClinicSummary>> getAllClinics({int page = 1}) async {
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.allClinics,
      queryParams: {'page': page},
    );

    final clinicsResponse = ClinicsResponse.fromJson(response);
    print('zyad : ${clinicsResponse.clinics}');
    return clinicsResponse.clinics.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ClinicSummary>> getFeaturedClinics({int page = 1}) async {
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.allClinics,
      queryParams: {'page': page},
    );

    final clinicsResponse = ClinicsResponse.fromJson(response);
    return clinicsResponse.clinics.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ClinicSummary>> latestClinics() async {
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.latestBooking,
    );

    final clinicsResponse = ClinicsResponse.fromJson(response);
    return clinicsResponse.clinics.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ClinicSummary>> nearbyClinics({
    required double latitude,
    required double longitude,
  }) async {
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.nearbyClinics,
      queryParams: {
        'per_page': 15,
        'lat': latitude,
        'lng': longitude,
      },
    );

    final clinicsResponse = ClinicsResponse.fromJson(response);
    return clinicsResponse.clinics.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> toggleFavorite(int clinicId) async {
    await apiServices.request(
      method: HttpMethod.post,
      url: '/clinics/$clinicId/favorite',
    );
  }
}