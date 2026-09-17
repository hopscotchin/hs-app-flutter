import 'dart:convert';
import 'package:injectable/injectable.dart';

import 'package:flutter/services.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';

import '../../../../core/config/environment.dart';

@lazySingleton
class JuspayService {
  final HyperSDK _hyperSDK = HyperSDK();

  Future<bool> get isInitialised => _hyperSDK.isInitialised();

  /// Initiates the HyperSDK with merchant config.
  Future<void> initiate() async {
    final payload = <String, dynamic>{
      'requestId': DateTime.now().millisecondsSinceEpoch.toString(),
      'service': 'in.juspay.hyperpay',
      'payload': <String, dynamic>{
        'action': 'initiate',
        'merchantId': 'hopscotch',
        'clientId': 'hopscotch',
        'environment': EnvironmentConfig.isProduction
            ? 'production'
            : 'sandbox',
        'logLevel': '1',
      },
    };
    await _hyperSDK.initiate(payload, _noOpHandler);
  }

  /// Processes the payment with the SDK payload from init-payment API.
  Future<void> processPayment(
    dynamic sdkPayload,
    void Function(Map<String, dynamic>) onEvent,
  ) async {
    Map<String, dynamic> payloadMap;
    if (sdkPayload is String) {
      payloadMap = jsonDecode(sdkPayload) as Map<String, dynamic>;
    } else if (sdkPayload is Map) {
      payloadMap = Map<String, dynamic>.from(sdkPayload);
    } else {
      payloadMap = <String, dynamic>{'payload': sdkPayload};
    }

    await _hyperSDK.process(payloadMap, _createHandler(onEvent));
  }

  /// Handles back press during payment — returns true if HyperSDK consumed it.
  Future<bool> onBackPress() async {
    if (await _hyperSDK.isInitialised()) {
      await _hyperSDK.onBackPress();
      return true;
    }
    return false;
  }

  /// Terminates the HyperSDK session.
  Future<void> terminate() async {
    if (await _hyperSDK.isInitialised()) {
      await _hyperSDK.terminate();
    }
  }

  void Function(MethodCall) _createHandler(
    void Function(Map<String, dynamic>) onEvent,
  ) {
    return (MethodCall methodCall) {
      try {
        if (methodCall.method == 'process_result') {
          final args = methodCall.arguments;
          Map<String, dynamic> eventData;
          if (args is String) {
            eventData = jsonDecode(args) as Map<String, dynamic>;
          } else if (args is Map) {
            eventData = Map<String, dynamic>.from(args);
          } else {
            eventData = {'event': 'unknown', 'payload': args};
          }
          onEvent(eventData);
        }
      } catch (_) {
        onEvent({'event': 'error', 'errorMessage': 'Failed to parse callback'});
      }
    };
  }

  static void _noOpHandler(MethodCall methodCall) {}
}
