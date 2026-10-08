import 'package:google_sign_in/google_sign_in.dart';

/// Shares one initialized Google Sign-In client across the app.
class GoogleSignInService {
  GoogleSignInService._();

  static final GoogleSignIn instance = GoogleSignIn.instance;
  static final Future<void> _initialization = instance.initialize();

  static Future<void> ensureInitialized() => _initialization;
}
