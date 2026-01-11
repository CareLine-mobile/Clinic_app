// lib/features/clinic_details/data/datasources/clinic_remote_data_source.dart

import '../../../../core/api/api_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/clinic_details_model.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import 'fake/clinic_fake_data.dart';

abstract class ClinicRemoteDataSource {
  Future<ClinicDetailsModel> getClinicDetails(int clinicId);
  Future<List<DoctorModel>> getDoctors(int clinicId);
  Future<bool> toggleFavorite(int clinicId);
  Future<bool> bookAppointment(BookingParams params);
}

class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  final ApiService apiService;
  final bool useFakeData;

  ClinicRemoteDataSourceImpl({
    required this.apiService,
    this.useFakeData = true, // Set to true to use fake data
  });

  @override
  Future<ClinicDetailsModel> getClinicDetails(int clinicId) async {
    if (useFakeData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate fake clinic details with the provided clinicId
      return ClinicFakeData.generateClinicDetails(id: clinicId);
    }

    try {
      final response = await apiService.get('/clinics/$clinicId');

      if (response.statusCode == 200) {
        return ClinicDetailsModel.fromJson(response.data);
      } else {
        throw ServerException(
          'Failed to load clinic details',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to fetch clinic details: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<DoctorModel>> getDoctors(int clinicId) async {
    if (useFakeData) {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Generate fake doctors list
      return ClinicFakeData.generateDoctorsList(count: 3 + (clinicId % 5));
    }

    try {
      final response = await apiService.get('/clinics/$clinicId/doctors');

      if (response.statusCode == 200) {
        final List<dynamic> doctorsJson = response.data['data'] ?? response.data;
        return doctorsJson
            .map((json) => DoctorModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          'Failed to load doctors',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to fetch doctors: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> toggleFavorite(int clinicId) async {
    if (useFakeData) {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate success
      return true;
    }

    try {
      final response = await apiService.post(
        '/clinics/$clinicId/favorite',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
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
  Future<bool> bookAppointment(BookingParams params) async {
    if (useFakeData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate random success/failure (90% success rate)
      final random = DateTime.now().millisecondsSinceEpoch % 10;
      if (random < 9) {
        return true;
      } else {
        throw ServerException(
          'فشل في حجز الموعد. يرجى المحاولة مرة أخرى.',
        );
      }
    }

    try {
      final response = await apiService.post(
        '/clinics/${params.clinicId}/appointments',
        data: {
          'doctor_id': params.doctorId,
          'date': params.date.toIso8601String(),
          'time_slot': params.timeSlot,
          'notes': '', // Add notes if needed
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
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

// Fake Data Source Implementation (Alternative approach)
class ClinicFakeDataSource implements ClinicRemoteDataSource {
  @override
  Future<ClinicDetailsModel> getClinicDetails(int clinicId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate fake clinic details
    return ClinicFakeData.generateClinicDetails(id: clinicId);
  }

  @override
  Future<List<DoctorModel>> getDoctors(int clinicId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate fake doctors list
    return ClinicFakeData.generateDoctorsList(count: 3 + (clinicId % 5));
  }

  @override
  Future<bool> toggleFavorite(int clinicId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Always return success
    return true;
  }

  @override
  Future<bool> bookAppointment(BookingParams params) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate random success/failure (90% success rate)
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    if (random < 9) {
      return true;
    } else {
      throw ServerException(
        'فشل في حجز الموعد. يرجى المحاولة مرة أخرى.',
      );
    }
  }
}