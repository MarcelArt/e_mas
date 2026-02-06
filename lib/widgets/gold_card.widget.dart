import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class GoldCardWidget extends StatelessWidget {
  final double weight;
  final String purchaseDate;
  final int price;
  final String brand;

  const GoldCardWidget({
    super.key,
    this.weight = 0,
    this.purchaseDate = '',
    this.price = 0,
    this.brand = '',
  });

  @override
  Widget build(BuildContext context) {
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
              Text(
                formatRupiah(price),
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w400,
                ),
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
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Detail',
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
