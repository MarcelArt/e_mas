import 'package:flutter/material.dart';

class SummaryCardWidget extends StatelessWidget {
  final double total;

  const SummaryCardWidget({super.key, this.total = 0});

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
