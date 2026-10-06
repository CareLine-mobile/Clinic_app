# Auth web notes

## What changed

- Added the shared `AuthResponsiveShell` for auth, verification, forgot-password, and reset-password screens. It keeps the narrow phone treatment, constrains tablet cards, and adds a two-pane wide-screen layout.
- Replaced the fixed-height auth tab viewport with content-sized animated tabs inside a scrollable shell.
- Added form autofill hints, keyboard focus order, Enter submission, and password-save context completion.
- Added OTP paste distribution, left/right navigation, managed key handling, and Enter submission on the final code field. The resend cooldown remains unchanged.
- Made Firebase initialization optional on web until its web options are supplied. FCM token listeners and sync do nothing on web, and also do nothing on native platforms where Firebase is not initialized.
- Changed verification/reset routes to accept email from a serializable argument or `?email=` query. Missing data returns to auth with a localized message. Authenticated visits to `/auth` go to the dashboard; profile and booking-details routes redirect to auth while logged out. Dashboard guest entry stays available.
- Secure-storage errors are logged without logging token values. A failed session write produces a localized notice; there is no plaintext SharedPreferences token fallback.

## Configuration

- **Google web sign-in:** replace `YOUR_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com` in `web/index.html` with the OAuth 2.0 Web client ID. The API currently receives `id_token`; this client does not send an access token as a substitute. If the web plugin returns no ID token, the user sees a localized configuration error.
- **Firebase web:** provide `FIREBASE_WEB_API_KEY`, `FIREBASE_WEB_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID`, and `FIREBASE_WEB_AUTH_DOMAIN` using `--dart-define`. `FIREBASE_STORAGE_BUCKET` is optional. Until the required values are supplied, Firebase initialization is skipped on web.
- **Web push:** FCM web push is disabled for auth flows. To enable it later, configure the Firebase web app, a VAPID key, and the Firebase messaging service worker, then implement the browser permission flow.
- **Hosting:** configure the host to serve `index.html` as the SPA fallback for application paths such as `/auth`, `/verification`, and `/resetPassword`. Keep `usePathUrlStrategy()` enabled.

## API CORS check

An OPTIONS preflight to `https://api.careline.pw/api/auth/login` with origin `https://localhost` and requested headers `authorization,content-type` returned `204`. The response allowed origin `*`, returned the requested method for each probe (`GET`, `POST`, `PUT`, `DELETE`), and allowed `authorization,content-type`. The app uses bearer authorization headers rather than credentialed cookies, so wildcard origin is compatible with these requests. No backend changes were made. Recheck the deployed web origin and all auth endpoints after any backend CORS changes.

For deployed auth requests, the backend must answer OPTIONS preflights and allow:

- Origins: the deployed CareLine web origin(s). The current API returned `Access-Control-Allow-Origin: *`.
- Methods: `GET`, `POST`, `PUT`, `DELETE`, and `OPTIONS` for preflight handling.
- Headers: `Authorization`, `Content-Type`.
- Credentialed cookies are not required by the current bearer-token client.

## Session storage and limitations

`flutter_secure_storage` is pinned to 11.0.0. Its web implementation uses WebCrypto with browser storage and requires HTTPS or localhost. The package describes web storage as experimental and tied to the same browser/domain. If access fails, the app logs the storage failure and does not silently fall back to plaintext preferences; a session that cannot be written will not survive refresh. See the [package web notes](https://pub.dev/packages/flutter_secure_storage) and [WebOptions API](https://pub.dev/documentation/flutter_secure_storage/latest/flutter_secure_storage/WebOptions-class.html).

- No live login/signup/OTP/forgot-password flow was submitted: that would send credentials or personal contact details to the production API, and the required test account/Google OAuth configuration was not provided.
- Google sign-in remains unverified until a real web client ID is configured.
- FCM web push is intentionally unavailable until VAPID and service-worker setup is provided.
- Flutter's WebAssembly dry-run reports `google_sign_in_web` uses `dart:html`/`package:js`; the standard JavaScript web build succeeds, but a WASM build is not supported by that dependency version.
- The API preflight was checked from localhost, not from the final hosted origin.

## Verification run

- `flutter build web`: passed. Flutter emitted its WebAssembly dry-run warnings for `google_sign_in_web`; the JavaScript web build completed.
- `flutter run -d chrome`: passed after the first debug-service connection attempt failed; the live Chrome instance connected on retry.
- Browser checks: direct auth route; missing-email verification redirect and localized message; verification and reset routes with query email after reload; OTP paste; widths 320, 360, 390, 600, 768, 1024, 1280, and 1920. No browser errors or document horizontal overflow were observed.
- `flutter analyze`: no analyzer errors; it exits nonzero with 585 warnings/info diagnostics across the repository (600 before these changes). The touched auth files have no compile errors.
- `flutter run -d emulator-5554`: blocked during Gradle `assembleDebug` because the wrapper download failed Java certificate validation (`PKIX path building failed`).
- Full sign-in, signup, Google sign-in, OTP verification, reset submission, password-manager prompt, language/theme switching, and API network-error scenarios were not submitted or manually exercised. They need a configured Google client ID and a test account to avoid sending personal data to production.
