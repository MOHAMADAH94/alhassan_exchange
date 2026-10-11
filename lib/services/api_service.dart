import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_rate.dart';
import '../models/branch.dart';

class ApiService {
  static const String baseUrl = 'http://alhassanexchange.com/api/';

  Future<List<CurrencyRate>> fetchRates() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}rates/'));
      if (response.statusCode == 200) {
        final utf8decoder = Utf8Decoder();
        List jsonResponse = json.decode(utf8decoder.convert(response.bodyBytes));
        return jsonResponse.map((rate) => CurrencyRate.fromJson(rate)).toList();
      } else {
        throw Exception('Failed to load rates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<List<Branch>> fetchBranches() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}branches/'));
      if (response.statusCode == 200) {
        final utf8decoder = Utf8Decoder();
        List jsonResponse = json.decode(utf8decoder.convert(response.bodyBytes));
        return jsonResponse.map((branch) => Branch.fromJson(branch)).toList();
      } else {
        throw Exception('Failed to load branches. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}