import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../analytics/analytics_service.dart';
import '../network/api_client.dart';
import '../network/connectivity/network_info.dart';
import '../network/network_client.dart';
import '../services/connectivity_service.dart';
import '../services/pref_manager.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @lazySingleton
  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  @preResolve
  Future<NetworkClient> networkClient(
    DeviceInfoPlugin deviceInfo,
    PackageInfo packageInfo,
  ) async {
    final client = NetworkClient(
      deviceInfo: deviceInfo,
      packageInfo: packageInfo,
    );
    await client.init();
    return client;
  }

  @lazySingleton
  Dio dio(NetworkClient networkClient) => networkClient.dio;

  @lazySingleton
  ApiClient apiClient(NetworkClient networkClient) => networkClient.apiClient;

  @lazySingleton
  ConnectivityService connectivityService() => ConnectivityService();

  @lazySingleton
  NetworkInfo networkInfo(ConnectivityService service) => service;

  /// Pre-resolves AnalyticsService so its Segment + AppsFlyer init completes
  /// before any caller (Bloc, Repository) resolves the singleton.
  @preResolve
  @lazySingleton
  Future<AnalyticsService> analyticsService(PrefManager prefManager) async {
    final service = AnalyticsService(prefManager);
    await service.init();
    return service;
  }
}
