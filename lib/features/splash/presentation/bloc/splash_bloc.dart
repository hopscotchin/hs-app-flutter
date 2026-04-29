import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/services/pref_manager.dart';
import '../../data/models/app_config_response.dart';
import '../../data/models/customer_info_response.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final NetworkClient networkClient;
  final PrefManager prefManager;

  SplashBloc({
    required this.networkClient,
    required this.prefManager
  }) : super(SplashInitial()) {
    on<InitializeApp>(_onInitializeApp);
    on<SelectEnvironment>(_onSelectEnvironment);
  }

  Future<void> _onInitializeApp(
    InitializeApp event,
    Emitter<SplashState> emit,
  ) async {
    // In debug mode, show environment selector first
    if (!kReleaseMode) {
      emit(SplashEnvironmentSelection(
        currentEnvironment: EnvironmentConfig.current,
      ));
      return;
    }

    // In release mode, go straight to fetching
    await _fetchInitialData(emit);
  }

  Future<void> _onSelectEnvironment(
    SelectEnvironment event,
    Emitter<SplashState> emit,
  ) async {
    EnvironmentConfig.setEnvironment(event.environment);
    networkClient.onEnvironmentChanged();
    await _fetchInitialData(emit);
  }

  Future<void> _fetchInitialData(Emitter<SplashState> emit) async {
    emit(const SplashLoading(step: SplashLoadingStep.fetchingAppConfig));

    try {
      // Fire both APIs in parallel (mirrors Android's supervisorScope)
      final results = await Future.wait([
        _fetchAppConfig(),
        _fetchCustomerInfo(),
      ], eagerError: false);

      final appConfig = results[0] as AppConfigResponse?;
      final customerInfo = results[1] as CustomerInfoResponse?;

      // Persist to PrefManager (mirrors Android's processAppConfigResponse
      // + UserUtil.saveUserInfo)
      if (appConfig != null) {
        await _processAppConfig(appConfig);
      }
      if (customerInfo != null) {
        await _processCustomerInfo(customerInfo);
      }

      emit(SplashLoaded(
        appConfig: appConfig,
        customerInfo: customerInfo,
      ));
    } catch (e) {
      emit(SplashError(
        message: e.toString(),
        errorType: _getErrorType(e),
      ));
    }
  }

  Future<AppConfigResponse?> _fetchAppConfig() async {
    try {
      final response =
          await networkClient.apiClient.get(ApiConstants.appConfig);
      final json = response.data as Map<String, dynamic>;
      return AppConfigResponse.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<CustomerInfoResponse?> _fetchCustomerInfo() async {
    try {
      final response =
          await networkClient.apiClient.get(ApiConstants.customerInfo);
      final json = response.data as Map<String, dynamic>;
      return CustomerInfoResponse.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Saves AppConfig data to PrefManager.
  ///
  /// Mirrors Android's `SplashActivity.processAppConfigResponse`.
  Future<void> _processAppConfig(AppConfigResponse config) async {
    // Hard update flags
    await prefManager.setIsHardUpdate(config.isHardUpdate);
    await prefManager.setHardUpdateDialogTitle(config.dialogTitle);
    await prefManager.setHardUpdateDialogContent(config.dialogContent);

    // Sort & checkout settings
    await prefManager.setInstantCheckoutVariant(config.instantCheckoutVariant);
    await prefManager.setSortBarEnabled(config.isSortBarEnabled);
    await prefManager.setRecentlySortVisible(config.isRecentlySortVisible);
    await prefManager.setUpiRefundsEnabled(config.isUPIRefundsEnabled);

    // Feature flags
    final featureFlags = config.featureFlags;
    if (featureFlags != null) {
      await prefManager.setFeatureFlagClarity(featureFlags.clarity);
    }

    // Remote config flags
    final remoteConfig = config.remoteConfigFlags;
    if (remoteConfig != null) {
      await prefManager
          .setFeatureFlagInAppUpdate(remoteConfig.featureInAppUpdateEnabled);
      await prefManager.setFeatureFlagRatingAfterShopping(
          remoteConfig.isRatingAfterShoppingExperienceEnabled);
      await prefManager
          .setFeatureFlagHomeAnalytics(remoteConfig.isHomepageAnalyticsEnabled);
      await prefManager
          .setFeatureFlagDeleteAccount(remoteConfig.featureEnableDeleteAccount);
    }

    // JSON blobs
    await prefManager.setVideoAspectRatios(config.videoTransformationsJson);
    await prefManager.setCartMessageBars(config.cartMessageBarsJson);

    // Customer care contact
    await prefManager.setCustomerCareContact(config.firstContact);

    // N7 human detection config → configure on NetworkClient
    final n7 = config.n7Config;
    if (n7 != null) {
      networkClient.setN7HumanDetectorEnabled(n7.enabled);
    }
  }

  /// Saves customer info to PrefManager and configures auth.
  ///
  /// Mirrors Android's `UserUtil.saveUserInfo`.
  Future<void> _processCustomerInfo(CustomerInfoResponse info) async {
    await prefManager.setHasGuestData(info.hasGuestData);
    await prefManager.setCartItemQty(info.cartItemQty);
    await prefManager.setPhoneNumber(info.phoneNumber);
    await prefManager.setUserName(info.userName);
    await prefManager.setFirstName(info.firstName);
    await prefManager.setLastName(info.lastName);
    await prefManager.setGender(info.gender);

    if (info.isLoggedIn) {
      await prefManager.setIsLoggedIn(true);
      await prefManager.setUserId(info.userId);
      await prefManager.setProfileImage(info.profileImage);
      await prefManager.setEmail(info.email);
      await prefManager.setMobileStatus(info.mobileStatus);
    } else {
      // Not logged in – clear login-specific data
      if (!info.hasGuestData) {
        await prefManager.setIsLoggedIn(false);
      }
    }

    // Persist ticket to SharedPreferences and set on network layer
    if (info.persistentTicket != null &&
        info.persistentTicket!.isNotEmpty) {
      await prefManager.setPersistentTicket(info.persistentTicket);
      networkClient.setPersistentTicket(info.persistentTicket);
    }
  }

  SplashErrorType _getErrorType(dynamic error) {
    if (error is ConnectionException || error is TimeoutException) {
      return SplashErrorType.network;
    }
    if (error is NetworkException) return SplashErrorType.network;
    if (error is ServerException) return SplashErrorType.appConfig;
    return SplashErrorType.unknown;
  }
}
