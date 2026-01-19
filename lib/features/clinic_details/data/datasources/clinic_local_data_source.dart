
// ============================================
// lib/features/clinics/data/datasources/clinic_local_data_source.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/clinic_model.dart';


abstract class ClinicLocalDataSource {
  Future<ClinicModel?> getCachedClinic(int clinicId);
  Future<void> cacheClinic(ClinicModel clinic);
}

class ClinicLocalDataSourceImpl implements ClinicLocalDataSource {
  final SharedPreferences sharedPreferences;

  ClinicLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ClinicModel?> getCachedClinic(int clinicId) async {
    final jsonString = sharedPreferences.getString('CACHED_CLINIC_$clinicId');
    if (jsonString != null) {
      return ClinicModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheClinic(ClinicModel clinic) async {
    await sharedPreferences.setString(
      'CACHED_CLINIC_${clinic.id}',
      json.encode(clinic.toJson()),
    );
  }
}
