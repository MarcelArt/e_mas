import 'package:e_mas/models/collection.model.dart';
import 'package:e_mas/models/gold_price.model.dart';
import 'package:e_mas/utils/app_theme.dart';
import 'package:e_mas/widgets/gold_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyCollectionCardWidget extends StatefulWidget {
  final GoldPrice latestGoldPrice;

  const MyCollectionCardWidget({super.key, required this.latestGoldPrice});

  @override
  State<MyCollectionCardWidget> createState() => _MyCollectionCardWidgetState();
}

class _MyCollectionCardWidgetState extends State<MyCollectionCardWidget> {
  late Box<Collection> collectionBox;

  @override
  void initState() {
    super.initState();
    collectionBox = Hive.box<Collection>('collections');
  }

  /// Format weight as string to match API map keys
  /// e.g., 5.0 -> "5", 0.5 -> "0.5", 10.0 -> "10"
  String _formatWeightKey(double weight) {
    if (weight == weight.truncateToDouble()) {
      return weight.toInt().toString();
    }
    return weight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.collections_bookmark_rounded,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'My Collections',
                    style: AppTextStyles.headingSmall,
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/add-gold');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: AppDecorations.goldGradientDecoration(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: AppColors.textPrimary, size: 18),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'Add Gold',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        ValueListenableBuilder(
          valueListenable: collectionBox.listenable(),
          builder: (context, value, _) {
            if (value.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8),
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final collection = value.getAt(index);
                var buyBackPrice = 0;

                switch (collection?.brand.toLowerCase()) {
                  case 'ubs':
                    buyBackPrice = widget.latestGoldPrice.buyBack
                            .ubs[_formatWeightKey(collection!.weight)] ??
                        0;
                    break;
                  case 'antam':
                    buyBackPrice = widget.latestGoldPrice.buyBack.antam[
                            _formatWeightKey(collection!.weight)] ??
                        0;
                    break;
                  default:
                    buyBackPrice = collection?.price ?? 0;
                }

                return GoldCardWidget(
                  brand: collection?.brand ?? 'Unknown',
                  price: collection?.price ?? 0,
                  purchaseDate: collection?.purchaseDate ?? 'N/A',
                  weight: collection?.weight ?? 0,
                  index: index,
                  buyBackPrice: buyBackPrice,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: AppDecorations.cardDecorationPlain().copyWith(
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.monetization_on_outlined,
              size: 48,
              color: AppColors.gold,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'No Gold Collection Yet',
            style: AppTextStyles.headingMedium,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Start your investment journey by adding your first gold',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
          ),
          SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-gold');
            },
            icon: Icon(Icons.add, size: 18),
            label: Text(
              'Add First Gold',
              style: AppTextStyles.label,
            ),
            style: AppButtonStyles.goldButtonSmall,
          ),
        ],
      ),
    );
  }
}
