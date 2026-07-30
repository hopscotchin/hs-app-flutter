import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:android_id/android_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../services/pref_manager.dart';

/// Boot-time device probes for the `application_opened` payload:
/// `push_enabled`, `device_profile`, `hs_device_id`, and (deferred)
/// `advertisingId`.
///
/// `hs_device_id` resolves per-platform: Android `Settings.Secure.ANDROID_ID`,
/// iOS Keychain → identifierForVendor (Keychain entry survives reinstall).
@lazySingleton
class DeviceProbeService {
  DeviceProbeService(this._prefs, this._deviceInfo);

  final PrefManager _prefs;
  final DeviceInfoPlugin _deviceInfo;

  /// Fast, non-UI probes. Await before the first `identifyAnonymous` so
  /// `hs_device_id` lands on the first identify.
  Future<void> probe() => Future.wait<void>(<Future<void>>[
        _probePushEnabled(),
        _probeDeviceProfile(),
        _probeHsDeviceId(),
      ]);

  /// Advertising id — presents the ATT prompt on iOS. Caller decides whether
  /// to await (blocks cold-start) or fire-and-forget.
  Future<void> probeAdvertisingId() => _probeAdvertisingId();

  static const _secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _kSecureHsDeviceIdKey = 'hs_device_id_keychain';

  Future<void> _probeHsDeviceId() async {
    try {
      String? id;
      if (defaultTargetPlatform == TargetPlatform.android) {
        id = await const AndroidId().getId();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        id = await _secureStorage.read(key: _kSecureHsDeviceIdKey);
        if (id == null || id.isEmpty) {
          // Fall back to identifierForVendor on first install. Persist
          // immediately so subsequent reinstalls read from Keychain.
          final info = await _deviceInfo.iosInfo;
          id = info.identifierForVendor;
          if (id != null && id.isNotEmpty) {
            await _secureStorage.write(
              key: _kSecureHsDeviceIdKey,
              value: id,
            );
          }
        }
      }
      if (id != null && id.isNotEmpty) {
        await _prefs.setHsDeviceId(id);
      }
    } catch (_) {
      // Leave PrefManager value as-is; AnalyticsHelper falls back to the
      // empty-string trait — same shape native Android sends on devices
      // that return null for ANDROID_ID.
    }
  }

  /// Requests ATT on iOS then reads IDFA / GAID. Empty on denial.
  Future<void> _probeAdvertisingId() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      }
      final raw = await AdvertisingId.id(true);
      final id = raw ?? '';
      if (id.isNotEmpty && id != '00000000-0000-0000-0000-000000000000') {
        await _prefs.setAdvertisingId(id);
      } else {
        await _prefs.setAdvertisingId(null);
      }
    } catch (_) {
      await _prefs.setAdvertisingId(null);
    }
  }

  Future<void> _probePushEnabled() async {
    if (kIsWeb) {
      await _prefs.setPushEnabledAnalytics(false);
      return;
    }
    try {
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      final allowed = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      await _prefs.setPushEnabledAnalytics(allowed);
    } catch (_) {
      await _prefs.setPushEnabledAnalytics(false);
    }
  }

  Future<void> _probeDeviceProfile() async {
    if (_prefs.isDeviceProfileSet) return;
    try {
      // Android uses `com.facebook.device.yearclass.YearClass` which reads
      // RAM + CPU clock + cores → a "year class" bucket. `device_info_plus`
      // doesn't expose RAM, so bucket by CPU-core count instead — cheap
      // stdlib probe, correlates roughly with device tier:
      //   • older / entry-level Android phones ship 4 cores (or fewer);
      //   • mid-range 5-6;
      //   • flagship + all modern iOS 8+.
      // Not identical to YearClass but gives real signal — beats the prior
      // `sdkInt < 19` check which was constant-valued for every device
      // shipped post-2013. Buckets match Android's LOW/MEDIUM/NORMAL_PROFILE
      // wire values.
      final cores = Platform.numberOfProcessors;
      final profile = cores <= 4
          ? 'low'
          : cores <= 6
              ? 'medium'
              : 'normal';
      await _prefs.setDeviceProfile(profile);
      await _prefs.setIsDeviceProfileSet(true);
    } catch (_) {
      await _prefs.setDeviceProfile('normal');
      await _prefs.setIsDeviceProfileSet(true);
    }
  }
}
