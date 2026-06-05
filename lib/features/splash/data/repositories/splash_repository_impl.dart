import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../auth/data/models/user_info/user_info_model.dart';
import '../../domain/entities/customer_info_entity.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/remote/splash_remote_datasource.dart';
import '../models/app_config_response.dart';
import '../models/customer_info_model.dart';

@LazySingleton(as: SplashRepository)
class SplashRepositoryImpl with SafeApiCall implements SplashRepository {
  SplashRepositoryImpl(
    this._api,
    this._networkInfo,
    this._prefManager,
    this._networkClient,
  );

  final SplashRemoteDatasource _api;
  final NetworkInfo _networkInfo;
  final PrefManager _prefManager;
  final NetworkClient _networkClient;

  @override
  Future<Either<Failure, Unit>> getAppConfig({
    CancelToken? cancelToken,
  }) =>
      safeApiCall(_networkInfo, () async {
        final config = await _api.getAppConfig(cancelToken: cancelToken);
        await _persistAppConfig(config);
        return unit;
      });

  @override
  Future<Either<Failure, CustomerInfoEntity>> getCustomerInfo({
    CancelToken? cancelToken,
  }) =>
      safeApiCall(_networkInfo, () async {
        final response = await _api.getCustomerInfo(cancelToken: cancelToken);
        final entity = response.toEntity();
        await _persistCustomerInfo(entity);
        return entity;
      });

  Future<void> _persistAppConfig(AppConfigResponse config) async {
    await _prefManager.setIsHardUpdate(config.isHardUpdate);
    await _prefManager.setHardUpdateDialogTitle(config.dialogTitle);
    await _prefManager.setHardUpdateDialogContent(config.dialogContent);
    await _prefManager.setInstantCheckoutVariant(config.instantCheckoutVariant);
    await _prefManager.setSortBarEnabled(config.isSortBarEnabled);
    await _prefManager.setRecentlySortVisible(config.isRecentlySortVisible);
    await _prefManager.setUpiRefundsEnabled(config.isUPIRefundsEnabled);

    final featureFlags = config.featureFlags;
    if (featureFlags != null) {
      await _prefManager.setFeatureFlagClarity(featureFlags.clarity);
    }

    final remoteConfig = config.remoteConfigFlags;
    if (remoteConfig != null) {
      await _prefManager.setFeatureFlagInAppUpdate(remoteConfig.featureInAppUpdateEnabled);
      await _prefManager.setFeatureFlagRatingAfterShopping(remoteConfig.isRatingAfterShoppingExperienceEnabled);
      await _prefManager.setFeatureFlagHomeAnalytics(remoteConfig.isHomepageAnalyticsEnabled);
      await _prefManager.setFeatureFlagDeleteAccount(remoteConfig.featureEnableDeleteAccount);
    }

    await _prefManager.setVideoAspectRatios(config.videoTransformationsJson);
    await _prefManager.setCartMessageBars(config.cartMessageBarsJson);
    await _prefManager.setCustomerCareContact(config.firstContact);

    final n7 = config.n7Config;
    if (n7 != null) {
      _networkClient.setN7HumanDetectorEnabled(n7.enabled);
    }
  }

  Future<void> _persistCustomerInfo(CustomerInfoEntity info) async {
    await _prefManager.setHasGuestData(info.hasGuestData);
    await _prefManager.setCartItemQty(info.cartItemCount);

    final current = _prefManager.customerInfo;
    final user = info.user;

    // Preserve existing auth state for guest-data sessions (isLoggedIn +
    // childCohorts should not be overwritten when hasGuestData=true and
    // the user is not actively logging in or out).
    if (info.isLoggedIn) {
      final cohorts = info.childCohorts;
      await _prefManager.setChildCohorts(
        cohorts != null && cohorts.isNotEmpty ? jsonEncode(cohorts) : null,
      );
    } else if (!info.hasGuestData) {
      await _prefManager.setChildCohorts(null);
    }

    final auth = info.auth;
    if (auth != null) await _prefManager.setUuid(auth.uuid);

    final userConfig = info.userConfig;
    if (userConfig != null) {
      await _prefManager.setContinueBrowsingEligibleVisitor(
        userConfig.continueBrowsingEligibleVisitor,
      );
    }

    await _prefManager.setCustomerInfo(
      UserInfoModel.fromJson({
        ...?current?.toJson(),
        if (user != null) ...UserInfoModel.fromEntity(user).toJson(),
        'isLoggedIn': info.isLoggedIn,
      }),
    );
  }
}
