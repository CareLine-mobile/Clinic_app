import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'location_utils.dart';

class LocationErrorHandler {

  static void handleError(
      LocationErrorType type,
      BuildContext context, {
        VoidCallback? onRetry,
      }) {
    final config = _getErrorConfig(type, onRetry);

    _showDialog(
      context: context,
      titleKey: config.titleKey,
      messageKey: config.messageKey,
      buttonKey: config.buttonKey,
      onPressed: config.action,
      showCancel: config.showCancel,
    );
  }

  static _ErrorConfig _getErrorConfig(
      LocationErrorType type,
      VoidCallback? onRetry,
      ) {
    switch (type) {

      case LocationErrorType.permissionDenied:
        return _ErrorConfig(
          titleKey: "locationPermissionNeededTitle",
          messageKey: "locationPermissionNeededMessage",
          buttonKey: "allow",
          action: () async {
            await LocationUtils.openLocationSettings();
          },
          showCancel: true,
        );

      case LocationErrorType.serviceDisabled:
        return _ErrorConfig(
          titleKey: "locationServiceDisabledTitle",
          messageKey: "locationServiceDisabledMessage",
          buttonKey: "openSettings",
          action: () async {
            await LocationUtils.openLocationSettings();
          },
          showCancel: false,
        );

      case LocationErrorType.timeout:
        return _ErrorConfig(
          titleKey: "locationTimeoutTitle",
          messageKey: "locationTimeoutMessage",
          buttonKey: "retry",
          action: () {
            onRetry?.call();
          },
          showCancel: true,
        );

      case LocationErrorType.unknown:
        return _ErrorConfig(
          titleKey: "locationErrorTitle",
          messageKey: "locationErrorMessage",
          buttonKey: "retry",
          action: () {
            onRetry?.call();
          },
          showCancel: true,
        );

      case LocationErrorType.permanentlyDenied:
        return _ErrorConfig(
          titleKey: "locationPermanentlyDeniedTitle",
          messageKey: "locationPermanentlyDeniedMessage",
          buttonKey: "openSettings",
          action: () async {
            await LocationUtils.openLocationSettings();

            onRetry?.call();
          },
          showCancel: false,
        );
    }
  }

  static Future<void> _showDialog({
    required BuildContext context,
    required String titleKey,
    required String messageKey,
    required String buttonKey,
    required VoidCallback onPressed,
    bool showCancel = true,
  }) async {
    return showAdaptiveDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titleKey.tr()),
        content: Text(messageKey.tr()),
        actions: [
          if (showCancel)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr()),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
            child: Text(buttonKey.tr()),
          ),
        ],
      ),
    );
  }
}

class _ErrorConfig {
  final String titleKey;
  final String messageKey;
  final String buttonKey;
  final VoidCallback action;
  final bool showCancel;

  _ErrorConfig({
    required this.titleKey,
    required this.messageKey,
    required this.buttonKey,
    required this.action,
    this.showCancel = true,
  });
}