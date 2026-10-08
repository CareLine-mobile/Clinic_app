abstract final class Routes {
  static const configuration = '/configuration';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const dashBoard = '/dashBoard'; // Legacy URL; router redirects it.
  static const search = '/search';
  static const favourites = '/favourites';
  static const bookings = '/bookings';
  static const settings = '/settings';
  static const auth = '/auth';
  static const verification = '/verification';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const clinicDetails = '/clinic';
  static const booking = '/clinic';
  static const bookingDetails = '/bookings';
  static const doctorProfile = '/doctor';
  static const profile = '/profile';
  static const privacyPolicy = '/privacy-policy';
  static const mapLocations = '/map';

  static String clinic(int id) => '/clinic/$id';
  static String authFor(String from) =>
      Uri(path: auth, queryParameters: {'from': from}).toString();
  static String clinicBooking(int id) => '/clinic/$id/booking';
  static String doctor(int id) => '/doctor/$id';
  static String bookingDetail(int id) => '/bookings/$id';
  static String verificationForEmail(String email, {String? from}) => Uri(
    path: verification,
    queryParameters: {
      'email': email,
      if (from != null && from.isNotEmpty) 'from': from,
    },
  ).toString();
  static String forgotPasswordForEmail(String email, {String? from}) => Uri(
    path: forgotPassword,
    queryParameters: {
      'email': email,
      if (from != null && from.isNotEmpty) 'from': from,
    },
  ).toString();
  static String resetPasswordForEmail(String email, {String? from}) => Uri(
    path: resetPassword,
    queryParameters: {
      'email': email,
      if (from != null && from.isNotEmpty) 'from': from,
    },
  ).toString();
}
