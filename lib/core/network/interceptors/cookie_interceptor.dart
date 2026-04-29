import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../cookies/cookies_based_events_util.dart';
import '../cookies/hs_cookie_store.dart';

class CookieInterceptor extends Interceptor {
  Future<void> init() async {
    await CookiesBasedEventsUtil.instance.loadPersistedData();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Browsers manage cookies natively; setting Cookie header manually is forbidden.
    if (kIsWeb) {
      handler.next(options);
      return;
    }
    HSCookieStore.getCookies().then((cookies) {
      if (cookies.isNotEmpty) {
        options.headers['Cookie'] = cookies.toList();
      }
      handler.next(options);
    }).catchError((Object _) {
      handler.next(options);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _receiveCookies(response.requestOptions.uri, response.headers);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      _receiveCookies(err.requestOptions.uri, err.response!.headers);
    }
    handler.next(err);
  }

  void _receiveCookies(Uri uri, Headers headers) {
    if (uri.toString().contains('latencycheck')) return;

    final setCookies = headers['set-cookie'];
    if (setCookies == null || setCookies.isEmpty) return;

    HSCookieStore.setCookies(setCookies.toSet()).then((_) {
      CookiesBasedEventsUtil.instance.handleCookiesAndSessionStartEvent();
    }).catchError((Object e) {
      if (kDebugMode) {
        developer.log('Error storing cookies: $e', name: 'CookieInterceptor');
      }
    });
  }

  Future<void> clear() async {
    await HSCookieStore.clearCookies();
  }
}
