import 'package:e_mas/api/gold_price.api.dart';
import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/models/gold_price.model.dart';
import 'package:e_mas/repos/collection.repo.dart';
import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/widgets/my_collection_card.widget.dart';
import 'package:e_mas/widgets/summary_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GoldPrice? latestGoldPrice;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLatestGoldPrice();
  }

  Future<void> _fetchLatestGoldPrice() async {
    try {
      final response = await getLatestGoldPrice();
      if (mounted) {
        setState(() {
          latestGoldPrice = response.items;
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load gold prices. Pull to retry.';
        });
        debugPrint('Error fetching gold price: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionsBox = Hive.box<Collection>('collections');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : errorMessage != null
                ? _buildErrorState()
                : RefreshIndicator(
                    onRefresh: _fetchLatestGoldPrice,
                    color: AppColors.gold,
                    backgroundColor: AppColors.cardBackground,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: AppSpacing.lg,
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                        bottom: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          _buildHeader(),
                          SizedBox(height: AppSpacing.md),
                          ValueListenableBuilder(
                            valueListenable: collectionsBox.listenable(),
                            builder: (context, value, child) {
                              final total = getTotalWeight(collectionsBox: value);
                              final totalValue = getTotalValue(collectionsBox: value);
                              final currentValue = getCurrentValue(
                                collectionsBox: value,
                                goldPrices: latestGoldPrice?.buyBack,
                              );
                              final profit = currentValue - totalValue;
                              final double profitPercentage =
                                  totalValue == 0 ? 0 : (profit / totalValue) * 100;

                              return SummaryCardWidget(
                                total: total,
                                totalValue: totalValue,
                                currentValue: currentValue,
                                profitPercentage: profitPercentage,
                                itemCount: value.length,
                              );
                            },
                          ),
                          SizedBox(height: AppSpacing.md),
                          if (latestGoldPrice != null)
                            MyCollectionCardWidget(latestGoldPrice: latestGoldPrice!),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: AppTextStyles.bodyLarge,
              ),
              SizedBox(height: 2),
              Text(
                'E-Mas Portfolio',
                style: AppTextStyles.headingLarge,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: AppDecorations.cardDecorationPlain(),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Live',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Loading gold prices...',
            style: AppTextStyles.label,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.errorBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Oops!',
              style: AppTextStyles.headingMedium,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              errorMessage ?? 'Failed to load gold prices',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _fetchLatestGoldPrice,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: AppButtonStyles.goldButton,
            ),
          ],
        ),
      ),
    );
  }
}
