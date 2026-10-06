import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../domain/setting_repo.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final BaseApiServices _api;
  final FirebaseMessaging? _messaging;

  SettingsRepositoryImpl({
    required BaseApiServices apiServices,
    FirebaseMessaging? messaging,
  }) : _api = apiServices,
       _messaging = kIsWeb || Firebase.apps.isEmpty
           ? null
           : messaging ?? FirebaseMessaging.instance;

  @override
  Future<void> registerFcmToken(String token) async {
    log('messagesss fcm_token: $token');
    await _api.request(
      method: HttpMethod.post,
      url: Endpoints.generateFcmToken,
      body: {'fcm_token': token},
    );
  }

  /// Requests OS permission, then returns the FCM token.
  /// Returns null if the user denied permission.
  Future<String?> requestPermissionAndGetToken() async {
    final messaging = _messaging;
    if (messaging == null) return null;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return null;
    }

    return messaging.getToken();
  }
}
