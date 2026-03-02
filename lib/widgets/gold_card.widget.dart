import 'package:e_mas/repos/collection.repo.dart';
import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class GoldCardWidget extends StatelessWidget {
  final double weight;
  final String purchaseDate;
  final int price;
  final String brand;
  final int index;
  final int buyBackPrice;

  const GoldCardWidget({
    super.key,
    this.weight = 0,
    this.purchaseDate = '',
    this.price = 0,
    this.brand = '',
    this.index = 0,
    this.buyBackPrice = 0,
  });

  @override
  Widget build(BuildContext context) {
    final profit = buyBackPrice - price;
    final profitPercentage = (profit / price) * 100;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "$brand ($weight gr)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Buy        : ${formatRupiah(price)}',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${profitPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: profit >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Buyback: ${formatRupiah(buyBackPrice)}'),
                  Text(
                    formatRupiah(profit),
                    style: TextStyle(
                      color: profit >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Purchase Date',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color.fromRGBO(0, 0, 0, .5),
                        ),
                      ),
                      Text(
                        purchaseDate,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      await deleteCollection(index);
                    },
                    child: Text(
                      'Remove',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
