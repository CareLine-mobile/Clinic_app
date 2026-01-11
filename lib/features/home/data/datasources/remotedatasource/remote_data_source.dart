// lib/features/home/data/datasources/remotedatasource/remote_data_source.dart

import 'package:clinic_app/core/api/endpoints.dart';
import 'package:clinic_app/core/errors/exceptions.dart';
import '../../../../../core/api/api_service.dart';
import '../../model/clinic_model.dart';
import '../../model/clinics_response.dart';
import '../fake/home_fake_data.dart';

abstract class HomeRemoteDataSource {
  Future<List<ClinicModel>> getFeaturedClinics();
  Future<List<ClinicModel>> getNearbyClinics();
  Future<ClinicsResponse> getAllClinics({int page = 1});
  Future<void> toggleFavorite(int clinicId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;
  final bool useFakeData;

  HomeRemoteDataSourceImpl({
    required this.apiService,
    this.useFakeData = false,
  });

  /// Get featured clinics (not exist in backend yet)
  @override
  Future<List<ClinicModel>> getFeaturedClinics() async {
    if (useFakeData) {
      await Future.delayed(const Duration(seconds: 1));
      return HomeFakeData.generateFeaturedClinics();
    }

    try {
      final response = await apiService.get(Endpoints.allClinics);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final clinicsResponse = ClinicsResponse.fromJson(response.data);
        return clinicsResponse.clinics;
      } else {
        throw ServerException('Failed to load featured clinics');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch featured clinics: ${e.toString()}');
    }
  }

  /// Get nearby clinics (not exist in backend yet)
  @override
  Future<List<ClinicModel>> getNearbyClinics() async {
    if (useFakeData) {
      await Future.delayed(const Duration(milliseconds: 800));
      return HomeFakeData.generateNearbyClinics();
    }

    try {
      final response = await apiService.get('/clinics/nearby');

      if (response.statusCode == 200) {
        final clinicsResponse = ClinicsResponse.fromJson(response.data);
        return clinicsResponse.clinics;
      } else {
        throw ServerException('Failed to load nearby clinics');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch nearby clinics: ${e.toString()}');
    }
  }

  /// Get all clinics with pagination
  @override
  Future<ClinicsResponse> getAllClinics({int page = 1}) async {
    if (useFakeData) {
      await Future.delayed(const Duration(milliseconds: 600));
      final clinics = HomeFakeData.generateClinicsList(count: 10);
      return ClinicsResponse(
        clinics: clinics,
        hasMorePage: page < 3, // Simulate 3 pages
        currentPage: page,
      );
    }

    try {
      final response = await apiService.get(
        Endpoints.allClinics,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClinicsResponse.fromJson(response.data);
      } else {
        throw ServerException('Failed to load clinics');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch clinics: ${e.toString()}');
    }
  }

  /// Toggle favorite (not exist in backend yet)
  @override
  Future<void> toggleFavorite(int clinicId) async {
    if (useFakeData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return; // Success
    }

    try {
      final response = await apiService.post('/clinics/$clinicId/favorite');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Failed to toggle favorite');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to toggle favorite: ${e.toString()}');
    }
  }
}