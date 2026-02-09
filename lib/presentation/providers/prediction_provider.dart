import 'package:flutter/material.dart';
import 'package:motiv_educ/data/models/student_model.dart';
import 'package:motiv_educ/data/services/api_service.dart';

class PredictionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  StudentModel _studentData = StudentModel();
  PredictionResponse? _predictionResult;
  bool _isLoading = false;
  String? _errorMessage;
  List<PredictionResponse> _history = [];

  StudentModel get studentData => _studentData;
  PredictionResponse? get predictionResult => _predictionResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PredictionResponse> get history => _history;

  // Mettre à jour les données avec gestion d'encodage automatique
  void updateStudentData(String key, dynamic value) {
    switch (key) {
      case 'imp2':
        _studentData.imp2 = _parseDouble(value);
        break;
      case 'imp3':
        _studentData.imp3 = _parseDouble(value);
        break;
      case 'imp5':
        _studentData.imp5 = _parseDouble(value);
        break;
      case 'imp6':
        _studentData.imp6 = _parseDouble(value);
        break;
      case 'imp10':
        _studentData.imp10 = _parseDouble(value);
        break;
      case 'Ran_TbB':
        _studentData.ranTbB = _parseDouble(value);
        break;
      case 'cour_supl':
        _studentData.courSupl = _parseDouble(value);
        break;
      case 'elev_presco':
        _studentData.elevPresco = _parseDouble(value);
        break;
      case 'nbre_elev_SDC':
        _studentData.nbreElevSDC = _parseDouble(value);
        break;
      case 'mere_niv_ac':
        _studentData.updateMereNivAc(_parseString(value));
        break;
      case 'etab_prim_stat':
        _studentData.updateEtabPrimStat(_parseString(value));
        break;
    }
    notifyListeners();
  }

  // Méthode pour soumettre la prédiction (version améliorée)
  Future<void> submitPrediction() async {
    if (!_validateData()) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Appeler l'API avec les données encodées
      final response = await _apiService.predict(_studentData);
      
      _predictionResult = response;
      _addToHistory(response);
      
    } catch (e) {
      _errorMessage = _formatErrorMessage(e);
      _predictionResult = null;
      print('Erreur lors de la prédiction: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour soumettre à partir de données brutes
  Future<void> submitPredictionFromMap(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Convertir et valider les données
      final studentModel = _convertMapToStudentModel(data);
      
      if (!_validateStudentModel(studentModel)) {
        throw Exception('Données invalides');
      }

      // Mettre à jour les données internes
      _studentData = studentModel;
      
      // Appeler l'API
      final response = await _apiService.predict(studentModel);
      
      _predictionResult = response;
      _addToHistory(response);
      
    } catch (e) {
      _errorMessage = _formatErrorMessage(e);
      _predictionResult = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Convertir un Map en StudentModel avec encodage automatique
  StudentModel _convertMapToStudentModel(Map<String, dynamic> data) {
    return StudentModel(
      imp2: _parseDouble(data['imp2']),
      imp3: _parseDouble(data['imp3']),
      imp5: _parseDouble(data['imp5']),
      imp6: _parseDouble(data['imp6']),
      imp10: _parseDouble(data['imp10']),
      ranTbB: _parseDouble(data['Ran_TbB']),
      courSupl: _parseDouble(data['cour_supl']),
      elevPresco: _parseDouble(data['elev_presco']),
      nbreElevSDC: _parseDouble(data['nbre_elev_SDC']),
      // Les variables catégorielles seront automatiquement encodées
      mereNivAc: _parseString(data['mere_niv_ac']),
      etabPrimStat: _parseString(data['etab_prim_stat']),
    );
  }

  // Valider les données avant soumission
  bool _validateData() {
    // Vérifier les champs obligatoires
    if (_studentData.imp2 == null && _studentData.imp3 == null) {
      _errorMessage = 'Au moins une des features imp2 ou imp3 est requise';
      notifyListeners();
      return false;
    }

    // Vérifier les variables catégorielles
    if (_studentData.mereNivAc != null) {
      final encoded = _studentData.mereNivAcEncoded;
      if (encoded == null || encoded < 0 || encoded > 3) {
        _errorMessage = 'Niveau académique de la mère invalide. Valeurs acceptées: 0-3 (Aucun=0, Primaire=1, Secondaire=2, Supérieur=3)';
        notifyListeners();
        return false;
      }
    }

    if (_studentData.etabPrimStat != null) {
      final encoded = _studentData.etabPrimStatEncoded;
      if (encoded == null || (encoded != 0 && encoded != 1)) {
        _errorMessage = 'Statut d\'établissement invalide. Valeurs acceptées: 0 (Privé) ou 1 (Public)';
        notifyListeners();
        return false;
      }
    }

    return true;
  }

  bool _validateStudentModel(StudentModel model) {
    // Vérifier les champs obligatoires
    if (model.imp2 == null && model.imp3 == null) {
      _errorMessage = 'Au moins une des features imp2 ou imp3 est requise';
      return false;
    }
    return true;
  }

  // Méthodes de parsing
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        // Nettoyer la chaîne pour les nombres
        final cleaned = value
            .replaceAll(',', '.')
            .replaceAll(RegExp(r'[^\d.-]'), '')
            .trim();
        
        if (cleaned.isEmpty) return null;
        return double.parse(cleaned);
      } catch (e) {
        print('Erreur de parsing double: $e pour "$value"');
        return null;
      }
    }
    return null;
  }

  String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isNotEmpty ? value : null;
    return value.toString();
  }

  // Formater les messages d'erreur
  String _formatErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error is Exception) return error.toString();
    return 'Une erreur est survenue';
  }

  void _addToHistory(PredictionResponse response) {
    _history.insert(0, response);
    // Limiter l'historique à 50 entrées
    if (_history.length > 50) {
      _history = _history.sublist(0, 50);
    }
    notifyListeners();
  }

  // Méthodes utilitaires pour l'UI
  List<String> get mereNivAcOptions => StudentModel.mereNivAcOptions;
  List<String> get etabPrimStatOptions => StudentModel.etabPrimStatOptions;

  Map<String, String> get mereNivAcOptionsWithEncoding {
    final result = <String, String>{};
    for (final option in StudentModel.mereNivAcOptions) {
      final encoded = StudentModel.mereNivAcEncodingMap[option];
      result[option] = '→ $encoded';
    }
    return result;
  }

  Map<String, String> get etabPrimStatOptionsWithEncoding {
    final result = <String, String>{};
    for (final option in StudentModel.etabPrimStatOptions) {
      final encoded = StudentModel.etabPrimStatEncodingMap[option];
      result[option] = '→ $encoded';
    }
    return result;
  }

  // Obtenir les données prêtes pour l'API (pour débogage)
  Map<String, dynamic> getDataForApi() {
    final data = _studentData.toJson();
    
    print('=== DONNÉES ENVOYÉES À L\'API ===');
    print('Variables numériques:');
    data.forEach((key, value) {
      if (key != 'mere_niv_ac' && key != 'etab_prim_stat') {
        print('  $key: $value');
      }
    });
    
    print('\nVariables catégorielles encodées:');
    print('  mere_niv_ac: ${_studentData.mereNivAc} → ${_studentData.mereNivAcEncoded}');
    print('  etab_prim_stat: ${_studentData.etabPrimStat} → ${_studentData.etabPrimStatEncoded}');
    print('===============================');
    
    return data;
  }

  // Réinitialiser le formulaire
  void resetForm() {
    _studentData = StudentModel();
    _predictionResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  // Charger un historique existant (pour la persistance)
  void loadHistory(List<PredictionResponse> savedHistory) {
    _history = savedHistory;
    notifyListeners();
  }

  // Méthode pour tester l'encodage
  void testEncoding() {
    print('=== TEST D\'ENCODAGE ===');
    
    // Test mere_niv_ac
    final testCasesMere = {
      'Aucun': 0,
      'Primaire': 1,
      'Secondaire': 2,
      'Supérieur': 3,
    };
    
    testCasesMere.forEach((text, expected) {
      _studentData.updateMereNivAc(text);
      final encoded = _studentData.mereNivAcEncoded;
      print('mere_niv_ac: "$text" → $encoded (attendu: $expected)');
      assert(encoded == expected);
    });
    
    // Test etab_prim_stat
    final testCasesEtab = {
      'Public': 1,
      'Privé': 0,
    };
    
    testCasesEtab.forEach((text, expected) {
      _studentData.updateEtabPrimStat(text);
      final encoded = _studentData.etabPrimStatEncoded;
      print('etab_prim_stat: "$text" → $encoded (attendu: $expected)');
      assert(encoded == expected);
    });
    
    print('=== TEST RÉUSSI ===');
    
    resetForm();
  }
}