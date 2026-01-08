
// ============================================
// lib/features/clinics/data/datasources/clinic_local_data_source.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../clinic_details_model.dart';


abstract class ClinicLocalDataSource {
  Future<ClinicDetailsModel?> getCachedClinic(String clinicId);
  Future<void> cacheClinic(ClinicDetailsModel clinic);
}

class ClinicLocalDataSourceImpl implements ClinicLocalDataSource {
  final SharedPreferences sharedPreferences;

  ClinicLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ClinicDetailsModel?> getCachedClinic(String clinicId) async {
    final jsonString = sharedPreferences.getString('CACHED_CLINIC_$clinicId');
    if (jsonString != null) {
      return ClinicDetailsModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheClinic(ClinicDetailsModel clinic) async {
    await sharedPreferences.setString(
      'CACHED_CLINIC_${clinic.id}',
      json.encode(clinic.toJson()),
    );
  }
}
