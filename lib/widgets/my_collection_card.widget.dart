import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/models/gold_price.model.dart';
import 'package:e_mas/widgets/gold_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyCollectionCardWidget extends StatefulWidget {
  final GoldPrice latestGoldPrice;
  
  const MyCollectionCardWidget({super.key, required this.latestGoldPrice});

  @override
  State<MyCollectionCardWidget> createState() => _MyCollectionCardWidgetState();
}

class _MyCollectionCardWidgetState extends State<MyCollectionCardWidget> {
  late Box<Collection> collectionBox;
  // GoldPrice? latestGoldPrice;

  @override
  void initState() {
    super.initState();
    // Initialize box reference once, not on every build
    collectionBox = Hive.box<Collection>('collections');
  }

  @override
  Widget build(BuildContext context) {
    final latestGoldPrice = widget.latestGoldPrice;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Collections',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-gold');
                  },
                  child: const Text('Add Gold'),
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: collectionBox.listenable(),
              builder: (context, value, _) {

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final collection = value.getAt(index);
                    var buyBackPrice = 0;
                    switch (collection?.brand.toLowerCase()) {
                      case 'ubs':
                        buyBackPrice = latestGoldPrice.buyBack.ubs[collection!.weight.toString()] ?? 0;
                        break;
                      case 'antam':
                        buyBackPrice = latestGoldPrice.buyBack.antam[collection!.weight.toString()] ?? 0;
                        break;
                      default:
                        buyBackPrice = collection?.price ?? 0; // Default or handle unknown brand
                    }
                                      return GoldCardWidget(
                      brand: collection?.brand ?? 'Unknown',
                      price: collection?.price ?? 0,
                      purchaseDate: collection?.purchaseDate ?? 'N/A',
                      weight: collection?.weight ?? 0,
                      index: index,
                      buyBackPrice: buyBackPrice,
                    );
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
