import 'package:e_mas/models/gold_price.model.dart';
import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class PriceTableView extends StatelessWidget {
  final String brand;
  final GoldPrice goldPrice;

  const PriceTableView({
    super.key,
    required this.brand,
    required this.goldPrice,
  });

  @override
  Widget build(BuildContext context) {
    // Get prices for the selected brand
    final prices = _getBrandPrices();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                brand.toLowerCase() == 'ubs' ? Icons.monetization_on : Icons.diamond,
                color: AppColors.gold,
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Text(
              '$brand Price List',
              style: AppTextStyles.headingSmall,
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: prices.length,
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final weight = prices[index];
          final buyPrice = _getBuyPrice(weight);
          final buybackPrice = _getBuybackPrice(weight);

          return _buildPriceRow(weight, buyPrice, buybackPrice);
        },
      ),
    );
  }

  Widget _buildPriceRow(String weight, int buyPrice, int buybackPrice) {
    final profit = buybackPrice - buyPrice;
    final profitPercentage = buyPrice > 0 ? (profit / buyPrice) * 100 : 0.0;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.cardDecoration().copyWith(
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$weight gram',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    fontSize: 13,
                  ),
                ),
              ),
              Spacer(),
              _buildPriceChip('Spread', '${profitPercentage.abs().toStringAsFixed(2)}%', Colors.white54),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildPriceColumn('Buy', buyPrice, AppColors.info),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildPriceColumn('Buyback', buybackPrice, AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceColumn(String label, int price, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppBorderRadius.small),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 4),
          Text(
            formatRupiah(price),
            style: AppTextStyles.priceMedium.copyWith(
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontSize: 11,
        ),
      ),
    );
  }

  List<String> _getBrandPrices() {
    // Get all unique weights for the brand, sorted
    final brandKey = brand.toLowerCase();
    final Map<String, int>? buyPrices =
        brandKey == 'ubs' ? goldPrice.buy.ubs : goldPrice.buy.antam;

    if (buyPrices == null) return [];

    // Sort weights: numeric sort (0.1, 0.25, 0.5, 1, 2, 3, etc.)
    final weights = buyPrices.keys.toList();
    weights.sort((a, b) {
      final aDouble = double.tryParse(a) ?? 0;
      final bDouble = double.tryParse(b) ?? 0;
      return aDouble.compareTo(bDouble);
    });

    return weights;
  }

  int _getBuyPrice(String weight) {
    final brandKey = brand.toLowerCase();
    final Map<String, int> buyPrices =
        brandKey == 'ubs' ? goldPrice.buy.ubs : goldPrice.buy.antam;
    return buyPrices[weight] ?? 0;
  }

  int _getBuybackPrice(String weight) {
    final brandKey = brand.toLowerCase();
    final Map<String, int> buybackPrices =
        brandKey == 'ubs' ? goldPrice.buyBack.ubs : goldPrice.buyBack.antam;
    return buybackPrices[weight] ?? 0;
  }
}
