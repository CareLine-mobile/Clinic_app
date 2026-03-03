// ==================== endpoints.dart ====================
class Endpoints {
  // Base URL
  static const String baseUrl = 'https://clinical.khorogat.com/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String verifyOTP = '/auth/verify-otp';

  // Clinics
  static const String allClinics = '/clinicals';
  static const String latestBooking = '/clinicals/latest';
  static const String featuredClinics = '/clinicals';
  static const String nearbyClinics = '/clinicals';
  static const String clinicDetails = '/clinicals'; // + /{id}

  // Favorites
  static const String toggleFavorite = '/favorites/toggle';
  static const String getFavorites = '/favorites';

  // Bookings
  static const String bookAppointment = '/auth/bookings'; // POST Method
  static const String getListBooking = '/auth/bookings'; // GET Method
  static const String cancelBooking = '/auth/bookings/{bookingId}/cancel'; //  /{id}/cancel

  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
}