// // lib/features/clinics/data/datasources/clinic_remote_data_source.dart
// import '../clinic_details_model.dart';
// import '../../domain/usecases/book_appointment_usecase.dart';
//
// abstract class ClinicRemoteDataSource {
//   Future<ClinicDetailsModel> getClinicDetails(String clinicId);
//   Future<List<DoctorModel>> getDoctors(String clinicId);
//   Future<bool> toggleFavorite(String clinicId);
//   Future<bool> bookAppointment(BookingParams params);
// }
//
// // Implementation
// class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
//   // final Dio dio; // استخدم Dio أو http
//
//   ClinicRemoteDataSourceImpl();
//
//   @override
//   Future<ClinicDetailsModel> getClinicDetails(String clinicId) async {
//     // TODO: Replace with real API call
//     // final response = await dio.get('/api/v1/clinics/$clinicId');
//     // return ClinicDetailsModel.fromJson(response.data);
//
//     // For now, return fake data
//     await Future.delayed(const Duration(seconds: 1));
//     throw UnimplementedError('Implement API call');
//   }
//
//   @override
//   Future<List<DoctorModel>> getDoctors(String clinicId) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     throw UnimplementedError('Implement API call');
//   }
//
//   @override
//   Future<bool> toggleFavorite(String clinicId) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return true;
//   }
//
//   @override
//   Future<bool> bookAppointment(BookingParams params) async {
//     await Future.delayed(const Duration(seconds: 1));
//     return true;
//   }
// }
//
// lib/features/clinics/data/datasources/clinic_remote_data_source.dart
import '../clinic_details_model.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import 'fake/clinic_fake_data.dart';

abstract class ClinicRemoteDataSource {
  Future<ClinicDetailsModel> getClinicDetails(String clinicId);
  Future<List<DoctorModel>> getDoctors(String clinicId);
  Future<bool> toggleFavorite(String clinicId);
  Future<bool> bookAppointment(BookingParams params);
}

// Implementation with Fake Data
class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  ClinicRemoteDataSourceImpl();

  @override
  Future<ClinicDetailsModel> getClinicDetails(String clinicId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return fake data based on clinicId
    final clinic = ClinicFakeData.generateClinicDetails(id: clinicId);

    return clinic;
  }

  @override
  Future<List<DoctorModel>> getDoctors(String clinicId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate fake doctors list
    return ClinicFakeData.generateDoctorsList(count: 5);
  }

  @override
  Future<bool> toggleFavorite(String clinicId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate successful toggle
    return true;
  }

  @override
  Future<bool> bookAppointment(BookingParams params) async {
    await Future.delayed(const Duration(seconds: 1));

    // Simulate successful booking
    return true;
  }
}