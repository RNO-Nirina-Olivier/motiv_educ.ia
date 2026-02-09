import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiv_educ/presentation/providers/backend_provider.dart';
import 'package:motiv_educ/core/services/localization_service.dart';

class BackendStatus extends StatelessWidget {
  const BackendStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BackendProvider>();
    final translations = LocalizationService.getTranslations(
        LocalizationService.getCurrentLocale());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: provider.isConnected ? Colors.green[50] : Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: provider.isChecking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        provider.isConnected
                            ? Icons.check_circle
                            : Icons.error,
                        color: provider.isConnected ? Colors.green : Colors.red,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Status Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.isChecking
                        ? translations['checking_connection']!
                        : provider.isConnected
                            ? translations['api_connected']!
                            : translations['api_disconnected']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: provider.isConnected
                              ? Colors.green
                              : Colors.red,
                        ),
                  ),
                  if (provider.errorMessage != null)
                    Text(
                      provider.errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            
            // Refresh Button
            if (!provider.isChecking)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: provider.checkConnection,
                tooltip: 'Vérifier la connexion',
              ),
          ],
        ),
      ),
    );
  }
}