// lib/features/search/data/datasources/search_remote_data_source.dart

import '../../../../../core/api/base_api_services.dart';
import '../../../../../core/api/model/endpoints.dart';
import '../../../../../core/api/model/http_method.dart';
import '../../../home/data/model/clinics_response.dart';
import '../../../home/domain/entities/clinic_summary.dart';

abstract class SearchRemoteDataSource {
  Future<List<ClinicSummary>> searchClinics({required String query});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final BaseApiServices apiServices;

  SearchRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<List<ClinicSummary>> searchClinics({required String query}) async {
    // Same endpoint as home — name param in query as per your postman screenshot
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.allClinics,
      queryParams: {
        'per_page': 15,
        'name': query,
      },
    );

    final clinicsResponse = ClinicsResponse.fromJson(response);
    return clinicsResponse.clinics.map((m) => m.toEntity()).toList();
  }
}