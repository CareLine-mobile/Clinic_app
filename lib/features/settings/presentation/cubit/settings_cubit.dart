// lib/features/settings/presentation/cubit/settings_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/db/shared_pref_helper.dart';
import '../../../../core/utils/app_constans.dart';

part 'settings_state.dart';


/// Manages persisted UI preferences: theme, language, notifications.
/// Does NOT handle auth — that belongs to AuthCubit.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(const SettingsState(
    locale: Locale('ar'),
    themeMode: ThemeMode.light,
    notificationsEnabled: true,
  ));

  // ── Init ─────────────────────────────────────────────────────────────────

  /// Call once at startup to restore saved preferences.
  Future<void> loadSettings() async {
    final savedTheme    = await SharedPrefHelper.getString(key: AppConstants.themeMode);
    final savedLang     = await SharedPrefHelper.getString(key: AppConstants.languageCode);
    final savedNotifs   = await SharedPrefHelper.getBool(key: AppConstants.notifications);

    emit(state.copyWith(
      themeMode: _parseThemeMode(savedTheme),
      locale: savedLang != null ? Locale(savedLang) : const Locale('ar'),
      notificationsEnabled: savedNotifs ?? true,
    ));
  }

  // ── Theme ─────────────────────────────────────────────────────────────────

  Future<void> toggleTheme() async {
    final newMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newMode));
    await SharedPrefHelper.saveString(
      key: AppConstants.themeMode,
      value: newMode.name,
    );
  }

  // ── Language ──────────────────────────────────────────────────────────────

  /// Pass [context] so easy_localization can update the app locale immediately.
  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    final newLocale = Locale(languageCode);
    await context.setLocale(newLocale);
    emit(state.copyWith(locale: newLocale));
    await SharedPrefHelper.saveString(
      key: AppConstants.languageCode,
      value: languageCode,
    );
  }

  // ── Notifications ─────────────────────────────────────────────────────────

  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    emit(state.copyWith(notificationsEnabled: newValue));
    await SharedPrefHelper.saveBool(
      key: AppConstants.notifications,
      value: newValue,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  ThemeMode _parseThemeMode(String? raw) {
    return switch (raw) {
      'dark'   => ThemeMode.dark,
      'light'  => ThemeMode.light,
      'system' => ThemeMode.system,
      _        => ThemeMode.light,
    };
  }
}