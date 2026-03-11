import 'package:e_mas/models/collection.model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> seedCollection() async {
  final box = Hive.box<Collection>('collections');

  // Only seed if box is empty (fresh install or manually cleared)
  if (box.isNotEmpty) {
    debugPrint('📦 Box already has ${box.length} items, skipping seed');
    return;
  }

  // Check if we've already seeded before (using SharedPreferences)
  final prefs = await SharedPreferences.getInstance();
  final hasSeeded = prefs.getBool('_hasSeededCollection') ?? false;

  if (hasSeeded) {
    debugPrint('⚠️ Already seeded in previous run, skipping...');
    return;
  }

  debugPrint('🌱 Seeding collection data...');

  final testCollections = [
    // UBS Gold - smaller amounts
    Collection(
      brand: 'UBS',
      weight: 1.0,
      price: 1650000,
      purchaseDate: '15 Jan 2025',
    ),
    Collection(
      brand: 'UBS',
      weight: 5.0,
      price: 7950000,
      purchaseDate: '10 Feb 2025',
    ),
    Collection(
      brand: 'UBS',
      weight: 10.0,
      price: 15800000,
      purchaseDate: '05 Mar 2025',
    ),

    // Antam - popular in Indonesia
    Collection(
      brand: 'Antam',
      weight: 1.0,
      price: 1680000,
      purchaseDate: '20 Jan 2025',
    ),
    Collection(
      brand: 'Antam',
      weight: 2.0,
      price: 3320000,
      purchaseDate: '15 Feb 2025',
    ),
    Collection(
      brand: 'Antam',
      weight: 5.0,
      price: 8100000,
      purchaseDate: '01 Mar 2025',
    ),

    // Premium Antam (certificate)
    Collection(
      brand: 'Antam',
      weight: 10.0,
      price: 16150000,
      purchaseDate: '25 Feb 2025',
    ),
  ];

  for (var collection in testCollections) {
    box.add(collection);
  }

  // Mark as seeded
  await prefs.setBool('_hasSeededCollection', true);
  debugPrint('✅ Seeded ${box.length} collections');
}
