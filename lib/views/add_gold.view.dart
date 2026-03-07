import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/repos/collection.repo.dart';
import 'package:e_mas/utils/app_theme.dart';
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
  DateTime? purchaseDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _createCollection() async {
    final selectedDate = purchaseDate ?? DateTime.now();
    await createCollection(
      Collection(
        brand: brand,
        weight: weight,
        price: price,
        purchaseDate: DateFormat('dd MMM yyyy').format(selectedDate),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Gold',
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.sm),
              Text(
                'Add to Collection',
                style: AppTextStyles.headingLarge,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Enter the details of your gold purchase',
                style: AppTextStyles.bodyLarge,
              ),
              SizedBox(height: AppSpacing.lg),
              _buildBrandDropdown(),
              SizedBox(height: AppSpacing.md),
              _buildDatePicker(),
              SizedBox(height: AppSpacing.md),
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
              SizedBox(height: AppSpacing.md),
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
              SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _createCollection();
                    }
                  },
                  style: AppButtonStyles.goldButton,
                  child: Text(
                    'Add Gold',
                    style: AppTextStyles.label,
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
        Text('Brand', style: AppTextStyles.label),
        SizedBox(height: AppSpacing.sm),
        Container(
          decoration: AppDecorations.cardDecorationPlain(),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: brandOption,
              dropdownColor: AppColors.cardBackground,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.gold),
              style: AppTextStyles.label,
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
          SizedBox(height: AppSpacing.md),
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
        Text(label, style: AppTextStyles.label),
        SizedBox(height: AppSpacing.sm),
        TextFormField(
          decoration: AppDecorations.inputDecoration(hintText: hint),
          style: AppTextStyles.label,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Purchase Date', style: AppTextStyles.label),
        SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: purchaseDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                purchaseDate = picked;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: AppDecorations.cardDecorationPlain(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  purchaseDate == null
                      ? 'Select purchase date'
                      : DateFormat('dd MMM yyyy').format(purchaseDate!),
                  style: AppTextStyles.label.copyWith(
                    color: purchaseDate == null
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                Icon(Icons.calendar_today, color: AppColors.gold),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
