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

  @override
  void initState() {
    super.initState();
    collectionBox = Hive.box<Collection>('collections');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD700).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.collections_bookmark_rounded,
                      color: Color(0xFFFFD700),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'My Collections',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/add-gold');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFD700),
                          Color(0xFFFFA500),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFD700).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Add Gold',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: collectionBox.listenable(),
          builder: (context, value, _) {
            if (value.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8),
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final collection = value.getAt(index);
                var buyBackPrice = 0;

                switch (collection?.brand.toLowerCase()) {
                  case 'ubs':
                    buyBackPrice = widget.latestGoldPrice.buyBack.ubs[
                            collection!.weight.toString()] ??
                        0;
                    break;
                  case 'antam':
                    buyBackPrice = widget.latestGoldPrice.buyBack.antam[
                            collection!.weight.toString()] ??
                        0;
                    break;
                  default:
                    buyBackPrice = collection?.price ?? 0;
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
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFF2D2D44),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFFFD700).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.monetization_on_outlined,
              size: 48,
              color: Color(0xFFFFD700),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'No Gold Collection Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start your investment journey by adding your first gold',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-gold');
            },
            icon: Icon(Icons.add, size: 18),
            label: Text(
              'Add First Gold',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFF0F0F1A),
              backgroundColor: Color(0xFFFFD700),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
