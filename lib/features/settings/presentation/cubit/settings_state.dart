part of 'settings_cubit.dart';



class SettingsState extends Equatable {
  final Locale locale;
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool notificationsLoading;   // true while FCM + API in progress
  final String? notificationsError;  // non-null when the last toggle failed

  const SettingsState({
    required this.locale,
    required this.themeMode,
    required this.notificationsEnabled,
    this.notificationsLoading = false,
    this.notificationsError,
  });

  bool get isDark  => themeMode == ThemeMode.dark;
  bool get isArabic => locale.languageCode == 'ar';

  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? notificationsLoading,
    String? notificationsError,
    bool clearError = false,   // pass clearError: true to null out the error
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationsLoading: notificationsLoading ?? this.notificationsLoading,
      notificationsError: clearError ? null : (notificationsError ?? this.notificationsError),
    );
  }

  @override
  List<Object?> get props => [
    locale,
    themeMode,
    notificationsEnabled,
    notificationsLoading,
    notificationsError,
  ];
}