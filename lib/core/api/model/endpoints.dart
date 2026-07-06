// ==================== endpoints.dart ====================
class Endpoints {
  // Base URL
  static const String baseUrl = 'https://api.careline.pw/api';
  static const String policyLink = 'https://api.careline.pw/policy';

  // Auth
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google-login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String verifyOTP = '/auth/verify-otp';
  static const String resendOTP = '/auth/resend-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String sendForgetPassword = '/auth/forgot-password';
  static const String deleteAccount = '/auth/delete-account';


  // Clinics
  static const String allClinics = '/clinicals';
  static const String latestBooking = '/clinicals/latest';
  static const String featuredClinics = '/clinicals';
  static const String nearbyClinics = '/clinicals';
  static const String clinicDetails = '/clinicals'; // + /{id}

  // Favorites
  static String toggleFavorite(int id) => '/clinicals/$id/favourite';
  static const String getFavorites = '/clinicals/favourites';
  // Bookings
  static const String bookAppointment = '/auth/bookings'; // POST Method
  static const String getListBooking = '/auth/bookings'; // GET Method
  static String cancelBooking(int id) => '/auth/bookings/$id/cancel';
  static String createReview(int clinicId) => '/clinicals/$clinicId/reviews';

  // Profile

  static const String profile = '/auth/patient/profile';
  //setting
  static const String generateFcmToken = '/auth/generate-fcm-token';

}