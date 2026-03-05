import 'package:e_mas/api/gold_price.api.dart';
import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/models/gold_price.model.dart';
import 'package:e_mas/repos/collection.repo.dart';
import 'package:e_mas/widgets/my_collection_card.widget.dart';
import 'package:e_mas/widgets/summary_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late GoldPrice latestGoldPrice;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLatestGoldPrice();
  }

  Future<void> _fetchLatestGoldPrice() async {
    try {
      final response = await getLatestGoldPrice();
      if (mounted) {
        setState(() {
          latestGoldPrice = response.items!;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching gold price: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionsBox = Hive.box<Collection>('collections');
    return Scaffold(
      // appBar: AppBar(title: const Text('E-Mas')),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
        child: !isLoading ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder(
              valueListenable: collectionsBox.listenable(),
              builder: (context, value, child) {
                final total = getTotalWeight(collectionsBox: value);
                final totalValue = getTotalValue(collectionsBox: value);
                final currentValue = getCurrentValue(
                  collectionsBox: value,
                  goldPrices: latestGoldPrice.buyBack,
                );
                final profit = currentValue - totalValue;
                final double profitPercentage = totalValue == 0 ? 0 : (profit / totalValue) * 100;
                return SummaryCardWidget(
                  total: total,
                  totalValue: totalValue,
                  currentValue: currentValue,
                  profitPercentage: profitPercentage,
                );
              },
            ),
            MyCollectionCardWidget(latestGoldPrice: latestGoldPrice),
          ],
        ) : null,
      ),
    );
  }
}
