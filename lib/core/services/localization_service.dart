import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motiv_educ/core/constants/app_constants.dart';

class LocalizationService {
  static late SharedPreferences _prefs;
  
  // Supported locales
  static const Locale frLocale = Locale('fr', 'FR');
  static const Locale enLocale = Locale('en', 'US');
  
  static final List<Locale> supportedLocales = [frLocale, enLocale];
  
  static final localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static Locale getCurrentLocale() {
    final localeCode = _prefs.getString(AppConstants.localeKey) ?? 'fr_FR';
    final parts = localeCode.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }
  
  static Future<void> setLocale(Locale locale) async {
    await _prefs.setString(
      AppConstants.localeKey,
      '${locale.languageCode}_${locale.countryCode}'
    );
  }
  
  static Map<String, String> getTranslations(Locale locale) {
    if (locale.languageCode == 'fr') {
      return frenchTranslations;
    } else {
      return englishTranslations;
    }
  }
  
  static final Map<String, String> frenchTranslations = {
    'app_title': 'Prédiction Étudiante',
    'welcome': 'Bienvenue',
    'start_analysis': 'Commencer l\'Analyse',
    'view_history': 'Voir l\'Historique',
    'settings': 'Paramètres',
    'student_info': 'Informations de l\'Élève',
    'prediction': 'Prédiction',
    'recommendations': 'Recommandations',
    'submit': 'Soumettre',
    'loading': 'Chargement...',
    'error': 'Erreur',
    'retry': 'Réessayer',
    'success': 'Succès',
    'admitted': 'Admis',
    'not_admitted': 'Non Admis',
    'probability': 'Probabilité',
    'confidence': 'Confiance',
    'required_field': 'Ce champ est requis',
    'invalid_value': 'Valeur invalide',
    'api_connected': 'API Connectée',
    'api_disconnected': 'API Déconnectée',
    'checking_connection': 'Vérification de la connexion...',
  };
  
  static final Map<String, String> englishTranslations = {
    'app_title': 'Student Prediction',
    'welcome': 'Welcome',
    'start_analysis': 'Start Analysis',
    'view_history': 'View History',
    'settings': 'Settings',
    'student_info': 'Student Information',
    'prediction': 'Prediction',
    'recommendations': 'Recommendations',
    'submit': 'Submit',
    'loading': 'Loading...',
    'error': 'Error',
    'retry': 'Retry',
    'success': 'Success',
    'admitted': 'Admitted',
    'not_admitted': 'Not Admitted',
    'probability': 'Probability',
    'confidence': 'Confidence',
    'required_field': 'This field is required',
    'invalid_value': 'Invalid value',
    'api_connected': 'API Connected',
    'api_disconnected': 'API Disconnected',
    'checking_connection': 'Checking connection...',
  };
}