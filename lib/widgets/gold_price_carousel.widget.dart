import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class GoldPriceCarouselWidget extends StatelessWidget {
  final List<BrandPrice> prices;

  const GoldPriceCarouselWidget({
    super.key,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.gold,
                  size: 16,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Today\'s Prices',
                style: AppTextStyles.labelSmall,
              ),
              Spacer(),
              Text(
                'per gram',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemCount: prices.length,
            itemBuilder: (context, index) {
              final price = prices[index];
              return _buildPriceCard(price);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard(BrandPrice price) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: AppSpacing.sm),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10),
      decoration: AppDecorations.cardDecoration().copyWith(
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              price.icon,
              color: AppColors.gold,
              size: 18,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  price.brand,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _buildPriceChip('Buy', price.buyPrice, AppColors.info),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: _buildPriceChip('Back', price.buybackPrice, AppColors.success),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChip(String label, int priceValue, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          formatRupiah(priceValue),
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Model for brand price data
class BrandPrice {
  final String brand;
  final IconData icon;
  final int buyPrice;
  final int buybackPrice;

  BrandPrice({
    required this.brand,
    required this.icon,
    required this.buyPrice,
    required this.buybackPrice,
  });
}

/// Dummy data for testing
List<BrandPrice> dummyGoldPrices = [
  BrandPrice(
    brand: 'UBS',
    icon: Icons.monetization_on,
    buyPrice: 1250000,
    buybackPrice: 1180000,
  ),
  BrandPrice(
    brand: 'Antam',
    icon: Icons.diamond,
    buyPrice: 1240000,
    buybackPrice: 1175000,
  ),
  BrandPrice(
    brand: 'Antam',
    icon: Icons.diamond,
    buyPrice: 625000,
    buybackPrice: 595000,
  ),
  BrandPrice(
    brand: 'UBS',
    icon: Icons.monetization_on,
    buyPrice: 630000,
    buybackPrice: 600000,
  ),
];
