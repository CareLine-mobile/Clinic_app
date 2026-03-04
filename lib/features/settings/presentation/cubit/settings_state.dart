part of 'settings_cubit.dart';

@immutable
// lib/features/settings/presentation/cubit/settings_state.dart
class SettingsState extends Equatable {
  final Locale locale;
  final ThemeMode themeMode;
  final bool notificationsEnabled;

  const SettingsState({
    required this.locale,
    required this.themeMode,
    required this.notificationsEnabled,
  });

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isArabic => locale.languageCode == 'ar';

  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [locale, themeMode, notificationsEnabled];
}