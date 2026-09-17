import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../services/pref_manager.dart';
import '../constants/analytics_properties.dart';

/// Fetches `cleverTapId` and mirrors it into `PrefManager` + Firebase
/// Analytics `ct_objectId` user property. Native SDK is auto-initialised
/// from Android manifest / iOS plist.
///
/// Also owns [identifyOnUserLogin], the CleverTap counterpart to Segment's
/// `identify`. The two are separate systems: Segment's identify attaches
/// traits to the current user, while CleverTap's `onUserLogin` *switches
/// profiles* — it creates a new one, or resumes an existing one, keyed by
/// `Identity`. Without it every signed-in session keeps writing to the
/// anonymous profile, so CleverTap journeys never see a real user.
@lazySingleton
class CleverTapService {
  CleverTapService(this._prefs);

  final PrefManager _prefs;

  Future<void> init() async {
    try {
      CleverTapPlugin.setDebugLevel(kDebugMode ? 3 : 0);
      await _refreshCleverTapId();
    } catch (e) {
      if (kDebugMode) debugPrint('[CleverTapService] init failed: $e');
    }
  }

  /// Creates or switches to the CleverTap profile for this user. Mirrors
  /// Android `CleverTapHelper.identifyUserOnLogin` /
  /// `Util.setUserProfileOnCleverTap`, both of which call
  /// `CleverTapAPI.onUserLogin(profile)` after a successful auth.
  ///
  /// Empty values are omitted rather than sent: `onUserLogin` merges into the
  /// profile it resolves, so writing a blank would overwrite a good value that
  /// a previous session or a CRM import had already set.
  ///
  /// Never rethrows — a CleverTap failure must not fail a login. The
  /// [_refreshCleverTapId] at the end is not optional: resolving a different
  /// profile can allocate a new CleverTap id, and the stale one would then be
  /// stamped on every subsequent Segment call.
  Future<void> identifyOnUserLogin({
    String? userId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
  }) async {
    final profile = <String, dynamic>{
      AnalyticsProperties.cleverTapTz: AnalyticsProperties.cleverTapAsiaKolkata,
      AnalyticsProperties.cleverTapMsgPush: true,
      AnalyticsProperties.cleverTapMsgEmail: true,
      AnalyticsProperties.cleverTapMsgSms: true,
    };
    void put(String key, String? value) {
      if (value != null && value.isNotEmpty) profile[key] = value;
    }

    put(AnalyticsProperties.cleverTapIdentity, userId);
    put(AnalyticsProperties.cleverTapEmail, email);
    put(AnalyticsProperties.cleverTapPhone, phone);
    put(AnalyticsProperties.cleverTapFirstName, firstName);
    put(AnalyticsProperties.cleverTapLastName, lastName);

    try {
      await CleverTapPlugin.onUserLogin(profile);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CleverTapService] onUserLogin failed: $e');
      }
    }
    await _refreshCleverTapId();
  }

  Future<void> _refreshCleverTapId() async {
    final id = await CleverTapPlugin.getCleverTapID();
    if (id == null || id.isEmpty) return;
    await _prefs.setCleverTapId(id);
    if (!kIsWeb) {
      try {
        await FirebaseAnalytics.instance.setUserProperty(
          name: 'ct_objectId',
          value: id,
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[CleverTapService] setUserProperty ct_objectId failed: $e');
        }
      }
    }
  }
}
