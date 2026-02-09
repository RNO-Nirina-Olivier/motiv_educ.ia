import 'package:flutter/material.dart';
import 'package:motiv_educ/data/services/api_service.dart';

class BackendProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isConnected = false;
  bool _isChecking = false;
  String? _errorMessage;
  String _apiUrl = 'https://backend-educ-ia.onrender.com';

  bool get isConnected => _isConnected;
  bool get isChecking => _isChecking;
  String? get errorMessage => _errorMessage;
  String get apiUrl => _apiUrl;

  Future<void> checkConnection() async {
    _isChecking = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isHealthy = await _apiService.checkHealth();
      _isConnected = isHealthy;
      if (!isHealthy) {
        _errorMessage = 'Impossible de se connecter';
      }
    } catch (e) {
      _isConnected = false;
      _errorMessage = 'Erreur de connexion: $e';
    } finally {
      _isChecking = false;
      notifyListeners();
    }
  }

  Future<void> updateApiUrl(String newUrl) async {
    _apiUrl = newUrl;
    notifyListeners();
    await checkConnection();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}