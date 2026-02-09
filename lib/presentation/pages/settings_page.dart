import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiv_educ/presentation/providers/app_provider.dart';
import 'package:motiv_educ/core/services/localization_service.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final translations = LocalizationService.getTranslations(
        LocalizationService.getCurrentLocale());

    return Scaffold(
      appBar: AppBar(
        title: Text(translations['settings']!),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Apparence
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apparence',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Thème
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: const Text('Thème'),
                    subtitle: Text(provider.isDarkMode ? 'Sombre' : 'Clair'),
                    trailing: Switch(
                      value: provider.isDarkMode,
                      onChanged: (value) {
                        provider.toggleTheme();
                      },
                    ),
                  ),
                  
                  // Langue
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Langue'),
                    subtitle: Text(provider.currentLocale.languageCode == 'fr'
                        ? 'Français'
                        : 'English'),
                    onTap: () {
                      _showLanguageDialog(context, provider);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Section API
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuration',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.api),
                    title: const Text('URL de l\'API'),
                    subtitle: const Text(''),
                    onTap: () {
                      
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: const Text('Vérifier la connexion'),
                    onTap: () {
                      // TODO: Vérifier la connexion
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Section À propos
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'À propos',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('Développeur'),
                    subtitle: const Text('Alain Giresse TIANJANAHARY / RNO'),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Politique de confidentialité'),
                    onTap: () {
                 
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Bouton de réinitialisation
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showResetDialog(context);
              },
              icon: const Icon(Icons.restore),
              label: const Text('Réinitialiser l\'application'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir la langue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Français'),
                leading: const Icon(Icons.flag),
                onTap: () {
                  provider.setLocale(const Locale('fr', 'FR'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                leading: const Icon(Icons.flag),
                onTap: () {
                  provider.setLocale(const Locale('en', 'US'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Réinitialiser l\'application'),
          content: const Text(
              'Êtes-vous sûr de vouloir réinitialiser toutes les données de l\'application ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
               
                Navigator.pop(context);
              },
              child: const Text('Réinitialiser', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}