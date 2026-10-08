import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Keeps detail URLs in sync with browser history while preserving the
/// existing push/pop stack behavior on mobile.
void navigateToDetail(BuildContext context, String location) {
  if (kIsWeb) {
    context.go(location);
  } else {
    context.push(location);
  }
}
