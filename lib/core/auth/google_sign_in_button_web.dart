import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart';

Widget buildGoogleSignInWebButton() => renderButton(
  configuration: GSIButtonConfiguration(
    theme: GSIButtonTheme.outline,
    size: GSIButtonSize.large,
    text: GSIButtonText.continueWith,
    shape: GSIButtonShape.rectangular,
    minimumWidth: 220,
  ),
);
