import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale state using Riverpod
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// StateNotifier for managing locale changes
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  static const String _languageKey = 'app_language';
  static const Locale _defaultLocale = Locale('en');

  /// Load saved language preference
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      state = Locale(languageCode);
    } catch (e) {
      state = _defaultLocale;
    }
  }

  /// Change the app language
  Future<void> changeLanguage(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
      state = locale;
    } catch (e) {
      // If saving fails, still update the locale
      state = locale;
    }
  }

  /// Toggle between English and Arabic
  Future<void> toggleLanguage() async {
    final newLocale = state.languageCode == 'ar' 
        ? const Locale('en') 
        : const Locale('ar');
    await changeLanguage(newLocale);
  }

  /// Check if current language is Arabic (RTL)
  bool get isArabic => state.languageCode == 'ar';

  /// Check if current language is English (LTR)
  bool get isEnglish => state.languageCode == 'en';
}

