
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../domain/setting_repo.dart';


class SettingsRepositoryImpl implements SettingsRepository {
  final BaseApiServices _api;
  final FirebaseMessaging _messaging;

  SettingsRepositoryImpl({
    required BaseApiServices apiServices,
    FirebaseMessaging? messaging,
  })  : _api = apiServices,
        _messaging = messaging ?? FirebaseMessaging.instance;

  @override
  Future<void> registerFcmToken(String token) async {
    log('messagesss: $token');
    await _api.request(
      method: HttpMethod.post,
      url: Endpoints.generateFcmToken,   // add this to your Endpoints class
      body: {'fcm_token': token},
    );
  }

  /// Requests OS permission, then returns the FCM token.
  /// Returns null if the user denied permission.
  Future<String?> requestPermissionAndGetToken() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return null;
    }

    return _messaging.getToken();
  }
}