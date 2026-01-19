import 'package:clinic_app/core/api/endpoints.dart';
import 'package:clinic_app/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import '../../../../../core/api/api_error_handler.dart';
import '../../../../../core/api/api_service.dart';
import '../../model/clinic_model.dart';
import '../../model/clinics_response.dart';
import 'package:easy_localization/easy_localization.dart';


abstract class HomeRemoteDataSource {
  Future<List<ClinicsHomeModel>> getFeaturedClinics();
  Future<List<ClinicsHomeModel>> getNearbyClinics();
  Future<ClinicsResponse> getAllClinics({int page = 1});
  Future<ClinicsResponse> latestClinics();
  Future<void> toggleFavorite(int clinicId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ClinicsHomeModel>> getFeaturedClinics() async {
    try {
      final response = await apiService.get(Endpoints.allClinics);
      final clinicsResponse = ClinicsResponse.fromJson(response.data);
      return clinicsResponse.clinics;
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.clinics.featured'.tr());
    }
  }

  @override
  Future<List<ClinicsHomeModel>> getNearbyClinics() async {
    try {
      final response = await apiService.get(Endpoints.nearbyClinics);
      final clinicsResponse = ClinicsResponse.fromJson(response.data);
      return clinicsResponse.clinics;
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.clinics.nearby'.tr());
    }
  }

  @override
  Future<ClinicsResponse> getAllClinics({int page = 1}) async {
    try {
      final response = await apiService.get(
        Endpoints.allClinics,
        queryParameters: {'page': page},
      );
      return ClinicsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.clinics.all'.tr());
    }
  }

  @override
  Future<void> toggleFavorite(int clinicId) async {
    try {
      await apiService.post('/clinics/$clinicId/favorite');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.clinics.toggleFavorite'.tr());
    }
  }

  @override
  Future<ClinicsResponse> latestClinics() async {
    try {
      final response = await apiService.get(
        Endpoints.latestBooking,
      );
      return ClinicsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.clinics.all'.tr());
    }
  }
}

