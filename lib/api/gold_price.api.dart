import 'package:dio/dio.dart';
import 'package:e_mas/models/api_response.model.dart';
import 'package:e_mas/models/gold_price.model.dart';

final goldPriceApi = Dio(BaseOptions(
  baseUrl: 'https://aimas.bangmarcel.art/api',
));

Future<ApiResponse<GoldPrice>> getLatestGoldPrice() async {
  final res = await goldPriceApi.get('/gold-price/latest');
  final json = res.data as Map<String, dynamic>;
  return ApiResponse<GoldPrice>.fromJson(
    json,
    (itemsJson) => GoldPrice.fromJson(itemsJson as Map<String, dynamic>),
  );
}