import 'package:e_mas/models/gold_price.model.dart';
import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class PriceTableView extends StatefulWidget {
  final String brand;
  final GoldPrice goldPrice;

  const PriceTableView({
    super.key,
    required this.brand,
    required this.goldPrice,
  });

  @override
  State<PriceTableView> createState() => _PriceTableViewState();
}

class _PriceTableViewState extends State<PriceTableView> {
  // Cache the sorted prices list to avoid recomputing on every build
  late final List<String> _prices;
  // Cache price maps for faster lookup
  late final Map<String, int> _buyPrices;
  late final Map<String, int> _buybackPrices;

  @override
  void initState() {
    super.initState();
    _prices = _getBrandPrices();
    _buyPrices = _getPriceMap(true);
    _buybackPrices = _getPriceMap(false);
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
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.brand.toLowerCase() == 'ubs'
                    ? Icons.monetization_on
                    : Icons.diamond,
                color: AppColors.gold,
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Text(
              '${widget.brand} Price List',
              style: AppTextStyles.headingSmall,
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: _prices.length,
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final weight = _prices[index];
          final buyPrice = _buyPrices[weight] ?? 0;
          final buybackPrice = _buybackPrices[weight] ?? 0;

          return _PriceRow(
            weight: weight,
            buyPrice: buyPrice,
            buybackPrice: buybackPrice,
          );
        },
      ),
    );
  }

  List<String> _getBrandPrices() {
    final brandKey = widget.brand.toLowerCase();
    final buyPrices = brandKey == 'ubs'
        ? widget.goldPrice.buy.ubs
        : widget.goldPrice.buy.antam;

    final weights = buyPrices.keys.toList();
    weights.sort((a, b) {
      final aDouble = double.tryParse(a) ?? 0;
      final bDouble = double.tryParse(b) ?? 0;
      return aDouble.compareTo(bDouble);
    });

    return weights;
  }

  Map<String, int> _getPriceMap(bool isBuy) {
    final brandKey = widget.brand.toLowerCase();
    if (isBuy) {
      return brandKey == 'ubs'
          ? widget.goldPrice.buy.ubs
          : widget.goldPrice.buy.antam;
    } else {
      return brandKey == 'ubs'
          ? widget.goldPrice.buyBack.ubs
          : widget.goldPrice.buyBack.antam;
    }
  }
}

/// Extracted as separate widget for better performance
class _PriceRow extends StatelessWidget {
  final String weight;
  final int buyPrice;
  final int buybackPrice;

  const _PriceRow({
    required this.weight,
    required this.buyPrice,
    required this.buybackPrice,
  });

  @override
  Widget build(BuildContext context) {
    final profit = buybackPrice - buyPrice;
    final profitPercentage = buyPrice > 0 ? (profit / buyPrice) * 100 : 0.0;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.cardBackgroundAlt,
          ],
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        border: Border.all(color: AppColors.border, width: 1),
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
              _PriceChip(
                label: 'Spread',
                value: '${profitPercentage.abs().toStringAsFixed(2)}%',
                color: Colors.white54,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Buy',
                  price: buyPrice,
                  color: AppColors.info,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PriceColumn(
                  label: 'Buyback',
                  price: buybackPrice,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  final String label;
  final int price;
  final Color color;

  const _PriceColumn({
    required this.label,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _PriceChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _PriceChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
