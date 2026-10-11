import 'package:flutter/material.dart';
import '../models/currency_rate.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CurrencyRate>> futureRates;
  final ApiService apiService = ApiService();
  static const goldenColor = Color(0xFFFFD700);
  static const darkColor = Color(0xFF121212);
  static const cardColor = Color(0xFF1E1E1E);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      futureRates = apiService.fetchRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CurrencyRate>>(
        future: futureRates,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildHomePage(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const Text(
                    'حدث خطأ في تحميل البيانات',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldenColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: _loadData,
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: goldenColor,
              strokeWidth: 3,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomePage(List<CurrencyRate> rates) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: goldenColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: rates.length,
        itemBuilder: (context, index) => _buildRateCard(rates[index]),
      ),
    );
  }

  Widget _buildRateCard(CurrencyRate rate) {
    // نحسب الاتجاه العام للتغير
    final currentAvg = (rate.buyPrice + rate.sellPrice) / 2;
    final previousAvg = ((rate.previousBuyPrice ?? rate.buyPrice) +
        (rate.previousSellPrice ?? rate.sellPrice)) /
        2;

    IconData trendIcon = Icons.remove;
    Color trendColor = Colors.grey;

    if (currentAvg > previousAvg) {
      trendIcon = Icons.arrow_circle_up_rounded;
      trendColor = Colors.green;
    } else if (currentAvg < previousAvg) {
      trendIcon = Icons.arrow_circle_down_rounded;
      trendColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Row of currency names and golden arrow
                Row(
                  children: [
                    Expanded(
                      child: _buildCurrencyCell(
                        rate.baseCurrency,
                        TextAlign.center,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.compare_arrows,
                          color: goldenColor, size: 24),
                    ),
                    Expanded(
                      child: _buildCurrencyCell(
                        rate.targetCurrency,
                        TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[800]),

                // 🠕 Row of buy/sell and main trend arrow
                Row(
                  children: [
                    Expanded(
                      child: _buildPriceBox(
                        title: 'الشراء',
                        price: rate.buyPrice,
                        color: Colors.redAccent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(trendIcon, color: trendColor, size: 28),
                    ),
                    Expanded(
                      child: _buildPriceBox(
                        title: 'البيع',
                        price: rate.sellPrice,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyCell(
      String currency,
      TextAlign align, {
        Color textColor = goldenColor,
        double fontSize = 18,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: darkColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: goldenColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        currency,
        textAlign: align,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPriceBox({
    required String title,
    required double price,
    required Color color,
    double titleFontSize = 18,
    double priceFontSize = 20,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: darkColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Center(
            child: Text(
              price.toStringAsFixed(2),
              style: TextStyle(
                fontSize: priceFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
