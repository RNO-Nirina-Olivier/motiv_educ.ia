import 'package:flutter/material.dart';
import 'package:motiv_educ/core/services/localization_service.dart';
import 'package:motiv_educ/core/services/theme_service.dart';

class AppProvider extends ChangeNotifier {
  ThemeData _currentTheme = ThemeService.getCurrentTheme();
  Locale _currentLocale = LocalizationService.getCurrentLocale();
  bool _isLoading = false;

  ThemeData get currentTheme => _currentTheme;
  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  Future<void> toggleTheme() async {
    final newTheme = isDarkMode ? 'light' : 'dark';
    await ThemeService.setTheme(newTheme);
    _currentTheme = ThemeService.getCurrentTheme();
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    await ThemeService.setTheme(theme);
    _currentTheme = ThemeService.getCurrentTheme();
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    await LocalizationService.setLocale(locale);
    _currentLocale = locale;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void refresh() {
    _currentTheme = ThemeService.getCurrentTheme();
    _currentLocale = LocalizationService.getCurrentLocale();
    notifyListeners();
  }
}