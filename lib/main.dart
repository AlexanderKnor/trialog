import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trialog/core/config/theme_config.dart';
import 'package:trialog/core/providers/app_providers.dart';
import 'package:trialog/core/routes/app_router.dart';
import 'package:trialog/core/utils/logger.dart';
import 'package:trialog/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase (check if already initialized to avoid hot reload issues)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      Logger.info('Firebase initialized successfully');
    } else {
      Logger.info('Firebase already initialized (hot reload)');
    }

    // Initialize dependencies
    final sharedPreferences = await SharedPreferences.getInstance();

    Logger.info('Application starting...');

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const TrialogApp(),
      ),
    );
  } catch (e, stackTrace) {
    Logger.error(
      'Failed to initialize application',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Trialog application root widget
class TrialogApp extends ConsumerWidget {
  const TrialogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter.router;

    return MaterialApp.router(
      title: 'Trialog',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.system,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'), // German
        Locale('en', 'US'), // English
      ],
      locale: const Locale('de', 'DE'),

      // Routing
      routerConfig: router,
    );
  }
}
