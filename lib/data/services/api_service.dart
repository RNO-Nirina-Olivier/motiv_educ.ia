import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motiv_educ/core/constants/app_constants.dart';
import 'package:motiv_educ/data/models/student_model.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = AppConstants.baseUrl});

  Future<PredictionResponse> predict(StudentModel studentData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AppConstants.predictEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(studentData.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PredictionResponse.fromJson(data);
      } else if (response.statusCode == 400) {
        throw Exception('Données invalides: ${response.body}');
      } else if (response.statusCode == 503) {
        throw Exception('Service temporairement indisponible');
      } else {
        throw Exception(
            'Erreur serveur: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${AppConstants.healthEndpoint}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'OK';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getMissingFeatures(Map<String, dynamic> data) async {
    try {
      // Cette méthode pourrait être implémentée côté backend
      // Pour l'instant, on vérifie simplement les features requises
      final requiredFeatures = [
        'imp2',
        'imp3',
        'Ran_TbB',
        'cour_supl',
      ];

      final missing = <String>[];
      for (final feature in requiredFeatures) {
        if (!data.containsKey(feature) || data[feature] == null) {
          missing.add(feature);
        }
      }
      return missing;
    } catch (e) {
      return [];
    }
  }
}
