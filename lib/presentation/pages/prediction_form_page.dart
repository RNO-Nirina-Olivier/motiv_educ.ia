import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiv_educ/presentation/providers/prediction_provider.dart';
import 'package:motiv_educ/presentation/widgets/feature_card.dart';
import 'package:motiv_educ/core/constants/app_constants.dart';
import 'package:motiv_educ/core/services/localization_service.dart';

class PredictionFormPage extends StatefulWidget {
  const PredictionFormPage({super.key});

  @override
  State<PredictionFormPage> createState() => _PredictionFormPageState();
}

class _PredictionFormPageState extends State<PredictionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs
    for (final feature in AppConstants.featureDescriptions.keys) {
      _controllers[feature] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Nettoyer les contrôleurs
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PredictionProvider>();
    final translations = LocalizationService.getTranslations(
        LocalizationService.getCurrentLocale());

    return Scaffold(
      appBar: AppBar(
        title: Text(translations['student_info']!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Formulaire de Prédiction',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Remplissez les informations ci-dessous pour obtenir une prédiction',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Features Section
              ..._buildFeatureCards(),

              const SizedBox(height: 24),

              // Submit Button
              if (provider.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (provider.errorMessage != null)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () => provider.clearError(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _submitForm(provider);
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: Text(translations['submit']!),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureCards() {
    final widgets = <Widget>[];
    final features = AppConstants.featureDescriptions;

    for (final entry in features.entries) {
      final feature = entry.key;
      final description = entry.value;
      final options = AppConstants.featureOptions[feature];

      widgets.add(
        FeatureCard(
          feature: feature,
          description: description,
          controller: _controllers[feature]!,
          options: options,
          onChanged: (value) {
            // Mettre à jour le provider
            final provider = context.read<PredictionProvider>();
            provider.updateStudentData(feature, value);
          },
        ),
      );
      widgets.add(const SizedBox(height: 12));
    }

    return widgets;
  }

Future<void> _submitForm(PredictionProvider provider) async {
  // Collecter les données du formulaire
  final studentData = <String, dynamic>{};

  for (final entry in _controllers.entries) {
    final feature = entry.key;
    final controller = entry.value;
    
    if (controller.text.isNotEmpty) {
      // Les valeurs sont déjà encodées (0/1) grâce au FeatureCard
      final options = AppConstants.featureOptions[feature];
      if (options != null) {
        // Pour les dropdowns, la valeur est déjà 0/1
        studentData[feature] = controller.text;
      } else {
        // Pour les champs texte, convertir en double
        final value = double.tryParse(controller.text);
        if (value != null) {
          studentData[feature] = value;
        }
      }
    }
  }

  // Debug: Afficher les données envoyées
  print('Données envoyées à l\'API: $studentData');

  // Soumettre la prédiction
  await provider.submitPrediction();

  // Si succès, naviguer vers la page de résultat
  if (provider.predictionResult != null && provider.errorMessage == null) {
    Navigator.pushNamed(context, '/result');
  }
}
}