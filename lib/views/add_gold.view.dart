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
  String brandOption = list.first;
  String brand = list.first;
  double weight = 0;
  int price = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _createCollection() async {
    final now = DateTime.now();
    await createCollection(
      Collection(
        brand: brand,
        weight: weight,
        price: price,
        purchaseDate: DateFormat('dd MMM yyyy | hh:mm a').format(now),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Gold',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Add to Collection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter the details of your gold purchase',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              _buildBrandDropdown(),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Weight (grams)',
                hint: 'Enter weight in grams',
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
              SizedBox(height: 16),
              _buildTextField(
                label: 'Buy price',
                hint: 'Enter buy price in rupiah',
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
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _createCollection();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD700),
                    foregroundColor: Color(0xFF0F0F1A),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add Gold',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF2D2D44),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: brandOption,
              dropdownColor: Color(0xFF1A1A2E),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFD700)),
              style: TextStyle(color: Colors.white, fontSize: 16),
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  brandOption = value!;
                  brand = value;
                });
              },
            ),
          ),
        ),
        if (brandOption == 'Other') ...[
          SizedBox(height: 16),
          _buildTextField(
            label: 'Other brand name',
            hint: 'Enter brand name',
            keyboardType: TextInputType.text,
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
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color(0xFF6B7280)),
            filled: true,
            fillColor: Color(0xFF1A1A2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2D2D44)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2D2D44)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFFFD700)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFDC2626)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFDC2626)),
            ),
            errorStyle: TextStyle(color: Color(0xFFDC2626)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16),
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
