import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/widgets/gold_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyCollectionCardWidget extends StatefulWidget {
  const MyCollectionCardWidget({super.key});

  @override
  State<MyCollectionCardWidget> createState() => _MyCollectionCardWidgetState();
}

class _MyCollectionCardWidgetState extends State<MyCollectionCardWidget> {
  late Box<Collection> collectionBox;

  @override
  void initState() {
    super.initState();
    // Initialize box reference once, not on every build
    collectionBox = Hive.box<Collection>('collections');
  }

  @override
  Widget build(BuildContext context) {
    // final collectionBox = Hive.box<Collection>('collections');

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
            // GoldCardWidget(
            //   brand: "UBS",
            //   price: 927000,
            //   purchaseDate: '01 Feb 2026 | 01:46 PM',
            //   weight: 0.25,
            // ),
            ValueListenableBuilder(
              valueListenable: collectionBox.listenable(),
              builder: (context, value, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final collection = value.getAt(index);
                    return GoldCardWidget(
                      brand: collection?.brand ?? 'Unknown',
                      price: collection?.price ?? 0,
                      purchaseDate: collection?.purchaseDate ?? 'N/A',
                      weight: collection?.weight ?? 0,
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
