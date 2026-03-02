import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class SummaryCardWidget extends StatelessWidget {
  final double total;
  final int totalValue;
  final int currentValue;
  final double profitPercentage;

  const SummaryCardWidget({super.key, this.total = 0, this.totalValue = 0, this.currentValue = 0, this.profitPercentage = 0});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              "E-Mas",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatRupiah(currentValue), style: TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  '${profitPercentage.toStringAsFixed(2)}%', 
                  style: TextStyle(
                    color: profitPercentage >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w700,
                  )
                ),
              ],
            ),
            Text(
              formatRupiah(totalValue),
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(0, 0, 0, .5),
              ),
            ),
            Row(
              spacing: 4,
              children: [
                Icon(Icons.storage_outlined),
                Text('$total gr', style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            Text(
              'Current Gold Collection',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(0, 0, 0, .5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
