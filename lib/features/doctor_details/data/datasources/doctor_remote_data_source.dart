import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../models/doctor_profile_model.dart';

abstract class DoctorRemoteDataSource {
  Future<DoctorProfileModel> getDoctorDetails(int doctorId);
  Future<double> rateDoctor(int doctorId, double rating);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final BaseApiServices apiServices;

  DoctorRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<DoctorProfileModel> getDoctorDetails(int doctorId) async {
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: '${Endpoints.doctorDetails}/$doctorId',
    );
    final data = response['data'] ?? response;
    return DoctorProfileModel.fromJson(data);
  }

  @override
  Future<double> rateDoctor(int doctorId, double rating) async {
    final response = await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.rateDoctor(doctorId),
      body: {'rating': rating},
    );
    // Response: { "rating": 4.5 }
    return (response['rating'] ?? rating).toDouble();
  }
}
