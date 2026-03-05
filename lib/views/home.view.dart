import 'package:e_mas/api/gold_price.api.dart';
import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/models/gold_price.model.dart';
import 'package:e_mas/repos/collection.repo.dart';
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
      backgroundColor: Color(0xFF0F0F1A),
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : errorMessage != null
                ? _buildErrorState()
                : RefreshIndicator(
                    onRefresh: _fetchLatestGoldPrice,
                    color: Color(0xFFFFD700),
                    backgroundColor: Color(0xFF1A1A2E),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 16,
                        right: 16,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          _buildHeader(),
                          SizedBox(height: 16),
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
                              );
                            },
                          ),
                          SizedBox(height: 16),
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
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'E-Mas Portfolio',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF2D2D44),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Loading gold prices...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF3F1A1A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFDC2626),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage ?? 'Failed to load gold prices',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchLatestGoldPrice,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFFFD700),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
