import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiv_educ/presentation/providers/backend_provider.dart';
import 'package:motiv_educ/presentation/widgets/backend_status.dart';
import 'package:motiv_educ/core/services/localization_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Vérifier la connexion au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BackendProvider>();
      provider.checkConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    final translations = LocalizationService.getTranslations(
        LocalizationService.getCurrentLocale());

    return Scaffold(
      appBar: AppBar(
        title: Text(translations['app_title']!),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Icon
            Icon(
              Icons.school_outlined,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 32),
            
            // Titre
            Text(
              translations['welcome']!,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            
            // Description
            Text(
              'Système intelligent de prédiction des résultats étudiants',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            
            // Status de l'API
            const BackendStatus(),
            const SizedBox(height: 32),
            
            // Bouton de démarrage
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/prediction');
                },
                icon: const Icon(Icons.analytics),
                label: Text(translations['start_analysis']!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Bouton historique
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                 
                },
                icon: const Icon(Icons.history),
                label: Text(translations['view_history']!),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}