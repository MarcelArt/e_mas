import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/repos/collection.repo.dart';
import 'package:e_mas/widgets/my_collection_card.widget.dart';
import 'package:e_mas/widgets/summary_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionsBox = Hive.box<Collection>('collections');
    return Scaffold(
      // appBar: AppBar(title: const Text('E-Mas')),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder(
              valueListenable: collectionsBox.listenable(),
              builder: (context, value, child) {
                final total = getTotalWeight(collectionsBox: value);
                return SummaryCardWidget(total: total);
              }
            ),
            MyCollectionCardWidget(),
          ],
        ),
      ),
    );
  }
}
