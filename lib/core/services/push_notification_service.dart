import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../services/pref_manager.dart';
import '../utils/device_utils.dart';
import '../../features/device/domain/usecases/register_device_usecase.dart';

@lazySingleton
class PushNotificationService {
  PushNotificationService(this._registerDevice, this._prefManager);

  final RegisterDeviceUseCase _registerDevice;
  final PrefManager _prefManager;

  Future<void> initialize() async {
    if (kIsWeb) return;
    FirebaseMessaging.instance.onTokenRefresh.listen(_sendToServer);
    await _registerIfNeeded();
  }

  Future<void> reRegister() async {
    if (kIsWeb) return;
    await _prefManager.setPushToken(null);
    await _prefManager.setIsDeviceTokenSent(false);
    await _registerIfNeeded();
  }

  Future<void> _registerIfNeeded() async {
    if (_prefManager.isDeviceTokenSent) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _sendToServer(token);
    } on FirebaseException catch (e, stack) {
      debugPrint('Push token FirebaseException: $e');
      if (await DeviceUtils.isSimulator()) return;
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
    } catch (e, stack) {
      debugPrint('Push token error: $e');
      if (await DeviceUtils.isSimulator()) return;
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
    }
  }

  Future<void> _sendToServer(String token) async {
    final deviceType = Platform.isIOS ? 'ios' : 'android';
    final result = await _registerDevice.call(
      RegisterDeviceParams(deviceToken: token, deviceType: deviceType),
    );
    result.fold((_) {}, (_) async {
      await _prefManager.setIsDeviceTokenSent(true);
      await _prefManager.setPushToken(token);
    });
  }
}
