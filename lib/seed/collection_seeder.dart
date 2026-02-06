import 'package:e_mas/models/collection.model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void seedCollection() {
  final box = Hive.box<Collection>('collections');

  if (box.isNotEmpty) return;
  
  final initialCollections = Collection(
    brand: 'UBS',
    weight: 0.5,
    price: 1854000,
    purchaseDate: '15 Mar 2026 | 10:30 AM',
  );

  box.add(initialCollections);
}
