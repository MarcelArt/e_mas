import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/models/gold_price.model.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> createCollection(Collection item) async {
  final collectionsBox = Hive.box<Collection>('collections');
  await collectionsBox.add(item);
}

Future<List<Collection>> getAllCollections() async {
  final collectionsBox = Hive.box<Collection>('collections');
  return collectionsBox.values.toList();
}

Future deleteCollection(int index) async {
  final collectionsBox = Hive.box<Collection>('collections');
  await collectionsBox.deleteAt(index);
}

double getTotalWeight({Box<Collection>? collectionsBox}) {
  collectionsBox ??= Hive.box<Collection>('collections');
  double totalWeight = 0;

  for (var item in collectionsBox.values) {
    totalWeight += item.weight;
  }
  return totalWeight;
}

int getTotalValue({Box<Collection>? collectionsBox}) {
  collectionsBox ??= Hive.box<Collection>('collections');
  int totalValue = 0;

  for (var item in collectionsBox.values) {
    totalValue += item.price;
  }
  return totalValue;
}

int getCurrentValue({Box<Collection>? collectionsBox, GoldPriceList? goldPrices}) {
  collectionsBox ??= Hive.box<Collection>('collections');
  int totalValue = 0;

  for (var item in collectionsBox.values) {
    switch (item.brand) {
      case 'UBS':
        totalValue += goldPrices?.ubs[item.weight.toString()] ?? item.price;
        break;
      case 'ANTAM':
        totalValue += goldPrices?.antam[item.weight.toString()] ?? item.price;
        break;
      default:
        totalValue += item.price;
    }
  }
  return totalValue;
}