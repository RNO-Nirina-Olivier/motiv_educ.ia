import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:motiv_educ/presentation/providers/prediction_provider.dart';
import 'package:motiv_educ/core/services/localization_service.dart';


class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PredictionProvider>();
    final result = provider.predictionResult;
    final translations = LocalizationService.getTranslations(
        LocalizationService.getCurrentLocale());

    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(translations['prediction']!),
        ),
        body: const Center(
          child: Text('Aucun résultat disponible'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(translations['prediction']!),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implémenter le partage
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // TODO: Sauvegarder le résultat
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Résultat principal
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Icône de résultat
                    Icon(
                      result.prediction == 1
                          ? Icons.check_circle
                          : Icons.warning,
                      size: 64,
                      color: result.prediction == 1
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    
                    // Label de prédiction
                    Text(
                      result.predictionLabel,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: result.prediction == 1
                                ? Colors.green
                                : Colors.orange,
                          ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Confiance
                    Text(
                      '${translations['confidence']!}: ${result.confidence.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Probabilités
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translations['probability']!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Barre de progression pour Admis
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${translations['admitted']!}: ${result.probabilities.admis.toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              LinearPercentIndicator(
                                percent: result.probabilities.admis / 100,
                                lineHeight: 20,
                                backgroundColor: Colors.grey[200],
                                progressColor: Colors.green,
                                barRadius: const Radius.circular(10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Barre de progression pour Non Admis
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${translations['not_admitted']!}: ${result.probabilities.nonAdmis.toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              LinearPercentIndicator(
                                percent: result.probabilities.nonAdmis / 100,
                                lineHeight: 20,
                                backgroundColor: Colors.grey[200],
                                progressColor: Colors.orange,
                                barRadius: const Radius.circular(10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recommandations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translations['recommendations']!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Suggestions pour améliorer les chances d\'admission',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    
                    // Liste des recommandations
                    ...result.recommendations.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final recommendation = entry.value;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$index',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                recommendation,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/prediction');
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text('Nouvelle Prédiction'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: Text('Accueil'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}