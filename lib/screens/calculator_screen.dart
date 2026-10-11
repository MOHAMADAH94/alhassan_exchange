import 'package:flutter/material.dart';
import '../models/currency_rate.dart';
import '../services/api_service.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late Future<List<CurrencyRate>> futureRates;
  final ApiService apiService = ApiService();
  List<CurrencyRate> rates = [];
  TextEditingController amountController = TextEditingController();
  String selectedCurrency = 'USD';
  Map<String, double> conversionResults = {};

  static const goldenColor = Color(0xFFFFD700);
  static const darkColor = Color(0xFF121212);
  static const cardColor = Color(0xFF1E1E1E);

  // العملات المطلوبة فقط
  final List<String> targetCurrencies = ['USD', 'TRY', 'SYR'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final rates = await apiService.fetchRates();
      setState(() {
        this.rates = rates;
      });
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[800]!, width: 1),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: selectedCurrency,
                            items: targetCurrencies
                                .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(
                                currency,
                                style: const TextStyle(
                                  fontFamily: 'ithra',
                                  color: Colors.white,
                                ),
                              ),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCurrency = value!;
                              });
                              calculateConversion();
                            },
                            decoration: InputDecoration(
                              labelText: 'العملة',
                              labelStyle: const TextStyle(
                                fontFamily: 'ithra',
                                color: goldenColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: goldenColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: goldenColor),
                              ),
                            ),
                            dropdownColor: darkColor,
                            style: const TextStyle(
                              fontFamily: 'ithra',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'المبلغ',
                              labelStyle: const TextStyle(
                                fontFamily: 'ithra',
                                color: goldenColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: goldenColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: goldenColor),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'ithra',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              calculateConversion();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[800]!, width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نتائج التحويل:',
                        style: TextStyle(
                          fontFamily: 'ithra',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: goldenColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (amountController.text.isNotEmpty && conversionResults.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: conversionResults.length,
                            itemBuilder: (context, index) {
                              String currency = conversionResults.keys.elementAt(index);
                              double amount = conversionResults[currency]!;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      currency,
                                      style: const TextStyle(
                                        fontFamily: 'ithra',
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      amount.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontFamily: 'ithra',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: goldenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      if (amountController.text.isEmpty || conversionResults.isEmpty)
                        const Expanded(
                          child: Center(
                            child: Text(
                              'أدخل المبلغ لرؤية نتائج التحويل',
                              style: TextStyle(
                                fontFamily: 'ithra',
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
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
    );
  }

  void calculateConversion() {
    if (amountController.text.isEmpty || rates.isEmpty) {
      setState(() {
        conversionResults.clear();
      });
      return;
    }

    double amount = double.tryParse(amountController.text) ?? 0;
    conversionResults.clear();

    // حساب التحويل للعملات الأخرى فقط (غير المختارة)
    for (var currency in targetCurrencies) {
      if (currency != selectedCurrency) {
        double? rate = findConversionRate(selectedCurrency, currency);
        if (rate != null) {
          conversionResults[currency] = amount * rate;
        }
      }
    }

    setState(() {});
  }

  double? findConversionRate(String from, String to) {
    // 1. البحث عن سعر التحويل المباشر
    for (var rate in rates) {
      if (rate.baseCurrency == from && rate.targetCurrency == to) {
        return rate.sellPrice;
      }
      if (rate.baseCurrency == to && rate.targetCurrency == from) {
        return 1 / rate.buyPrice;
      }
    }

    // 2. إذا كان التحويل بين SYR و TRY نستخدم USD كعملة وسيطة
    if ((from == 'SYR' && to == 'TRY') || (from == 'TRY' && to == 'SYR')) {
      double? SYRToUsd = findConversionRate('SYR', 'USD');
      double? usdToTry = findConversionRate('USD', 'TRY');
      if (SYRToUsd != null && usdToTry != null) {
        return from == 'SYR' ? SYRToUsd * usdToTry : 1 / (SYRToUsd * usdToTry);
      }
    }

    // 3. إذا كان التحويل بين SYR وعملة أخرى غير USD
    if (from == 'SYR' && to != 'USD') {
      double? SYRToUsd = findConversionRate('SYR', 'USD');
      double? usdToTarget = findConversionRate('USD', to);
      if (SYRToUsd != null && usdToTarget != null) {
        return SYRToUsd * usdToTarget;
      }
    }

    // 4. إذا كان التحويل من عملة أخرى إلى SYR
    if (to == 'SYR' && from != 'USD') {
      double? fromToUsd = findConversionRate(from, 'USD');
      double? usdToSYR = findConversionRate('USD', 'SYR');
      if (fromToUsd != null && usdToSYR != null) {
        return fromToUsd * usdToSYR;
      }
    }

    return null;
  }
}