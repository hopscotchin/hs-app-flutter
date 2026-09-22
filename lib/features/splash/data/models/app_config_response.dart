import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/network/models/action_response.dart';

/// Typed model for the `/v1/app-config` API response.
///
/// Mirrors Android's `AppConfigResponse` – every field saved to
/// PrefUtils / AppRecordData in the native app is represented here.
class AppConfigResponse extends ActionResponse {
  final bool isHardUpdate;
  final String? dialogTitle;
  final String? dialogContent;
  final String? instantCheckoutVariant;
  final bool isSortBarEnabled;
  final bool isRecentlySortVisible;
  final bool isUPIRefundsEnabled;
  final FeatureFlags? featureFlags;
  final RemoteConfigFlags? remoteConfigFlags;
  final List<String>? customerCareContacts;
  final String? customerCareTiming;
  final String? videoTransformationsJson;
  final String? cartMessageBarsJson;
  final N7Config? n7Config;

  const AppConfigResponse({
    this.isHardUpdate = false,
    this.dialogTitle,
    this.dialogContent,
    this.instantCheckoutVariant,
    this.isSortBarEnabled = false,
    this.isRecentlySortVisible = false,
    this.isUPIRefundsEnabled = false,
    this.featureFlags,
    this.remoteConfigFlags,
    this.customerCareContacts,
    this.customerCareTiming,
    this.videoTransformationsJson,
    this.cartMessageBarsJson,
    this.n7Config,
  });

  String? get firstContact =>
      (customerCareContacts != null && customerCareContacts!.isNotEmpty)
      ? customerCareContacts!.first
      : null;

  AppConfigResponse.fromJson(super.json)
    : isHardUpdate = json['isHardUpdate'] as bool? ?? false,
      dialogTitle = json['dialogTitle'] as String?,
      dialogContent = json['dialogContent'] as String?,
      instantCheckoutVariant = json['instantCheckoutVariant'] as String?,
      isSortBarEnabled = json['isSortBarEnabled'] as bool? ?? false,
      isRecentlySortVisible = json['isRecentlySortVisible'] as bool? ?? false,
      isUPIRefundsEnabled = json['isUPIRefundsEnabled'] as bool? ?? false,
      featureFlags = json['featureFlags'] != null
          ? FeatureFlags.fromJson(json['featureFlags'] as Map<String, dynamic>)
          : null,
      remoteConfigFlags = json['remoteConfigFlags'] != null
          ? RemoteConfigFlags.fromJson(
              json['remoteConfigFlags'] as Map<String, dynamic>,
            )
          : null,
      // The numbers moved under `ccConfig`; `contacts` is kept as a fallback
      // because nothing guarantees every environment has moved with them.
      // Reading only the old key is why customerCareContact was null and the
      // Call Us button did nothing.
      customerCareContacts =
          ((json['ccConfig'] as Map<String, dynamic>?)?['contactNumber']
                  as List<dynamic>? ??
              json['contacts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
      customerCareTiming =
          (json['ccConfig'] as Map<String, dynamic>?)?['contactTiming']
              as String?,
      videoTransformationsJson = _encodeList(json['videoTransformations']),
      cartMessageBarsJson = _encodeList(json['cartMessageBars']),
      n7Config = json['n7Config'] != null
          ? N7Config.fromJson(json['n7Config'] as Map<String, dynamic>)
          : null,
      super.fromJson();

  static String? _encodeList(dynamic value) {
    if (value == null) return null;
    if (value is List) return jsonEncode(value);
    return value.toString();
  }

  @override
  List<Object?> get props => [
    action,
    message,
    isHardUpdate,
    dialogTitle,
    dialogContent,
    instantCheckoutVariant,
    isSortBarEnabled,
    isRecentlySortVisible,
    isUPIRefundsEnabled,
    featureFlags,
    remoteConfigFlags,
    customerCareContacts,
    customerCareTiming,
    videoTransformationsJson,
    cartMessageBarsJson,
    n7Config,
  ];
}

class FeatureFlags extends Equatable {
  final bool clarity;

  const FeatureFlags({this.clarity = true});

  factory FeatureFlags.fromJson(Map<String, dynamic> json) {
    return FeatureFlags(clarity: json['clarity'] as bool? ?? true);
  }

  @override
  List<Object?> get props => [clarity];
}

class RemoteConfigFlags extends Equatable {
  final bool featureInAppUpdateEnabled;
  final bool isRatingAfterShoppingExperienceEnabled;
  final bool isHomepageAnalyticsEnabled;
  final bool featureEnableDeleteAccount;

  const RemoteConfigFlags({
    this.featureInAppUpdateEnabled = true,
    this.isRatingAfterShoppingExperienceEnabled = true,
    this.isHomepageAnalyticsEnabled = true,
    this.featureEnableDeleteAccount = false,
  });

  factory RemoteConfigFlags.fromJson(Map<String, dynamic> json) {
    return RemoteConfigFlags(
      featureInAppUpdateEnabled:
          json['featureInAppUpdateEnabled'] as bool? ?? true,
      isRatingAfterShoppingExperienceEnabled:
          json['isRatingAfterShoppingExperienceEnabled'] as bool? ?? true,
      isHomepageAnalyticsEnabled:
          json['isHomepageAnalyticsEnabled'] as bool? ?? true,
      featureEnableDeleteAccount:
          json['featureEnableDeleteAccountAndroid'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    featureInAppUpdateEnabled,
    isRatingAfterShoppingExperienceEnabled,
    isHomepageAnalyticsEnabled,
    featureEnableDeleteAccount,
  ];
}

class N7Config extends Equatable {
  final bool enabled;
  final String? securityKey;
  final String? hlKey;

  const N7Config({this.enabled = false, this.securityKey, this.hlKey});

  factory N7Config.fromJson(Map<String, dynamic> json) {
    return N7Config(
      enabled: json['enabled'] as bool? ?? false,
      securityKey: json['securityKey'] as String?,
      hlKey: json['hlKey'] as String?,
    );
  }

  @override
  List<Object?> get props => [enabled, securityKey, hlKey];
}
