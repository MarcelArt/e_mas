import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/utils/currency.dart';
import 'package:flutter/material.dart';

class SummaryCardWidget extends StatelessWidget {
  final double total;
  final int totalValue;
  final int currentValue;
  final double profitPercentage;
  final int itemCount;

  const SummaryCardWidget({
    super.key,
    this.total = 0,
    this.totalValue = 0,
    this.currentValue = 0,
    this.profitPercentage = 0,
    this.itemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final profit = currentValue - totalValue;
    final isProfit = profit >= 0;

    return Container(
      decoration: AppDecorations.cardDecoration().copyWith(
        borderRadius: BorderRadius.circular(AppBorderRadius.xlarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardBackground.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "E-Mas",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 28,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Gold Portfolio',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white54,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (isProfit ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.2),
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
                        isProfit ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: isProfit ? AppColors.success : AppColors.error,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${isProfit ? '+' : ''}${profitPercentage.toStringAsFixed(2)}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isProfit ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppBorderRadius.large),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Value',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    formatRupiah(currentValue),
                    style: AppTextStyles.priceLarge,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _buildStatItem(
                        'Invested',
                        formatRupiah(totalValue),
                        AppColors.info,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      _buildStatItem(
                        '${isProfit ? 'Profit' : 'Loss'}',
                        '${isProfit ? '+' : ''}${formatRupiah(profit.abs())}',
                        isProfit ? AppColors.success : AppColors.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Weight',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          Text(
                            '$total gram',
                            style: AppTextStyles.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.collections_bookmark_outlined,
                        color: Colors.white60,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Items',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          Text(
                            itemCount.toString(),
                            style: AppTextStyles.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white54,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.priceSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
