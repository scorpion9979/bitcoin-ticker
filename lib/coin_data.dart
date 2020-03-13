import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final String coin;
  final String fiat;
  CoinData({this.coin, this.fiat});

  dynamic getCoinData() async {
    final data = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/${this.coin}/${this.fiat}?apikey=${DotEnv().env['API_KEY']}');
    return jsonDecode(data.body);
  }
}
