class CurrencyRate {
  final String baseCurrency;
  final String targetCurrency;
  final double buyPrice;
  final double sellPrice;
  final double? previousBuyPrice;
  final double? previousSellPrice;
  final DateTime updatedAt;

  CurrencyRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.buyPrice,
    required this.sellPrice,
    this.previousBuyPrice,
    this.previousSellPrice,
    required this.updatedAt,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      baseCurrency: json['base_currency'],
      targetCurrency: json['target_currency'],
      buyPrice: double.parse(json['buy_price']),
      sellPrice: double.parse(json['sell_price']),
      previousBuyPrice: json['previous_buy_price'] != null
          ? double.tryParse(json['previous_buy_price'].toString())
          : null,
      previousSellPrice: json['previous_sell_price'] != null
          ? double.tryParse(json['previous_sell_price'].toString())
          : null,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
