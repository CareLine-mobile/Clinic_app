// lib/features/settings/presentation/cubit/settings_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/db/shared_pref_helper.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/utils/app_constans.dart';
import '../../data/setting_repo_impl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'settings_state.dart';




class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepositoryImpl _settingsRepo;

  SettingsCubit({required SettingsRepositoryImpl settingsRepository})
      : _settingsRepo = settingsRepository,
        super(const SettingsState(
        locale: Locale('ar'),
        themeMode: ThemeMode.light,
        notificationsEnabled: false,
      ));

  // ── Init ─────────────────────────────────────────────────────────────────

  Future<void> loadSettings() async {
    final savedTheme  = await SharedPrefHelper.getString(key: AppConstants.themeMode);
    final savedLang   = await SharedPrefHelper.getString(key: AppConstants.languageCode);
    final savedNotifs = await SharedPrefHelper.getBool(key: AppConstants.notifications);

    emit(state.copyWith(
      themeMode: _parseThemeMode(savedTheme),
      locale: savedLang != null ? Locale(savedLang) : const Locale('ar'),
      notificationsEnabled: savedNotifs ?? false,
      clearError: true,
    ));

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (state.notificationsEnabled) {
        _settingsRepo.registerFcmToken(newToken).ignore();
      }
    });
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

  Future<void> syncFcmToken() async {
    if (state.notificationsEnabled) {
      final token = await _settingsRepo.requestPermissionAndGetToken();
      if (token != null) {
        try {
          await _settingsRepo.registerFcmToken(token);
        } catch (_) {
          // Ignore background sync errors
        }
      }
    }
  }

  /// Toggles notifications.
  ///
  /// Enabling: requests OS permission → gets FCM token → POSTs to backend.
  ///   • On success: persists enabled=true, emits enabled state.
  ///   • On failure: stays disabled, emits error message for the UI to show.
  ///
  /// Disabling: simply persists and emits disabled (no API call needed).
  Future<void> toggleNotifications() async {
    // Clear any stale error before a new attempt
    emit(state.copyWith(clearError: true));

    final enabling = !state.notificationsEnabled;

    if (!enabling) {
      // Turning off — instant, no network
      await _persistNotifications(false);
      emit(state.copyWith(notificationsEnabled: false));
      return;
    }

    // ── Enabling path ──────────────────────────────────────────────────────
    emit(state.copyWith(notificationsLoading: true));

    try {
      final token = await _settingsRepo.requestPermissionAndGetToken();

      if (token == null) {
        // User denied OS permission
        emit(state.copyWith(
          notificationsLoading: false,
          notificationsEnabled: false,
          notificationsError: 'settings.notifications.permission_denied',
        ));
        return;
      }

      await _settingsRepo.registerFcmToken(token);

      // ✓ Success
      await _persistNotifications(true);
      emit(state.copyWith(
        notificationsEnabled: true,
        notificationsLoading: false,
        clearError: true,
      ));
    } catch (e) {
      // ✗ API failure — revert
      final failure = ErrorHandler.handleException(e);
      emit(state.copyWith(
        notificationsEnabled: false,
        notificationsLoading: false,
        notificationsError: failure.message,
      ));
    }
  }

  Future<void> clearNotifications() async {
    if (state.notificationsEnabled) {
      await _persistNotifications(false);
      emit(state.copyWith(notificationsEnabled: false));
    }
  }

  Future<void> _persistNotifications(bool value) async {
    await SharedPrefHelper.saveBool(
      key: AppConstants.notifications,
      value: value,
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