import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  static const _sensitiveHeaders = {
    'secret-key',
    'hs-persistent-ticket',
    'x-nv-hd-token',
    'x-nv-security-key',
    'x-nv-hd-hl-key',
    'x-nv-security-magic',
    'cookie',
  };

  static const int _maxBodyLength = 800;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      try {
        developer.log('\u2192 ${options.method} ${options.uri}', name: 'HTTP');
        options.headers.forEach((key, value) {
          final redacted = _sensitiveHeaders.contains(key.toLowerCase());
          developer.log('  $key: ${redacted ? '***' : value}', name: 'HTTP');
        });
        if (options.data != null) {
          developer.log('  Body: ${options.data}', name: 'HTTP');
        }
      } catch (_) {}
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      try {
        final uri = response.requestOptions.uri;
        developer.log('\u2190 ${response.statusCode} $uri', name: 'HTTP');
        _logBody(response.data);
      } catch (_) {}
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      try {
        developer.log(
          '\u2715 ${err.type.name} ${err.requestOptions.uri} \u2014 ${err.message}',
          name: 'HTTP',
          error: err.error,
        );
        if (err.response != null) {
          developer.log('  Status: ${err.response?.statusCode}', name: 'HTTP');
          _logBody(err.response?.data);
        }
      } catch (_) {}
    }
    handler.next(err);
  }

  void _logBody(dynamic data) {
    if (data == null) return;
    try {
      String body;
      if (data is Map || data is List) {
        body = const JsonEncoder.withIndent('  ').convert(data);
      } else {
        body = data.toString();
      }
      if (body.length > _maxBodyLength) {
        body =
            '${body.substring(0, _maxBodyLength)}\u2026 [truncated ${body.length} chars]';
      }
      developer.log('  Response:\n$body', name: 'HTTP');
    } catch (_) {
      developer.log(
        '  Response body: [unprintable ${data.runtimeType}]',
        name: 'HTTP',
      );
    }
  }
}
