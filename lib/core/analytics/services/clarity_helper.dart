import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../config/env_config.dart';
import '../../services/pref_manager.dart';

/// Feature-flag-gated Microsoft Clarity wrapper. [wrap] returns a
/// [ClarityWidget] when enabled, else a passthrough. All setters no-op
/// when [isEnabled] is false.
@lazySingleton
class ClarityHelper {
  ClarityHelper(this._prefs, this._packageInfo);

  final PrefManager _prefs;
  final PackageInfo _packageInfo;

  static const String tagPid = 'pId';
  static const String tagPlpId = 'plpId';
  static const String tagBoutiqueId = 'boutiqueId';
  static const String tagAppVersion = 'appVersion';
  static const String tagUtmSource = 'utmSource';
  static const String tagUtmMedium = 'utmMedium';
  static const String tagUtmCampaign = 'utmCampaign';
  static const String tagUserType = 'user_type';

  /// True when the SDK should actually receive calls. Guards the feature
  /// flag, presence of a project id, and platform support.
  bool get isEnabled {
    if (kIsWeb) return false;
    if (!_prefs.featureFlagClarity) return false;
    if (EnvConfig.clarityProjectId.isEmpty) return false;
    return true;
  }

  /// Wraps [app] in a [ClarityWidget] that initialises the SDK and stamps
  /// `appVersion` on mount. Returns [app] unchanged when disabled.
  Widget wrap(Widget app) {
    if (!isEnabled) return app;
    return ClarityWidget(
      app: _AppVersionTagOnMount(
        packageInfo: _packageInfo,
        child: app,
      ),
      clarityConfig: ClarityConfig(
        projectId: EnvConfig.clarityProjectId,
        logLevel: kDebugMode ? LogLevel.None : LogLevel.None,
      ),
    );
  }

  void setUserId(String userId) {
    if (!isEnabled || userId.isEmpty) return;
    try {
      Clarity.setCustomUserId(userId);
    } catch (e) {
      if (kDebugMode) debugPrint('[ClarityHelper] setUserId failed: $e');
    }
  }

  void setUserType(String? userType) {
    if (!isEnabled || userType == null || userType.isEmpty) return;
    _setTag(tagUserType, userType);
  }

  void setUtmInfo({String? utmSource, String? utmMedium, String? utmCampaign}) {
    if (!isEnabled) return;
    if (utmSource != null && utmSource.isNotEmpty) {
      _setTag(tagUtmSource, utmSource);
    }
    if (utmMedium != null && utmMedium.isNotEmpty) {
      _setTag(tagUtmMedium, utmMedium);
    }
    if (utmCampaign != null && utmCampaign.isNotEmpty) {
      _setTag(tagUtmCampaign, utmCampaign);
    }
  }

  /// Page-scoped tag. Caller pairs with a re-tag-to-empty on leave.
  void setPageTag(String key, String? value) {
    if (!isEnabled || key.isEmpty || value == null || value.isEmpty) return;
    _setTag(key, value);
  }

  /// One `exp_<name>` tag per experiment.
  void addExperiment(String name, String value) {
    if (!isEnabled || name.isEmpty || value.isEmpty) return;
    _setTag('exp_$name', value);
  }

  void _setTag(String key, String value) {
    try {
      Clarity.setCustomTag(key, value);
    } catch (e) {
      if (kDebugMode) debugPrint('[ClarityHelper] setCustomTag($key) failed: $e');
    }
  }
}

/// Stamps `appVersion` in `initState`; wraps one level below `ClarityWidget`
/// so the SDK is guaranteed initialised before the tag write.
class _AppVersionTagOnMount extends StatefulWidget {
  const _AppVersionTagOnMount({required this.packageInfo, required this.child});

  final PackageInfo packageInfo;
  final Widget child;

  @override
  State<_AppVersionTagOnMount> createState() => _AppVersionTagOnMountState();
}

class _AppVersionTagOnMountState extends State<_AppVersionTagOnMount> {
  @override
  void initState() {
    super.initState();
    try {
      Clarity.setCustomTag(
        ClarityHelper.tagAppVersion,
        widget.packageInfo.version,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[ClarityHelper] appVersion tag failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
