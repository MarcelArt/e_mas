import 'package:hive/hive.dart';

part 'collection.model.g.dart';

@HiveType(typeId: 0)
class Collection {
  @HiveField(0)
  final String brand;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final String purchaseDate;

  Collection({
    required this.brand,
    required this.weight,
    required this.price,
    required this.purchaseDate,
  });
}