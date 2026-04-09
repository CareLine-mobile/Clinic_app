abstract class SettingsRepository {
  /// Registers the FCM token with the backend.
  /// Throws on network or server error so the cubit can handle it.
  Future<void> registerFcmToken(String token);
}
 