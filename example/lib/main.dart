import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:midtrans/midtrans.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              this._purchaseProductButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _purchaseProductButton(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        print('Clicked');
        final Midtrans midtrans = Midtrans('Mid-client-token', 'https://www.zenius.net');
        print('hello');
        await midtrans.purchase(
          token: '5df03d61-453a-4ce4-aaa9-599abfd65efa',
          callback: (TransactionFinished finished) async {
            print(finished);
          }
        );
      },
      child: Text("Arbitrary Purchase"),
    );
  }
}
