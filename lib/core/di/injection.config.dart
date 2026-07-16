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
import 'package:hs_app_flutter/features/auth/domain/usecases/generate_login_ticket_usecase.dart'
    as _i895;
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
import 'package:hs_app_flutter/features/cart/data/datasources/remote/cart_remote_datasource.dart'
    as _i454;
import 'package:hs_app_flutter/features/cart/data/repositories/cart_repository_impl.dart'
    as _i77;
import 'package:hs_app_flutter/features/cart/domain/repositories/cart_repository.dart'
    as _i901;
import 'package:hs_app_flutter/features/cart/domain/usecases/add_to_cart_usecase.dart'
    as _i163;
import 'package:hs_app_flutter/features/cart/domain/usecases/apply_promo_code_usecase.dart'
    as _i783;
import 'package:hs_app_flutter/features/cart/domain/usecases/get_cart_usecase.dart'
    as _i242;
import 'package:hs_app_flutter/features/cart/domain/usecases/merge_cart_usecase.dart'
    as _i576;
import 'package:hs_app_flutter/features/cart/domain/usecases/move_to_wishlist_usecase.dart'
    as _i44;
import 'package:hs_app_flutter/features/cart/domain/usecases/remove_cart_item_usecase.dart'
    as _i1036;
import 'package:hs_app_flutter/features/cart/domain/usecases/remove_promo_code_usecase.dart'
    as _i454;
import 'package:hs_app_flutter/features/cart/domain/usecases/update_cart_item_usecase.dart'
    as _i231;
import 'package:hs_app_flutter/features/cart/presentation/bloc/cart_bloc.dart'
    as _i672;
import 'package:hs_app_flutter/features/cart/presentation/cubit/cart_actions_cubit.dart'
    as _i521;
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
import 'package:hs_app_flutter/features/pdp/data/datasources/remote/pdp_remote_datasource.dart'
    as _i976;
import 'package:hs_app_flutter/features/pdp/data/repositories/pdp_repository_impl.dart'
    as _i977;
import 'package:hs_app_flutter/features/pdp/domain/repositories/pdp_repository.dart'
    as _i425;
import 'package:hs_app_flutter/features/pdp/domain/usecases/get_product_details_usecase.dart'
    as _i59;
import 'package:hs_app_flutter/features/pdp/domain/usecases/get_recommendations_usecase.dart'
    as _i69;
import 'package:hs_app_flutter/features/pdp/domain/usecases/get_size_chart_usecase.dart'
    as _i1001;
import 'package:hs_app_flutter/features/pdp/domain/usecases/verify_pincode_usecase.dart'
    as _i197;
import 'package:hs_app_flutter/features/pdp/presentation/bloc/pdp_bloc.dart'
    as _i309;
import 'package:hs_app_flutter/features/pincode/data/datasources/remote/pincode_remote_datasource.dart'
    as _i538;
import 'package:hs_app_flutter/features/pincode/data/repositories/pincode_repository_impl.dart'
    as _i68;
import 'package:hs_app_flutter/features/pincode/domain/repositories/pincode_repository.dart'
    as _i799;
import 'package:hs_app_flutter/features/pincode/domain/usecases/check_delivery_pincode_usecase.dart'
    as _i297;
import 'package:hs_app_flutter/features/pincode/presentation/bloc/pincode_sheet_bloc.dart'
    as _i487;
import 'package:hs_app_flutter/features/plp/data/datasources/remote/plp_api.dart'
    as _i13;
import 'package:hs_app_flutter/features/plp/data/repositories/plp_repository_impl.dart'
    as _i491;
import 'package:hs_app_flutter/features/plp/domain/repositories/plp_repository.dart'
    as _i760;
import 'package:hs_app_flutter/features/plp/domain/usecases/check_pincode_usecase.dart'
    as _i283;
import 'package:hs_app_flutter/features/plp/domain/usecases/get_filter_data_usecase.dart'
    as _i804;
import 'package:hs_app_flutter/features/plp/domain/usecases/get_listing_data_usecase.dart'
    as _i1013;
import 'package:hs_app_flutter/features/plp/presentation/bloc/filter_bloc.dart'
    as _i113;
import 'package:hs_app_flutter/features/plp/presentation/bloc/plp_bloc.dart'
    as _i643;
import 'package:hs_app_flutter/features/search/data/datasources/remote/search_api.dart'
    as _i1058;
import 'package:hs_app_flutter/features/search/data/repositories/search_repository_impl.dart'
    as _i525;
import 'package:hs_app_flutter/features/search/domain/repositories/search_repository.dart'
    as _i283;
import 'package:hs_app_flutter/features/search/domain/usecases/get_search_suggestions_usecase.dart'
    as _i938;
import 'package:hs_app_flutter/features/search/presentation/bloc/search_bloc.dart'
    as _i724;
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
import 'package:hs_app_flutter/features/wishlist/data/datasources/remote/wishlist_remote_datasource.dart'
    as _i906;
import 'package:hs_app_flutter/features/wishlist/data/repositories/wishlist_repository_impl.dart'
    as _i556;
import 'package:hs_app_flutter/features/wishlist/domain/repositories/wishlist_repository.dart'
    as _i945;
import 'package:hs_app_flutter/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart'
    as _i363;
import 'package:hs_app_flutter/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart'
    as _i692;
import 'package:hs_app_flutter/features/wishlist/presentation/cubit/wishlist_cubit.dart'
    as _i938;
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
    gh.lazySingleton<_i940.OrdersApi>(() => _i940.OrdersApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i976.PdpRemoteDatasource>(
      () => _i976.PdpRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i538.PincodeRemoteDatasource>(
      () => _i538.PincodeRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i13.PlpApi>(() => _i13.PlpApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i1058.SearchApi>(() => _i1058.SearchApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i748.SplashRemoteDatasource>(
      () => _i748.SplashRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i906.WishlistRemoteDataSource>(
      () =>
          _i906.WishlistRemoteDataSourceImpl(apiClient: gh<_i930.ApiClient>()),
    );
    gh.lazySingleton<_i425.PdpRepository>(
      () => _i977.PdpRepositoryImpl(
        gh<_i976.PdpRemoteDatasource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i460.OrdersRepository>(
      () => _i92.OrdersRepositoryImpl(
        gh<_i940.OrdersApi>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i454.CartRemoteDataSource>(
      () => _i454.CartRemoteDataSourceImpl(apiClient: gh<_i930.ApiClient>()),
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
    gh.lazySingleton<_i799.PincodeRepository>(
      () => _i68.PincodeRepositoryImpl(
        gh<_i538.PincodeRemoteDatasource>(),
        gh<_i351.NetworkInfo>(),
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
    gh.lazySingleton<_i59.GetProductDetailsUseCase>(
      () => _i59.GetProductDetailsUseCase(gh<_i425.PdpRepository>()),
    );
    gh.lazySingleton<_i69.GetRecommendationsUseCase>(
      () => _i69.GetRecommendationsUseCase(gh<_i425.PdpRepository>()),
    );
    gh.lazySingleton<_i1001.GetSizeChartUseCase>(
      () => _i1001.GetSizeChartUseCase(gh<_i425.PdpRepository>()),
    );
    gh.lazySingleton<_i197.VerifyPincodeUseCase>(
      () => _i197.VerifyPincodeUseCase(gh<_i425.PdpRepository>()),
    );
    gh.lazySingleton<_i241.AddressRepository>(
      () => _i121.AddressRepositoryImpl(
        gh<_i148.AddressRemoteDatasource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i945.WishlistRepository>(
      () => _i556.WishlistRepositoryImpl(
        remoteDataSource: gh<_i906.WishlistRemoteDataSource>(),
        networkInfo: gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i297.CheckDeliveryPincodeUseCase>(
      () => _i297.CheckDeliveryPincodeUseCase(gh<_i799.PincodeRepository>()),
    );
    gh.lazySingleton<_i901.CartRepository>(
      () => _i77.CartRepositoryImpl(
        remoteDataSource: gh<_i454.CartRemoteDataSource>(),
        networkInfo: gh<_i351.NetworkInfo>(),
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
    gh.factory<_i487.PincodeSheetBloc>(
      () => _i487.PincodeSheetBloc(
        gh<_i297.CheckDeliveryPincodeUseCase>(),
        gh<_i551.SelectAddressUseCase>(),
        gh<_i1013.AddressCacheManager>(),
      ),
    );
    gh.lazySingleton<_i532.AccountRepository>(
      () => _i197.AccountRepositoryImpl(
        gh<_i1020.AccountRemoteDataSource>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i363.AddToWishlistUseCase>(
      () => _i363.AddToWishlistUseCase(gh<_i945.WishlistRepository>()),
    );
    gh.lazySingleton<_i692.RemoveFromWishlistUseCase>(
      () => _i692.RemoveFromWishlistUseCase(gh<_i945.WishlistRepository>()),
    );
    gh.lazySingleton<_i834.GetOrdersPageUseCase>(
      () => _i834.GetOrdersPageUseCase(gh<_i460.OrdersRepository>()),
    );
    gh.lazySingleton<_i283.SearchRepository>(
      () => _i525.SearchRepositoryImpl(
        gh<_i1058.SearchApi>(),
        gh<_i351.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i938.GetSearchSuggestionsUseCase>(
      () => _i938.GetSearchSuggestionsUseCase(gh<_i283.SearchRepository>()),
    );
    gh.lazySingleton<_i766.CheckMobileUseCase>(
      () => _i766.CheckMobileUseCase(gh<_i476.AuthRepository>()),
    );
    gh.lazySingleton<_i895.GenerateLoginTicketUseCase>(
      () => _i895.GenerateLoginTicketUseCase(gh<_i476.AuthRepository>()),
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
    gh.lazySingleton<_i760.PlpRepository>(
      () => _i491.PlpRepositoryImpl(gh<_i13.PlpApi>(), gh<_i351.NetworkInfo>()),
    );
    gh.lazySingleton<_i163.AddToCartUseCase>(
      () => _i163.AddToCartUseCase(gh<_i901.CartRepository>()),
    );
    gh.lazySingleton<_i783.ApplyPromoCodeUseCase>(
      () => _i783.ApplyPromoCodeUseCase(gh<_i901.CartRepository>()),
    );
    gh.lazySingleton<_i242.GetCartUseCase>(
      () => _i242.GetCartUseCase(gh<_i901.CartRepository>()),
    );
    gh.lazySingleton<_i576.MergeCartUseCase>(
      () => _i576.MergeCartUseCase(gh<_i901.CartRepository>()),
    );
    gh.lazySingleton<_i44.MoveToWishlistUseCase>(
      () => _i44.MoveToWishlistUseCase(gh<_i901.CartRepository>()),
    );
    gh.lazySingleton<_i1036.RemoveCartItemUseCase>(
      () => _i1036.RemoveCartItemUseCase(gh<_i901.CartRepository>()),
    );
    gh.lazySingleton<_i454.RemovePromoCodeUseCase>(
      () => _i454.RemovePromoCodeUseCase(gh<_i901.CartRepository>()),
    );
    gh.lazySingleton<_i231.UpdateCartItemUseCase>(
      () => _i231.UpdateCartItemUseCase(gh<_i901.CartRepository>()),
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
    gh.lazySingleton<_i705.GetAppConfigUseCase>(
      () => _i705.GetAppConfigUseCase(gh<_i68.SplashRepository>()),
    );
    gh.lazySingleton<_i505.GetCustomerInfoUseCase>(
      () => _i505.GetCustomerInfoUseCase(gh<_i68.SplashRepository>()),
    );
    gh.factory<_i643.PlpBloc>(
      () => _i643.PlpBloc(
        getListingDataUseCase: gh<_i1013.GetListingDataUseCase>(),
      ),
    );
    gh.factory<_i833.AddressBloc>(
      () => _i833.AddressBloc(
        gh<_i637.GetAddressesUseCase>(),
        gh<_i277.DeleteAddressUseCase>(),
        gh<_i551.SelectAddressUseCase>(),
        gh<_i1013.AddressCacheManager>(),
      ),
    );
    gh.factory<_i309.PdpBloc>(
      () => _i309.PdpBloc(
        getProductDetailsUseCase: gh<_i59.GetProductDetailsUseCase>(),
        getRecommendationsUseCase: gh<_i69.GetRecommendationsUseCase>(),
        addToCartUseCase: gh<_i163.AddToCartUseCase>(),
        verifyPincodeUseCase: gh<_i197.VerifyPincodeUseCase>(),
        cartCountCubit: gh<_i884.CartCountCubit>(),
        getSizeChartUseCase: gh<_i1001.GetSizeChartUseCase>(),
      ),
    );
    gh.singleton<_i938.WishlistCubit>(
      () => _i938.WishlistCubit(
        gh<_i363.AddToWishlistUseCase>(),
        gh<_i692.RemoveFromWishlistUseCase>(),
      ),
    );
    gh.factory<_i500.OrdersBloc>(
      () => _i500.OrdersBloc(gh<_i834.GetOrdersPageUseCase>()),
    );
    gh.factory<_i724.SearchBloc>(
      () => _i724.SearchBloc(gh<_i938.GetSearchSuggestionsUseCase>()),
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
    gh.factory<_i672.CartBloc>(
      () => _i672.CartBloc(
        getCartUseCase: gh<_i242.GetCartUseCase>(),
        prefManager: gh<_i818.PrefManager>(),
        cartCountCubit: gh<_i884.CartCountCubit>(),
      ),
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
    gh.singleton<_i521.CartActionsCubit>(
      () => _i521.CartActionsCubit(
        gh<_i163.AddToCartUseCase>(),
        gh<_i884.CartCountCubit>(),
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
    gh.lazySingleton<_i283.CheckPincodeUseCase>(
      () => _i283.CheckPincodeUseCase(gh<_i760.PlpRepository>()),
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
    gh.factory<_i113.FilterBloc>(
      () => _i113.FilterBloc(
        getFilterDataUseCase: gh<_i804.GetFilterDataUseCase>(),
        checkPincodeUseCase: gh<_i283.CheckPincodeUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i186.RegisterModule {}
