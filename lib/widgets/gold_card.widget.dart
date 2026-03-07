import 'package:e_mas/repos/collection.repo.dart';
import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class GoldCardWidget extends StatelessWidget {
  final double weight;
  final String purchaseDate;
  final int price;
  final String brand;
  final int index;
  final int buyBackPrice;
  final bool isPrivacyMode;

  const GoldCardWidget({
    super.key,
    this.weight = 0,
    this.purchaseDate = '',
    this.price = 0,
    this.brand = '',
    this.index = 0,
    this.buyBackPrice = 0,
    this.isPrivacyMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final profit = buyBackPrice - price;
    final profitPercentage = price > 0 ? (profit / price) * 100 : 0.0;
    final isProfit = profit >= 0;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: AppDecorations.cardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        onTap: () {
          // Could add detail view here
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: AppDecorations.goldGradientDecoration(radius: 12),
                    child: Icon(
                      Icons.monetization_on,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brand.toUpperCase(),
                          style: AppTextStyles.labelSmall.copyWith(
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '$weight gram',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (!isPrivacyMode)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            (isProfit ? AppColors.success : AppColors.error)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isProfit ? AppColors.success : AppColors.error,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isProfit
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 14,
                            color: isProfit ? AppColors.success : AppColors.error,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            '${isProfit ? '+' : ''}${profitPercentage.toStringAsFixed(1)}%',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isProfit ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isPrivacyMode)
                    Icon(
                      Icons.lock,
                      size: 16,
                      color: AppColors.gold,
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceInfo(
                      'Buy Price',
                      isPrivacyMode ? '••••••••' : formatRupiah(price),
                      Icons.shopping_cart_outlined,
                      AppColors.info,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildPriceInfo(
                      'Buyback',
                      isPrivacyMode ? '••••••••' : formatRupiah(buyBackPrice),
                      Icons.currency_exchange,
                      AppColors.success,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildPriceInfo(
                      '${isProfit ? 'Profit' : 'Loss'}',
                      isPrivacyMode
                          ? '••••••••'
                          : '${isProfit ? '+' : ''}${formatRupiah(profit.abs())}',
                      isProfit ? Icons.trending_up : Icons.trending_down,
                      isProfit ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Divider(color: AppColors.border),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Purchased: $purchaseDate',
                    style: AppTextStyles.bodySmall,
                  ),
                  Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.cardBackground,
                            title: Text(
                              'Remove Gold',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                            content: Text(
                              'Are you sure you want to remove this $brand ${weight}g gold from your collection?',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: AppButtonStyles.dangerButton,
                                child: Text('Remove'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await deleteCollection(index);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.error,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: AppColors.error,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              'Remove',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildPriceInfo(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.priceSmall.copyWith(
              color: color,
              fontFamily: value.contains('•') ? 'Courier' : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
