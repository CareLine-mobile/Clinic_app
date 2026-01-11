// ==================== endpoints.dart ====================
class Endpoints {
  // Base URL
  static const String baseUrl = 'http://clinicalapp22-001-site1.ltempurl.com/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // Clinics
  static const String allClinics = 'http://clinicalapp22-001-site1.ltempurl.com/api/clinicals';
  static const String featuredClinics = 'http://clinicalapp22-001-site1.ltempurl.com/api/clinicals';
  static const String nearbyClinics = 'http://clinicalapp22-001-site1.ltempurl.com/api/clinicals';
  static const String clinicDetails = 'http://clinicalapp22-001-site1.ltempurl.com/api/clinicals'; // + /{id}

  // Favorites
  static const String toggleFavorite = '/favorites/toggle';
  static const String getFavorites = '/favorites';

  // Bookings
  static const String bookAppointment = '/bookings';
  static const String getBookings = '/bookings';
  static const String cancelBooking = '/bookings'; // + /{id}/cancel

  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
}