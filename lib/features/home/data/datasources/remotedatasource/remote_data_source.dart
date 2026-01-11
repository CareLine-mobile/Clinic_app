// lib/features/home/data/datasources/remotedatasource/remote_data_source.dart

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
  Future<void> bookAppointment(int clinicId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;
  final bool useFakeData;

  HomeRemoteDataSourceImpl({
    required this.apiService,
    this.useFakeData = true, // ✅ Default to fake data while backend fixes CORS
  });

  @override
  Future<List<ClinicModel>> getFeaturedClinics() async {
    if (useFakeData) {
      // Use fake data
      await Future.delayed(const Duration(seconds: 1));
      return HomeFakeData.generateFeaturedClinics();
    }

    try {
      // Real API call
      final response = await apiService.get('/clinicals/featured');

      if (response.statusCode == 200) {
        final clinicsResponse = ClinicsResponse.fromJson(response.data);
        return clinicsResponse.clinics;
      } else {
        throw ServerException(
         'Failed to load featured clinics',

        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
       'Failed to fetch featured clinics: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ClinicModel>> getNearbyClinics() async {
    if (useFakeData) {
      // Use fake data
      await Future.delayed(const Duration(milliseconds: 800));
      return HomeFakeData.generateNearbyClinics();
    }

    try {
      // Real API call
      final response = await apiService.get('/clinicals/nearby');

      if (response.statusCode == 200) {
        final clinicsResponse = ClinicsResponse.fromJson(response.data);
        return clinicsResponse.clinics;
      } else {
        throw ServerException(
    'Failed to load nearby clinics',

        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
    'Failed to fetch nearby clinics: ${e.toString()}',
      );
    }
  }

  @override
  Future<ClinicsResponse> getAllClinics({int page = 1}) async {
    if (useFakeData) {
      // Use fake data
      await Future.delayed(const Duration(milliseconds: 600));
      final clinics = HomeFakeData.generateClinicsList(count: 20);
      return ClinicsResponse(
        clinics: clinics,
        hasMorePage: false,
        currentPage: 1,
      );
    }

    try {
      // Real API call
      final response = await apiService.get(
        '/clinicals',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        return ClinicsResponse.fromJson(response.data);
      } else {
        throw ServerException(
         'Failed to load clinics',

        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
         'Failed to fetch clinics: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> toggleFavorite(int clinicId) async {
    if (useFakeData) {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      return; // Success
    }

    try {
      // Real API call
      final response = await apiService.post('/clinicals/$clinicId/favorite');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
         'Failed to toggle favorite',

        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
       'Failed to toggle favorite: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> bookAppointment(int clinicId) async {
    if (useFakeData) {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return; // Success
    }

    try {
      // Real API call
      final response = await apiService.post(
        '/clinicals/$clinicId/appointments',
        data: {
          'clinic_id': clinicId,
          'date': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
         'Failed to book appointment',

        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to book appointment: ${e.toString()}',
      );
    }
  }
}