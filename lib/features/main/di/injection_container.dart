import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/connectivity/network_info.dart';
import '../../../core/network/cookies/cookies_based_events_util.dart';
import '../../../core/network/cookies/hs_cookie_store.dart';
import '../../../core/network/network_client.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/pref_manager.dart';
// Cart Module
import '../../cart/presentation/bloc/cart_bloc.dart';
// Categories Module
import '../../categories/data/datasources/remote/categories_remote_datasource.dart';
import '../../categories/data/repositories/categories_repository_impl.dart';
import '../../categories/domain/repositories/categories_repository.dart';
import '../../categories/domain/usecases/get_departments_usecase.dart';
import '../../categories/presentation/bloc/categories_bloc.dart';
// Discover Module
import '../../discover/data/datasources/remote/home_remote_datasource.dart';
import '../../discover/data/repositories/home_repository_impl.dart';
import '../../discover/domain/repositories/home_repository.dart';
import '../../discover/domain/usecases/get_home_page_usecase.dart';
import '../../discover/presentation/bloc/home_bloc.dart';
import '../../splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefManager = await PrefManager.init();
  sl.registerLazySingleton(() => prefManager);

  // Initialize cookie stores with PrefManager
  HSCookieStore.init(prefManager);
  CookiesBasedEventsUtil.instance.init(prefManager);

  final deviceInfo = DeviceInfoPlugin();
  sl.registerLazySingleton(() => deviceInfo);

  final packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton(() => packageInfo);

  // Core - Network Client
  final networkClient = NetworkClient(
    deviceInfo: deviceInfo,
    packageInfo: packageInfo,
  );
  await networkClient.init();

  // Restore persistent ticket from SharedPreferences so the first API call
  // (e.g. /customer/v2/info in SplashBloc) includes the auth header.
  final savedTicket = prefManager.persistentTicket;
  if (savedTicket != null && savedTicket.isNotEmpty) {
    networkClient.setPersistentTicket(savedTicket);
  }

  sl.registerLazySingleton(() => networkClient);
  sl.registerLazySingleton<ApiClient>(() => networkClient.apiClient);

  // Connectivity (single source for both NetworkInfo checks and stream)
  final connectivityService = ConnectivityService();
  sl.registerLazySingleton(() => connectivityService);
  sl.registerLazySingleton<NetworkInfo>(() => connectivityService);

  // Analytics
  sl.registerLazySingleton(AnalyticsService.new);

  // Splash Module
  sl.registerFactory(
    () => SplashBloc(
      networkClient: sl(),
      prefManager: sl()
    ),
  );

  // ============================
  // Discover Module
  // ============================
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetHomePageUseCase(sl()));
  sl.registerFactory(() => HomeBloc(getHomePageUseCase: sl()));

  // ============================
  // Categories Module
  // ============================
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetDepartmentsUseCase(sl()));
  sl.registerFactory(() => CategoriesBloc(getDepartmentsUseCase: sl()));

  // ============================
  // Cart Module
  // ============================
  sl.registerFactory(
    () => CartBloc(
      prefManager: sl(),
    ),
  );
}
