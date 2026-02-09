import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiv_educ/presentation/providers/app_provider.dart';
import 'package:motiv_educ/presentation/providers/backend_provider.dart';
import 'package:motiv_educ/presentation/providers/prediction_provider.dart';
import 'package:motiv_educ/presentation/pages/home_page.dart';
import 'package:motiv_educ/core/services/localization_service.dart';
import 'package:motiv_educ/core/services/theme_service.dart';
import 'package:motiv_educ/presentation/pages/result_page.dart';
import 'package:motiv_educ/presentation/pages/prediction_form_page.dart';
import 'package:motiv_educ/presentation/pages/settings_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les services
  await LocalizationService.init();
  await ThemeService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => BackendProvider()),
        ChangeNotifierProvider(create: (_) => PredictionProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp(
            title: 'Student Prediction',
            debugShowCheckedModeBanner: false,
            theme: appProvider.currentTheme,
            locale: appProvider.currentLocale,
            supportedLocales: LocalizationService.supportedLocales,
            localizationsDelegates: LocalizationService.localizationsDelegates,
            home: const HomePage(),
            routes: {
              '/home': (context) => const HomePage(),
              '/prediction': (context) => const PredictionFormPage(),
              '/result': (context) => const ResultPage(),
              '/settings': (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}