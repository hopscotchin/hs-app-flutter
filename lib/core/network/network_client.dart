import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/environment.dart';
import '../constants/api_constants.dart';
import '../services/pref_manager.dart';
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
}
