import 'package:shared_preferences/shared_preferences.dart';

abstract class ReviewLocalDataSource {
  Future<bool> isReviewed(int clinicId);
  Future<void> markAsReviewed(int clinicId);
}

class ReviewLocalDataSourceImpl implements ReviewLocalDataSource {
  static const String _prefix = 'reviewed_clinic_';

  @override
  Future<bool> isReviewed(int clinicId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$clinicId') ?? false;
  }

  @override
  Future<void> markAsReviewed(int clinicId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$clinicId', true);
  }
}