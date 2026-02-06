import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/views/add_gold.view.dart';
import 'package:e_mas/views/home.view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CollectionAdapter());
  await Hive.openBox<Collection>('collections');
  // if (kDebugMode) seedCollection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Mas',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/add-gold': (context) => AddGoldView(),
      },
    );
  }
}
