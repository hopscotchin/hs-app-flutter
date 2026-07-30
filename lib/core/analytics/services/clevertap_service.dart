import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../services/pref_manager.dart';

/// Fetches `cleverTapId` and mirrors it into `PrefManager` + Firebase
/// Analytics `ct_objectId` user property. Native SDK is auto-initialised
/// from Android manifest / iOS plist.
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
