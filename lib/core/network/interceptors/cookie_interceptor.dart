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
    HSCookieStore.getCookies()
        .then((cookies) {
          if (cookies.isNotEmpty) {
            options.headers['Cookie'] = cookies.toList();
          }
          handler.next(options);
        })
        .catchError((Object _) {
          handler.next(options);
        });
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await _receiveCookies(response.requestOptions.uri, response.headers);
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response != null) {
      await _receiveCookies(err.requestOptions.uri, err.response!.headers);
    }
    handler.next(err);
  }

  /// Persists Set-Cookie headers and drives cookie-based identify. Awaited by
  /// `onResponse`/`onError` before `handler.next(...)` so the identify pipeline
  /// (including `InjectUserInfo`, which updates `state.userInfo.userTraits`)
  /// completes before the app receives the response. Without this,
  /// homepage_viewed and other track events that read `context.traits` via
  /// `ContextParityPlugin` can race the cookie-driven identify and ship
  /// stale traits (notably `experiments`, `visitor_type`, `days_since_last_visit`).
  Future<void> _receiveCookies(Uri uri, Headers headers) async {
    if (uri.toString().contains('latencycheck')) return;

    final setCookies = headers['set-cookie'];
    if (setCookies == null || setCookies.isEmpty) return;

    try {
      await HSCookieStore.setCookies(setCookies.toSet());
      await CookiesBasedEventsUtil.instance.handleCookiesAndSessionStartEvent();
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Error storing cookies: $e',
          name: 'CookieInterceptor',
        );
      }
    }
  }

  Future<void> clear() async {
    await HSCookieStore.clearCookies();
  }
}
