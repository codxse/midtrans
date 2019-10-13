import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

typedef Future<void> MidtransCallback(TransactionFinished transactionFinished);

class Midtrans {
  static const MethodChannel _channel = const MethodChannel('id.nadiar.midtrans');
  static MidtransCallback finishCallback;

  Midtrans(String clientKey, String merchantBaseUrl) {
    _channel.invokeMethod('init', {
      "clientKey": clientKey,
      "merchantBaseUrl": merchantBaseUrl,
    });
  }

  Future<dynamic> _channelHandler(MethodCall methodCall) async {
    if (methodCall.method == "onTransactionFinished") {
      if (finishCallback != null) {
        await finishCallback(TransactionFinished(
          methodCall.arguments['transactionCanceled'],
          methodCall.arguments['status'],
          methodCall.arguments['source'],
          methodCall.arguments['statusMessage'],
          methodCall.arguments['response'],
        ));
      }}
    return null;
  }

  void _setFinishCallback(MidtransCallback callback) {
    finishCallback = callback;
  }

  Future<void> purchase({@required String token, @required MidtransCallback callback}) async {
    _channel.setMethodCallHandler(_channelHandler);
    this._setFinishCallback(callback);
    await _channel.invokeMethod('purchase', {
      "token": token,
    });
  }

}

class TransactionFinished {
  final bool transactionCanceled;
  final String status;
  final String source;
  final String statusMessage;
  final String response;

  TransactionFinished(
    this.transactionCanceled,
    this.status,
    this.source,
    this.statusMessage,
    this.response,
  );

  @override
  String toString() {
    return 'TransactionFinished({transactionCanceled: $transactionCanceled, status: $status, source: $source, statusMessage: $statusMessage, response: $response)';
  }
}

