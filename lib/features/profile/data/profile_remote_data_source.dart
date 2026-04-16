import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:clinic_app/core/api/model/endpoints.dart';
import 'package:clinic_app/core/api/model/http_method.dart';
import 'package:clinic_app/features/profile/data/profile_model.dart';


/// Direct implementation — no abstract class (as requested).
class ProfileRemoteDataSource {
  final BaseApiServices _api;

  ProfileRemoteDataSource(this._api);

  Future<ProfileResponseModel> getProfile() async {
    final response = await _api.request(
      method: HttpMethod.get,
      url: Endpoints.profile,
    );
    final result = ProfileResponseModel.fromJson(response as Map<String, dynamic>);
    return result;
  }

  Future<ProfileModel> updateProfile(ProfileModel profile,bool isProfileDataExists) async {

    final response = await _api.request(
      method: isProfileDataExists ? HttpMethod.put: HttpMethod.post,
      url: Endpoints.profile,
      body: profile.toJson(),
    );
    return ProfileModel.fromJson(response as Map<String, dynamic>);
  }
}