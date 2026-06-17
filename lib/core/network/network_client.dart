import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:hs_app_flutter/core/config/env_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/environment.dart';
import '../constants/api_constants.dart';
import '../services/pref_manager.dart';
import '../utils/device_utils.dart';
import 'api_client.dart';
import 'cookies/hs_cookie_store.dart';
import 'interceptors/auth_header_interceptor.dart';
import 'interceptors/auto_login_interceptor.dart';
import 'interceptors/cookie_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class NetworkClient {
  late final Dio dio;
  late final ApiClient apiClient;
  late final AuthHeaderInterceptor authHeaderInterceptor;
  late final CookieInterceptor cookieInterceptor;
  late final AutoLoginInterceptor _autoLoginInterceptor;

  final DeviceInfoPlugin _deviceInfo;
  final PackageInfo _packageInfo;

  NetworkClient({required DeviceInfoPlugin deviceInfo, required PackageInfo packageInfo})
    : _deviceInfo = deviceInfo,
      _packageInfo = packageInfo;

  Future<void> init() async {
    authHeaderInterceptor = AuthHeaderInterceptor(
      deviceInfo: _deviceInfo,
      packageInfo: _packageInfo,
    );
    await authHeaderInterceptor.init();

    HSCookieStore.setHost(ApiConstants.baseUrl);

    cookieInterceptor = CookieInterceptor();
    await cookieInterceptor.init();

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        responseType: ResponseType.json,
        // Web: omit Content-Type from defaults — it triggers a CORS preflight
        // on GET requests. The interceptor sets it only for POST/PUT as needed.
        headers: kIsWeb
            ? {'Accept': 'application/json'}
            : {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    _autoLoginInterceptor = AutoLoginInterceptor(
      mainDio: dio,
      authHeaderInterceptor: authHeaderInterceptor,
    );

    dio.interceptors.add(authHeaderInterceptor);
    dio.interceptors.add(cookieInterceptor);
    dio.interceptors.add(_autoLoginInterceptor);
    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }

    if (kDebugMode && EnvConfig.enableHttpToolkitProxy && await DeviceUtils.isIosSimulator()) {
      // enableProxy(host: EnvConfig.proxyHost, port: EnvConfig.proxyPort);
      dio.interceptors.add(_ProxyRetryInterceptor(dio));
      enableProxy();
      dio.options.connectTimeout = const Duration(minutes: 2);
      dio.options.receiveTimeout = const Duration(minutes: 2);
    }

    apiClient = ApiClient(dio: dio);
  }

  void onEnvironmentChanged() {
    dio.options.baseUrl = EnvironmentConfig.baseUrl;
    HSCookieStore.setHost(EnvironmentConfig.baseUrl);
    _autoLoginInterceptor.updateBaseUrl(EnvironmentConfig.baseUrl);
  }

  void bindPrefManager(PrefManager prefManager) {
    _autoLoginInterceptor.bindPrefManager(prefManager);
  }

  void setPersistentTicket(String? ticket) {
    authHeaderInterceptor.setPersistentTicket(ticket);
  }

  void setN7HdToken(String? token) {
    authHeaderInterceptor.setN7HdToken(token);
  }

  void setN7HumanDetectorEnabled(bool enabled) {
    authHeaderInterceptor.setN7HumanDetectorEnabled(enabled);
  }

  void setDeviceProfile(String profile) {
    authHeaderInterceptor.setDeviceProfile(profile);
  }

  void cancelAllRequests() {
    dio.close(force: true);
  }

  /// Route all Dio traffic through an HTTP debugging proxy.
  ///
  /// Only active on iOS Simulator — [host] defaults to `127.0.0.1`.
  /// The [port] defaults to HTTP Toolkit's default (`8000`).
  void enableProxy({String host = '127.0.0.1', int port = 8000}) {
    if (!kDebugMode) return;

    final String proxyHost = host;

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (uri) => 'PROXY $proxyHost:$port';
        client.badCertificateCallback = (cert, _, _) => true;
        return client;
      },
    );

    debugPrint('');
    debugPrint('══════════════════════════════════════════════');
    debugPrint('  HTTP PROXY ACTIVE → proxyHost: $proxyHost, proxyPort: $port');
    debugPrint('══════════════════════════════════════════════');
    debugPrint('');
  }
}

/// Debug-only interceptor that transparently retries requests which fail
/// with socket-level errors caused by an HTTP debugging proxy tearing
/// down its tunneled connection (HTTP Toolkit, Charles, Proxyman).
///
/// Triggers for: "Broken pipe", "Connection reset", "Connection closed",
/// "Software caused connection abort". Retries exactly once — a second
/// failure falls through with the original error so genuine network
/// problems still surface.
class _ProxyRetryInterceptor extends Interceptor {
  _ProxyRetryInterceptor(this._dio);

  final Dio _dio;

  static const _retryFlag = '_proxyRetryAttempted';
  static const _maxRetries = 2;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('[ProxyRetry] onError ${err.type} for ${err.requestOptions.uri}');
    debugPrint('[ProxyRetry]   error=${err.error} (${err.error?.runtimeType})');

    final attempts = (err.requestOptions.extra[_retryFlag] as int?) ?? 0;
    if (attempts < _maxRetries && _isTransientProxyError(err)) {
      debugPrint('[ProxyRetry]   retrying (attempt ${attempts + 1})');
      try {
        final opts = err.requestOptions;
        opts.extra[_retryFlag] = attempts + 1;
        // Force a fresh TCP connection for the retry so we don't hit
        // the same broken socket we just tripped over.
        opts.headers['Connection'] = 'close';
        final response = await _dio.fetch<dynamic>(opts);
        debugPrint('[ProxyRetry]   retry OK (${response.statusCode})');
        return handler.resolve(response);
      } catch (e) {
        debugPrint('[ProxyRetry]   retry failed: $e');
      }
    }
    handler.next(err);
  }

  bool _isTransientProxyError(DioException err) {
    if (err.type != DioExceptionType.unknown && err.type != DioExceptionType.connectionError) {
      return false;
    }
    final msg = err.error?.toString() ?? err.message ?? '';
    return msg.contains('Broken pipe') ||
        msg.contains('Connection reset') ||
        msg.contains('Connection closed') ||
        msg.contains('Software caused connection abort');
  }
}
