// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hs_app_flutter/core/analytics/analytics_service.dart' as _i384;
import 'package:hs_app_flutter/core/cubits/cart_count_cubit.dart' as _i884;
import 'package:hs_app_flutter/core/di/register_module.dart' as _i186;
import 'package:hs_app_flutter/core/network/api_client.dart' as _i930;
import 'package:hs_app_flutter/core/network/connectivity/network_info.dart'
    as _i351;
import 'package:hs_app_flutter/core/network/network_client.dart' as _i81;
import 'package:hs_app_flutter/core/services/connectivity_service.dart' as _i93;
import 'package:hs_app_flutter/core/services/pref_manager.dart' as _i818;
import 'package:hs_app_flutter/features/account/data/datasources/remote/account_remote_data_source.dart'
    as _i1020;
import 'package:hs_app_flutter/features/account/data/repositories/account_repository_impl.dart'
    as _i197;
import 'package:hs_app_flutter/features/account/domain/repositories/account_repository.dart'
    as _i532;
import 'package:hs_app_flutter/features/account/domain/usecases/forget_guest_user_usecase.dart'
    as _i72;
import 'package:hs_app_flutter/features/account/domain/usecases/get_account_usecase.dart'
    as _i79;
import 'package:hs_app_flutter/features/account/presentation/bloc/account_bloc.dart'
    as _i18;
import 'package:hs_app_flutter/features/auth/data/datasources/remote/auth_remote_datasource.dart'
    as _i169;
import 'package:hs_app_flutter/features/auth/data/repositories/auth_repository_impl.dart'
    as _i388;
import 'package:hs_app_flutter/features/auth/data/repositories/session_repository_impl.dart'
    as _i296;
import 'package:hs_app_flutter/features/auth/domain/repositories/auth_repository.dart'
    as _i476;
import 'package:hs_app_flutter/features/auth/domain/repositories/session_repository.dart'
    as _i626;
import 'package:hs_app_flutter/features/auth/domain/usecases/clear_session_usecase.dart'
    as _i550;
import 'package:hs_app_flutter/features/auth/domain/usecases/logout_usecase.dart'
    as _i387;
import 'package:hs_app_flutter/features/auth/domain/usecases/persist_session_usecase.dart'
    as _i842;
import 'package:hs_app_flutter/features/auth/domain/usecases/register_usecase.dart'
    as _i903;
import 'package:hs_app_flutter/features/auth/domain/usecases/send_otp_usecase.dart'
    as _i788;
import 'package:hs_app_flutter/features/auth/domain/usecases/verify_otp_usecase.dart'
    as _i410;
import 'package:hs_app_flutter/features/auth/presentation/bloc/auth_bloc.dart'
    as _i419;
import 'package:hs_app_flutter/features/categories/data/datasources/remote/categories_remote_datasource.dart'
    as _i730;
import 'package:hs_app_flutter/features/categories/data/repositories/categories_repository_impl.dart'
    as _i259;
import 'package:hs_app_flutter/features/categories/domain/repositories/categories_repository.dart'
    as _i816;
import 'package:hs_app_flutter/features/categories/domain/usecases/get_departments_usecase.dart'
    as _i765;
import 'package:hs_app_flutter/features/categories/presentation/bloc/categories_bloc.dart'
    as _i620;
import 'package:hs_app_flutter/features/discover/data/datasources/remote/home_remote_datasource.dart'
    as _i184;
import 'package:hs_app_flutter/features/discover/data/repositories/home_repository_impl.dart'
    as _i298;
import 'package:hs_app_flutter/features/discover/domain/repositories/home_repository.dart'
    as _i1014;
import 'package:hs_app_flutter/features/discover/domain/usecases/get_home_page_usecase.dart'
    as _i325;
import 'package:hs_app_flutter/features/discover/presentation/bloc/home_bloc.dart'
    as _i626;
import 'package:hs_app_flutter/features/landing_page/data/repositories/landing_page_repository_impl.dart'
    as _i874;
import 'package:hs_app_flutter/features/landing_page/domain/repositories/landing_page_repository.dart'
    as _i887;
import 'package:hs_app_flutter/features/landing_page/domain/usecases/get_landing_page_usecase.dart'
    as _i1009;
import 'package:hs_app_flutter/features/landing_page/presentation/bloc/landing_page_bloc.dart'
    as _i206;
import 'package:hs_app_flutter/features/orders/data/datasources/remote/orders_api.dart'
    as _i940;
import 'package:hs_app_flutter/features/orders/data/repositories/orders_repository_impl.dart'
    as _i92;
import 'package:hs_app_flutter/features/orders/domain/repositories/orders_repository.dart'
    as _i460;
import 'package:hs_app_flutter/features/orders/domain/usecases/get_orders_page_usecase.dart'
    as _i834;
import 'package:hs_app_flutter/features/orders/presentation/bloc/orders_bloc.dart'
    as _i500;
import 'package:hs_app_flutter/features/plp/data/datasources/remote/plp_remote_datasource.dart'
    as _i252;
import 'package:hs_app_flutter/features/plp/data/repositories/plp_repository_impl.dart'
    as _i491;
import 'package:hs_app_flutter/features/plp/domain/repositories/plp_repository.dart'
    as _i760;
import 'package:hs_app_flutter/features/plp/domain/usecases/get_filter_data_usecase.dart'
    as _i804;
import 'package:hs_app_flutter/features/plp/domain/usecases/get_listing_data_usecase.dart'
    as _i1013;
import 'package:hs_app_flutter/features/plp/presentation/bloc/filter_bloc.dart'
    as _i113;
import 'package:hs_app_flutter/features/plp/presentation/bloc/plp_bloc.dart'
    as _i643;
import 'package:hs_app_flutter/features/splash/domain/usecases/handle_deeplink_usecase.dart'
    as _i806;
import 'package:hs_app_flutter/features/splash/domain/usecases/initialize_app_usecase.dart'
    as _i494;
import 'package:hs_app_flutter/features/splash/presentation/bloc/splash_bloc.dart'
    as _i975;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.lazySingleton<_i384.AnalyticsService>(() => _i384.AnalyticsService());
    gh.lazySingleton<_i833.DeviceInfoPlugin>(() => registerModule.deviceInfo);
    gh.lazySingleton<_i93.ConnectivityService>(
      () => registerModule.connectivityService(),
    );
    gh.lazySingleton<_i806.HandleDeeplinkUseCase>(
      () => _i806.HandleDeeplinkUseCase(),
    );
    gh.lazySingleton<_i494.InitializeAppUseCase>(
      () => _i494.InitializeAppUseCase(),
    );
    gh.lazySingleton<_i351.NetworkInfo>(
      () => registerModule.networkInfo(gh<_i93.ConnectivityService>()),
    );
    await gh.factoryAsync<_i81.NetworkClient>(
      () => registerModule.networkClient(
        gh<_i833.DeviceInfoPlugin>(),
        gh<_i655.PackageInfo>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i818.PrefManager>(
      () => _i818.PrefManager(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i81.NetworkClient>()),
    );
    gh.lazySingleton<_i930.ApiClient>(
      () => registerModule.apiClient(gh<_i81.NetworkClient>()),
    );
    gh.singleton<_i884.CartCountCubit>(
      () => _i884.CartCountCubit(gh<_i818.PrefManager>()),
    );
    gh.lazySingleton<_i626.SessionRepository>(
      () => _i296.SessionRepositoryImpl(
        gh<_i818.PrefManager>(),
        gh<_i81.NetworkClient>(),
      ),
    );
    gh.lazySingleton<_i1020.AccountRemoteDataSource>(
      () => _i1020.AccountRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i169.AuthRemoteDatasource>(
      () => _i169.AuthRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i184.HomeRemoteDataSource>(
      () => _i184.HomeRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i940.OrdersApi>(() => _i940.OrdersApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i460.OrdersRepository>(
      () => _i92.OrdersRepositoryImpl(
        gh<_i940.OrdersApi>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i252.PlpRemoteDataSource>(
      () => _i252.PlpRemoteDataSourceImpl(apiClient: gh<_i930.ApiClient>()),
    );
    gh.lazySingleton<_i887.LandingPageRepository>(
      () => _i874.LandingPageRepositoryImpl(
        gh<_i184.HomeRemoteDataSource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i1014.HomeRepository>(
      () => _i298.HomeRepositoryImpl(
        gh<_i184.HomeRemoteDataSource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i476.AuthRepository>(
      () => _i388.AuthRepositoryImpl(
        gh<_i169.AuthRemoteDatasource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i730.CategoriesRemoteDataSource>(
      () => _i730.CategoriesRemoteDataSourceImpl(
        apiClient: gh<_i930.ApiClient>(),
      ),
    );
    gh.lazySingleton<_i816.CategoriesRepository>(
      () => _i259.CategoriesRepositoryImpl(
        remoteDataSource: gh<_i730.CategoriesRemoteDataSource>(),
        networkInfo: gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i550.ClearSessionUseCase>(
      () => _i550.ClearSessionUseCase(gh<_i626.SessionRepository>()),
    );
    gh.lazySingleton<_i842.PersistSessionUseCase>(
      () => _i842.PersistSessionUseCase(gh<_i626.SessionRepository>()),
    );
    gh.factory<_i975.SplashBloc>(
      () => _i975.SplashBloc(
        networkClient: gh<_i81.NetworkClient>(),
        prefManager: gh<_i818.PrefManager>(),
        handleDeeplinkUseCase: gh<_i806.HandleDeeplinkUseCase>(),
        cartCountCubit: gh<_i884.CartCountCubit>(),
      ),
    );
    gh.lazySingleton<_i760.PlpRepository>(
      () => _i491.PlpRepositoryImpl(
        remoteDataSource: gh<_i252.PlpRemoteDataSource>(),
        networkInfo: gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i1009.GetLandingPageUseCase>(
      () => _i1009.GetLandingPageUseCase(gh<_i887.LandingPageRepository>()),
    );
    gh.lazySingleton<_i532.AccountRepository>(
      () => _i197.AccountRepositoryImpl(
        gh<_i1020.AccountRemoteDataSource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i834.GetOrdersPageUseCase>(
      () => _i834.GetOrdersPageUseCase(gh<_i460.OrdersRepository>()),
    );
    gh.lazySingleton<_i387.LogoutUseCase>(
      () => _i387.LogoutUseCase(gh<_i476.AuthRepository>()),
    );
    gh.lazySingleton<_i903.RegisterUseCase>(
      () => _i903.RegisterUseCase(gh<_i476.AuthRepository>()),
    );
    gh.lazySingleton<_i788.SendOtpUseCase>(
      () => _i788.SendOtpUseCase(gh<_i476.AuthRepository>()),
    );
    gh.lazySingleton<_i410.VerifyOtpUseCase>(
      () => _i410.VerifyOtpUseCase(gh<_i476.AuthRepository>()),
    );
    gh.lazySingleton<_i325.GetHomePageUseCase>(
      () => _i325.GetHomePageUseCase(gh<_i1014.HomeRepository>()),
    );
    gh.lazySingleton<_i804.GetFilterDataUseCase>(
      () => _i804.GetFilterDataUseCase(gh<_i760.PlpRepository>()),
    );
    gh.lazySingleton<_i1013.GetListingDataUseCase>(
      () => _i1013.GetListingDataUseCase(gh<_i760.PlpRepository>()),
    );
    gh.lazySingleton<_i765.GetDepartmentsUseCase>(
      () => _i765.GetDepartmentsUseCase(gh<_i816.CategoriesRepository>()),
    );
    gh.factory<_i643.PlpBloc>(
      () => _i643.PlpBloc(
        getListingDataUseCase: gh<_i1013.GetListingDataUseCase>(),
      ),
    );
    gh.factory<_i500.OrdersBloc>(
      () => _i500.OrdersBloc(gh<_i834.GetOrdersPageUseCase>()),
    );
    gh.lazySingleton<_i72.ForgetGuestUserUseCase>(
      () => _i72.ForgetGuestUserUseCase(gh<_i532.AccountRepository>()),
    );
    gh.lazySingleton<_i79.GetAccountUseCase>(
      () => _i79.GetAccountUseCase(gh<_i532.AccountRepository>()),
    );
    gh.factory<_i419.AuthBloc>(
      () => _i419.AuthBloc(
        gh<_i788.SendOtpUseCase>(),
        gh<_i410.VerifyOtpUseCase>(),
        gh<_i903.RegisterUseCase>(),
        gh<_i842.PersistSessionUseCase>(),
        gh<_i550.ClearSessionUseCase>(),
        gh<_i387.LogoutUseCase>(),
      ),
    );
    gh.factory<_i206.LandingPageBloc>(
      () => _i206.LandingPageBloc(gh<_i1009.GetLandingPageUseCase>()),
    );
    gh.factory<_i626.HomeBloc>(
      () => _i626.HomeBloc(gh<_i325.GetHomePageUseCase>()),
    );
    gh.factory<_i113.FilterBloc>(
      () => _i113.FilterBloc(
        getFilterDataUseCase: gh<_i804.GetFilterDataUseCase>(),
      ),
    );
    gh.factory<_i620.CategoriesBloc>(
      () => _i620.CategoriesBloc(
        getDepartmentsUseCase: gh<_i765.GetDepartmentsUseCase>(),
      ),
    );
    gh.factory<_i18.AccountBloc>(
      () => _i18.AccountBloc(
        gh<_i79.GetAccountUseCase>(),
        gh<_i72.ForgetGuestUserUseCase>(),
        gh<_i818.PrefManager>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i186.RegisterModule {}
