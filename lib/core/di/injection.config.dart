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
import 'package:hs_app_flutter/core/services/push_notification_service.dart'
    as _i1061;
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
import 'package:hs_app_flutter/features/address/data/datasources/remote/address_remote_datasource.dart'
    as _i148;
import 'package:hs_app_flutter/features/address/data/managers/address_cache_manager.dart'
    as _i1013;
import 'package:hs_app_flutter/features/address/data/repositories/address_repository_impl.dart'
    as _i121;
import 'package:hs_app_flutter/features/address/domain/repositories/address_repository.dart'
    as _i241;
import 'package:hs_app_flutter/features/address/domain/usecases/check_pincode_usecase.dart'
    as _i427;
import 'package:hs_app_flutter/features/address/domain/usecases/create_address_usecase.dart'
    as _i697;
import 'package:hs_app_flutter/features/address/domain/usecases/delete_address_usecase.dart'
    as _i277;
import 'package:hs_app_flutter/features/address/domain/usecases/get_addresses_usecase.dart'
    as _i637;
import 'package:hs_app_flutter/features/address/domain/usecases/select_address_usecase.dart'
    as _i551;
import 'package:hs_app_flutter/features/address/domain/usecases/update_address_usecase.dart'
    as _i381;
import 'package:hs_app_flutter/features/address/presentation/bloc/address_bloc.dart'
    as _i833;
import 'package:hs_app_flutter/features/address/presentation/bloc/manage_address_bloc.dart'
    as _i531;
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
import 'package:hs_app_flutter/features/auth/domain/usecases/check_mobile_usecase.dart'
    as _i766;
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
import 'package:hs_app_flutter/features/device/data/datasources/remote/device_remote_datasource.dart'
    as _i76;
import 'package:hs_app_flutter/features/device/data/repositories/device_repository_impl.dart'
    as _i1067;
import 'package:hs_app_flutter/features/device/domain/repositories/device_repository.dart'
    as _i357;
import 'package:hs_app_flutter/features/device/domain/usecases/register_device_usecase.dart'
    as _i407;
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
import 'package:hs_app_flutter/features/landing_page/presentation/bloc/landing_page_bloc.dart'
    as _i206;
import 'package:hs_app_flutter/features/splash/data/datasources/remote/splash_remote_datasource.dart'
    as _i748;
import 'package:hs_app_flutter/features/splash/data/repositories/splash_repository_impl.dart'
    as _i558;
import 'package:hs_app_flutter/features/splash/domain/repositories/splash_repository.dart'
    as _i68;
import 'package:hs_app_flutter/features/splash/domain/usecases/get_app_config_usecase.dart'
    as _i705;
import 'package:hs_app_flutter/features/splash/domain/usecases/get_customer_info_usecase.dart'
    as _i505;
import 'package:hs_app_flutter/features/splash/domain/usecases/handle_deeplink_usecase.dart'
    as _i806;
import 'package:hs_app_flutter/features/splash/domain/usecases/initialize_app_usecase.dart'
    as _i494;
import 'package:hs_app_flutter/features/splash/domain/usecases/reconfigure_network_usecase.dart'
    as _i259;
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
    gh.lazySingleton<_i259.ReconfigureNetworkUseCase>(
      () => _i259.ReconfigureNetworkUseCase(gh<_i81.NetworkClient>()),
    );
    gh.singleton<_i884.CartCountCubit>(
      () => _i884.CartCountCubit(gh<_i818.PrefManager>()),
    );
    gh.lazySingleton<_i1013.AddressCacheManager>(
      () => _i1013.AddressCacheManager(gh<_i818.PrefManager>()),
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
    gh.lazySingleton<_i148.AddressRemoteDatasource>(
      () => _i148.AddressRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i169.AuthRemoteDatasource>(
      () => _i169.AuthRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i76.DeviceRemoteDatasource>(
      () => _i76.DeviceRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i184.HomeRemoteDataSource>(
      () => _i184.HomeRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i748.SplashRemoteDatasource>(
      () => _i748.SplashRemoteDatasource(gh<_i361.Dio>()),
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
    gh.lazySingleton<_i68.SplashRepository>(
      () => _i558.SplashRepositoryImpl(
        gh<_i748.SplashRemoteDatasource>(),
        gh<_i351.NetworkInfo>(),
        gh<_i818.PrefManager>(),
        gh<_i81.NetworkClient>(),
      ),
    );
    gh.lazySingleton<_i550.ClearSessionUseCase>(
      () => _i550.ClearSessionUseCase(gh<_i626.SessionRepository>()),
    );
    gh.lazySingleton<_i842.PersistSessionUseCase>(
      () => _i842.PersistSessionUseCase(gh<_i626.SessionRepository>()),
    );
    gh.lazySingleton<_i241.AddressRepository>(
      () => _i121.AddressRepositoryImpl(
        gh<_i148.AddressRemoteDatasource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i427.CheckPincodeUseCase>(
      () => _i427.CheckPincodeUseCase(gh<_i241.AddressRepository>()),
    );
    gh.lazySingleton<_i697.CreateAddressUseCase>(
      () => _i697.CreateAddressUseCase(gh<_i241.AddressRepository>()),
    );
    gh.lazySingleton<_i277.DeleteAddressUseCase>(
      () => _i277.DeleteAddressUseCase(gh<_i241.AddressRepository>()),
    );
    gh.lazySingleton<_i637.GetAddressesUseCase>(
      () => _i637.GetAddressesUseCase(gh<_i241.AddressRepository>()),
    );
    gh.lazySingleton<_i551.SelectAddressUseCase>(
      () => _i551.SelectAddressUseCase(gh<_i241.AddressRepository>()),
    );
    gh.lazySingleton<_i381.UpdateAddressUseCase>(
      () => _i381.UpdateAddressUseCase(gh<_i241.AddressRepository>()),
    );
    gh.lazySingleton<_i357.DeviceRepository>(
      () => _i1067.DeviceRepositoryImpl(
        gh<_i76.DeviceRemoteDatasource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i532.AccountRepository>(
      () => _i197.AccountRepositoryImpl(
        gh<_i1020.AccountRemoteDataSource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i766.CheckMobileUseCase>(
      () => _i766.CheckMobileUseCase(gh<_i476.AuthRepository>()),
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
    gh.lazySingleton<_i765.GetDepartmentsUseCase>(
      () => _i765.GetDepartmentsUseCase(gh<_i816.CategoriesRepository>()),
    );
    gh.lazySingleton<_i705.GetAppConfigUseCase>(
      () => _i705.GetAppConfigUseCase(gh<_i68.SplashRepository>()),
    );
    gh.lazySingleton<_i505.GetCustomerInfoUseCase>(
      () => _i505.GetCustomerInfoUseCase(gh<_i68.SplashRepository>()),
    );
    gh.factory<_i833.AddressBloc>(
      () => _i833.AddressBloc(
        gh<_i637.GetAddressesUseCase>(),
        gh<_i277.DeleteAddressUseCase>(),
        gh<_i551.SelectAddressUseCase>(),
        gh<_i1013.AddressCacheManager>(),
      ),
    );
    gh.lazySingleton<_i407.RegisterDeviceUseCase>(
      () => _i407.RegisterDeviceUseCase(gh<_i357.DeviceRepository>()),
    );
    gh.lazySingleton<_i72.ForgetGuestUserUseCase>(
      () => _i72.ForgetGuestUserUseCase(gh<_i532.AccountRepository>()),
    );
    gh.lazySingleton<_i79.GetAccountUseCase>(
      () => _i79.GetAccountUseCase(gh<_i532.AccountRepository>()),
    );
    gh.lazySingleton<_i1061.PushNotificationService>(
      () => _i1061.PushNotificationService(
        gh<_i407.RegisterDeviceUseCase>(),
        gh<_i818.PrefManager>(),
      ),
    );
    gh.factory<_i531.ManageAddressBloc>(
      () => _i531.ManageAddressBloc(
        gh<_i697.CreateAddressUseCase>(),
        gh<_i381.UpdateAddressUseCase>(),
        gh<_i427.CheckPincodeUseCase>(),
        gh<_i551.SelectAddressUseCase>(),
        gh<_i1013.AddressCacheManager>(),
      ),
    );
    gh.factory<_i626.HomeBloc>(
      () => _i626.HomeBloc(gh<_i325.GetHomePageUseCase>()),
    );
    gh.factory<_i206.LandingPageBloc>(
      () => _i206.LandingPageBloc(gh<_i325.GetHomePageUseCase>()),
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
        gh<_i637.GetAddressesUseCase>(),
        gh<_i1013.AddressCacheManager>(),
      ),
    );
    gh.factory<_i975.SplashBloc>(
      () => _i975.SplashBloc(
        gh<_i705.GetAppConfigUseCase>(),
        gh<_i505.GetCustomerInfoUseCase>(),
        gh<_i806.HandleDeeplinkUseCase>(),
        gh<_i259.ReconfigureNetworkUseCase>(),
        gh<_i818.PrefManager>(),
        gh<_i1013.AddressCacheManager>(),
        gh<_i637.GetAddressesUseCase>(),
      ),
    );
    gh.factory<_i419.AuthBloc>(
      () => _i419.AuthBloc(
        gh<_i766.CheckMobileUseCase>(),
        gh<_i788.SendOtpUseCase>(),
        gh<_i410.VerifyOtpUseCase>(),
        gh<_i903.RegisterUseCase>(),
        gh<_i842.PersistSessionUseCase>(),
        gh<_i550.ClearSessionUseCase>(),
        gh<_i387.LogoutUseCase>(),
        gh<_i1061.PushNotificationService>(),
        gh<_i18.AccountBloc>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i186.RegisterModule {}
