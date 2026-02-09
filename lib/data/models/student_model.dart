import 'dart:convert';

class StudentModel {
  double? imp2;
  double? imp3;
  double? imp5;
  double? imp6;
  double? imp10;
  double? ranTbB;
  double? courSupl;
  double? elevPresco;
  double? nbreElevSDC;

  String? mereNivAc;
  String? etabPrimStat;

  int? _mereNivAcEncoded;
  int? _etabPrimStatEncoded;

  StudentModel({
    this.imp2,
    this.imp3,
    this.imp5,
    this.imp6,
    this.imp10,
    this.ranTbB,
    this.courSupl,
    this.elevPresco,
    this.nbreElevSDC,
    this.mereNivAc,
    this.etabPrimStat,
  }) {
    _encodeCategoricalValues();
  }

  void _encodeCategoricalValues() {
    _mereNivAcEncoded = _encodeMereNivAc(mereNivAc);
    _etabPrimStatEncoded = _encodeEtabPrimStat(etabPrimStat);
  }

  static int? _encodeMereNivAc(String? value) {
    if (value == null) return null;

    final normalized = value.trim().toLowerCase();

    switch (normalized) {
      case 'aucun':
      case '0':
        return 0;
      case 'primaire':
      case '1':
        return 1;
      case 'secondaire':
      case '2':
        return 2;
      case 'supérieur':
      case 'superieur':
      case '3':
        return 3;
      default:
        return int.tryParse(normalized);
    }
  }

  static int? _encodeEtabPrimStat(String? value) {
    if (value == null) return null;

    final normalized = value.trim().toLowerCase();

    switch (normalized) {
      case 'public':
      case '1':
        return 1;
      case 'privé':
      case 'prive':
      case '0':
        return 0;
      default:
        return int.tryParse(normalized);
    }
  }

  static String? _decodeMereNivAc(dynamic value) {
    if (value == null) return null;

    final intValue = _parseInt(value);

    switch (intValue) {
      case 0:
        return 'Aucun';
      case 1:
        return 'Primaire';
      case 2:
        return 'Secondaire';
      case 3:
        return 'Supérieur';
      default:
        return null;
    }
  }

  static String? _decodeEtabPrimStat(dynamic value) {
    if (value == null) return null;

    final intValue = _parseInt(value);

    switch (intValue) {
      case 1:
        return 'Public';
      case 0:
        return 'Privé';
      default:
        return null;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  int? get mereNivAcEncoded => _mereNivAcEncoded;
  int? get etabPrimStatEncoded => _etabPrimStatEncoded;

  void updateMereNivAc(String? value) {
    mereNivAc = value;
    _mereNivAcEncoded = _encodeMereNivAc(value);
  }

  void updateEtabPrimStat(String? value) {
    etabPrimStat = value;
    _etabPrimStatEncoded = _encodeEtabPrimStat(value);
  }

  void updateMereNivAcEncoded(int? value) {
    _mereNivAcEncoded = value;
    mereNivAc = _decodeMereNivAc(value);
  }

  void updateEtabPrimStatEncoded(int? value) {
    _etabPrimStatEncoded = value;
    etabPrimStat = _decodeEtabPrimStat(value);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (imp2 != null) data['imp2'] = imp2;
    if (imp3 != null) data['imp3'] = imp3;
    if (imp5 != null) data['imp5'] = imp5;
    if (imp6 != null) data['imp6'] = imp6;
    if (imp10 != null) data['imp10'] = imp10;
    if (ranTbB != null) data['Ran_TbB'] = ranTbB;
    if (courSupl != null) data['cour_supl'] = courSupl;
    if (elevPresco != null) data['elev_presco'] = elevPresco;
    if (nbreElevSDC != null) data['nbre_elev_SDC'] = nbreElevSDC;

    if (_mereNivAcEncoded != null) data['mere_niv_ac'] = _mereNivAcEncoded;
    if (_etabPrimStatEncoded != null)
      data['etab_prim_stat'] = _etabPrimStatEncoded;

    return data;
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final model = StudentModel(
      imp2: _safeParseDouble(json['imp2']),
      imp3: _safeParseDouble(json['imp3']),
      imp5: _safeParseDouble(json['imp5']),
      imp6: _safeParseDouble(json['imp6']),
      imp10: _safeParseDouble(json['imp10']),
      ranTbB: _safeParseDouble(json['Ran_TbB']),
      courSupl: _safeParseDouble(json['cour_supl']),
      elevPresco: _safeParseDouble(json['elev_presco']),
      nbreElevSDC: _safeParseDouble(json['nbre_elev_SDC']),
    );

    model.updateMereNivAcEncoded(_parseInt(json['mere_niv_ac']));
    model.updateEtabPrimStatEncoded(_parseInt(json['etab_prim_stat']));

    return model;
  }

  static double? _safeParseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value.replaceAll(',', '.'));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static List<String> get mereNivAcOptions => const [
        'Aucun',
        'Primaire',
        'Secondaire',
        'Supérieur',
      ];

  static List<String> get etabPrimStatOptions => const [
        'Public',
        'Privé',
      ];

  static Map<String, int> get mereNivAcEncodingMap => const {
        'Aucun': 0,
        'Primaire': 1,
        'Secondaire': 2,
        'Supérieur': 3,
      };

  static Map<String, int> get etabPrimStatEncodingMap => const {
        'Public': 1,
        'Privé': 0,
      };

  static Map<int, String> get mereNivAcDecodingMap => const {
        0: 'Aucun',
        1: 'Primaire',
        2: 'Secondaire',
        3: 'Supérieur',
      };

  static Map<int, String> get etabPrimStatDecodingMap => const {
        1: 'Public',
        0: 'Privé',
      };
}

// ==============================================
// CLASSES DE RÉPONSE DE PRÉDICTION
// ==============================================

class PredictionResponse {
  final bool success;
  final int prediction;
  final String predictionLabel;
  final PredictionProbabilities probabilities;
  final double confidence;
  final List<String> recommendations;
  final DateTime timestamp;

  PredictionResponse({
    required this.success,
    required this.prediction,
    required this.predictionLabel,
    required this.probabilities,
    required this.confidence,
    required this.recommendations,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      success: json['success'] as bool? ?? false,
      prediction: _parseInt(json['prediction']),
      predictionLabel:
          _parseString(json['prediction_label'] ?? json['predictionLabel']) ??
              'Non admis',
      probabilities: PredictionProbabilities.fromJson(
        // SOLUTION 1 (la plus simple)
        (json['probabilities'] as Map<String, dynamic>?) ?? {},
      ),
      confidence: _parseDouble(json['confidence']),
      recommendations: _parseStringList(json['recommendations']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll('%', '').trim();
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  factory PredictionResponse.fromJsonString(String jsonString) {
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return PredictionResponse.fromJson(jsonMap);
    } catch (e) {
      return PredictionResponse(
        success: false,
        prediction: 0,
        predictionLabel: 'Erreur',
        probabilities: PredictionProbabilities(admis: 0, nonAdmis: 0),
        confidence: 0,
        recommendations: ['Erreur de traitement des données'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'prediction': prediction,
      'prediction_label': predictionLabel,
      'probabilities': probabilities.toJson(),
      'confidence': confidence,
      'recommendations': recommendations,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  String get summary {
    return '$predictionLabel (${confidence.toStringAsFixed(1)}% de confiance)';
  }

  bool get isAdmitted => prediction == 1;
}

class PredictionProbabilities {
  final double admis;
  final double nonAdmis;

  PredictionProbabilities({
    required this.admis,
    required this.nonAdmis,
  });

  factory PredictionProbabilities.fromJson(Map<String, dynamic> json) {
    final admisValue = json['admis'] ?? json['Admis'] ?? 0;
    final nonAdmisValue =
        json['non_admis'] ?? json['nonAdmis'] ?? json['Non admis'] ?? 0;

    return PredictionProbabilities(
      admis: _parseDouble(admisValue),
      nonAdmis: _parseDouble(nonAdmisValue),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll('%', '').trim();
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'admis': admis,
      'non_admis': nonAdmis,
    };
  }

  double get total => admis + nonAdmis;
  double get admisPercentage => (admis / total * 100);
  double get nonAdmisPercentage => (nonAdmis / total * 100);
}
