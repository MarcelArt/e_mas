class GoldPrice {
  final int ID;
  final GoldPriceList buy;
  final GoldPriceList buyBack;

  GoldPrice({
    required this.ID,
    required this.buy,
    required this.buyBack,
  });

  factory GoldPrice.fromJson(Map<String, dynamic> json) {
    return GoldPrice(
      ID: json['ID'],
      buy: GoldPriceList.fromJson(json['buy']),
      buyBack: GoldPriceList.fromJson(json['buyBack']),
    );
  }
}

class GoldPriceList {
  final Map<String, int> ubs;
  final Map<String, int> antam;

  GoldPriceList({
    required this.ubs,
    required this.antam,
  });

  factory GoldPriceList.fromJson(Map<String, dynamic> json) {
    return GoldPriceList(
      ubs: Map<String, int>.from(json['ubs']),
      antam: Map<String, int>.from(json['antam']),
    );
  }
}