import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/seed/collection_seeder.dart';
import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/views/add_gold.view.dart';
import 'package:e_mas/views/attributions.view.dart';
import 'package:e_mas/views/home.view.dart';
import 'package:e_mas/views/settings.view.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CollectionAdapter());
  await Hive.openBox<Collection>('collections');

  debugPrint('🔧 Debug mode: $kDebugMode');
  if (kDebugMode) {
    debugPrint('🌱 Calling seedCollection...');
    await seedCollection();
  } else {
    debugPrint('🚀 Release mode - skipping seed');
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auregia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(
          primary: AppColors.gold,
          surface: AppColors.cardBackground,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: AppTextStyles.headingSmall,
        ),
        textTheme: TextTheme(
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/add-gold': (context) => AddGoldView(),
        '/settings': (context) => SettingsView(),
        '/attributions': (context) => AttributionsView(),
      },
      // Enable proper back navigation
      onGenerateRoute: (settings) {
        // Handle unknown routes or add custom route transitions
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => HomeView());
          case '/add-gold':
            return MaterialPageRoute(builder: (_) => AddGoldView());
          case '/settings':
            return MaterialPageRoute(builder: (_) => SettingsView());
          case '/attributions':
            return MaterialPageRoute(builder: (_) => AttributionsView());
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('Route not found: ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}
