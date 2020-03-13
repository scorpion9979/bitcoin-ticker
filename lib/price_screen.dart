import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedFiat = currenciesList[0];
  Map<String, String> tickers = Map.fromIterable(cryptoList,
      key: (crypto) => crypto, value: (crypto) => '??');

  DropdownButton<String> getAndroidDropdown() {
    return DropdownButton<String>(
      value: selectedFiat,
      items: currenciesList
          .map((currency) => DropdownMenuItem(
                child: Text(currency),
                value: currency,
              ))
          .toList(),
      onChanged: (currency) => setState(() {
        selectedFiat = currency;
        _updateTickers();
      }),
    );
  }

  CupertinoPicker getiOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedItemIndex) => setState(() {
        selectedFiat = currenciesList[selectedItemIndex];
        _updateTickers();
      }),
      children: currenciesList
          .map((currency) => Text(
                currency,
                style: TextStyle(color: Colors.white),
              ))
          .toList(),
    );
  }

  void _resetTickers() {
    setState(() {
      tickers = Map.fromIterable(cryptoList,
          key: (crypto) => crypto, value: (crypto) => '??');
    });
  }

  void _updateTickers() async {
    _resetTickers();
    Map<String, String> tempTickers = {};
    for (var c in cryptoList) {
      CoinData coinData = CoinData(coin: c, fiat: selectedFiat);
      final data = await coinData.getCoinData();
      tempTickers.putIfAbsent(c, () => data['rate'].toStringAsFixed(2));
    }
    setState(() {
      tickers = tempTickers;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTickers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: cryptoList
                  .map(
                    (coin) => Card(
                      color: Colors.lightBlueAccent,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 28.0,
                        ),
                        child: Text(
                          '1 $coin = ${tickers[coin]} $selectedFiat',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getiOSPicker() : getAndroidDropdown(),
          ),
        ],
      ),
    );
  }
}
