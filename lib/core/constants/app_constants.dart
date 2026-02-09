class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://backend-educ-ia.onrender.com';
  static const String healthEndpoint = '/health';
  static const String predictEndpoint = '/predict';
  
  // App Configuration
  static const String appName = 'Student Prediction';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String themeKey = 'app_theme';
  static const String localeKey = 'app_locale';
  static const String historyKey = 'prediction_history';
  
  static Map<String, String> featureDescriptions = {
    'imp2': '1. Vérification des devoirs par les parents',
    'imp3': '2. Supervision des devoirs par les parents',
    'imp5': '3. Attentes éducatives des parents',
    'imp6': '4. Lecture partagée avec l\'enfant',
    'imp10': '5. Supervision générale à la maison',
    'Ran_TbB': '6. Rang dans la salle de classe (1-30)',
    'cour_supl': '7. Participation aux cours de soutien',
    'elev_presco': '8. Préscolarisation',
    'nbre_elev_SDC': '9. Nombre d\'élèves dans la classe',
    'mere_niv_ac': '10. Niveau académique de la mère',
    'etab_prim_stat': '11. Statut de l\'établissement',
  };
  
  static Map<String, List<String>> featureOptions = {
    'imp2': ['Non', 'Oui'],
    'imp3': ['Non', 'Oui'],
    'imp5': ['Non', 'Oui'],
    'imp6': ['Non', 'Oui'],
    'imp10': ['Non', 'Oui'],
    'cour_supl': ['Non', 'Oui'],
    'elev_presco': ['Non', 'Oui'],
    'mere_niv_ac': ['Aucun', 'Primaire', 'Secondaire', 'Supérieur'],
    'etab_prim_stat': ['Privé', 'Public'],
  };
  
    static Map<String, Map<String, String>> featureValueMapping = {
    'imp2': {'Non': '0', 'Oui': '1'},
    'imp3': {'Non': '0', 'Oui': '1'},
    'imp5': {'Non': '0', 'Oui': '1'},
    'imp6': {'Non': '0', 'Oui': '1'},
    'imp10': {'Non': '0', 'Oui': '1'},
    'cour_supl': {'Non': '0', 'Oui': '1'},
    'elev_presco': {'Non': '0', 'Oui': '1'},
    'mere_niv_ac': {'Aucun': '0', 'Primaire': '1', 'Secondaire': '2', 'Supérieur': '3'},
    'etab_prim_stat': {'Privé': '0', 'Public': '1'},
  };
  static Map<String, String> featureSimpleLabels = {
    'imp2': 'Vérification des devoirs',
    'imp3': 'Supervision des devoirs',
    'imp5': 'Attentes éducatives',
    'imp6': 'Lecture partagée',
    'imp10': 'Supervision à la maison',
    'Ran_TbB': 'Rang en classe',
    'cour_supl': 'Cours de soutien',
    'elev_presco': 'Préscolarisation',
    'nbre_elev_SDC': 'Effectif classe',
    'mere_niv_ac': 'Niveau mère',
    'etab_prim_stat': 'Type établissement',
  };
  
  static Map<String, Map<String, dynamic>> featureEncoding = {
    'imp2': {'0': 'Non', '1': 'Oui'},
    'imp3': {'0': 'Non', '1': 'Oui'},
    'imp5': {'0': 'Non', '1': 'Oui'},
    'imp6': {'0': 'Non', '1': 'Oui'},
    'imp10': {'0': 'Non', '1': 'Oui'},
    'cour_supl': {'0': 'Non', '1': 'Oui'},
    'elev_presco': {'0': 'Non', '1': 'Oui'},
    'mere_niv_ac': {'0': 'Aucun', '1': 'Primaire', '2': 'Secondaire', '3': 'Supérieur'},
    'etab_prim_stat': {'0': 'Privé', '1': 'Public'},
  };
}