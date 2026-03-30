import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:clinic_app/core/api/model/endpoints.dart';
import 'package:clinic_app/core/api/model/http_method.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';

import '../../../home/data/model/clinics_response.dart';
import '../models/favourite_clinic_model.dart';
import 'favourite_remote_data_source.dart';

class FavouriteRemoteDataSourceImpl implements FavouriteRemoteDataSource {
  final BaseApiServices _apiServices;
  const FavouriteRemoteDataSourceImpl(this._apiServices);

  @override
  Future<List<ClinicSummary>> getFavourites() async {
    final response = await _apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.getFavorites,
    );



    final clinicsResponse = ClinicsResponse.fromJson(response);
    return clinicsResponse.clinics.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> toggleFavourite(int clinicId) async {

    final response = await _apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.toggleFavorite(clinicId),
   //   body: {'clinical_id': clinicId},
    );


    return response['is_favourite'] as bool;
  }
}