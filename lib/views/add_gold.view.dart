import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/repos/collection.repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<String> list = <String>['Antam', 'UBS', 'Other'];

class AddGoldView extends StatefulWidget {
  const AddGoldView({super.key});

  @override
  State<AddGoldView> createState() => _AddGoldViewState();
}

class _AddGoldViewState extends State<AddGoldView> {
  String brand = list.first;
  double weight = 0;
  int price = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _createCollection() async {
    final now = DateTime.now();
    await createCollection(Collection(
      brand: brand,
      weight: weight,
      price: price,
      purchaseDate: DateFormat('dd MMM yyyy | hh:mm a').format(now),
    ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Gold')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                initialValue: brand,
                decoration: InputDecoration(labelText: 'Brand'),
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    brand = value!;
                  });
                },
              ),
              brand == 'Other'
                  ? TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Other brand name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the brand name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          brand = value;
                        });
                      },
                    )
                  : SizedBox(),
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (grams)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight in grams';
                  }
                  var dValue = double.tryParse(value);
                  if (dValue == null || dValue <= 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    weight = double.tryParse(value) ?? 0;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Buy price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter buy price in rupiah';
                  }
                  var dValue = double.tryParse(value);
                  if (dValue == null || dValue <= 0) {
                    return 'Please enter a valid buy price';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    price = int.tryParse(value) ?? 0;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _createCollection();
                  }
                },
                child: Text('Add Gold'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
