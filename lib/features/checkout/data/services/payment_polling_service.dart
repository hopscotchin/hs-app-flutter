import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:injectable/injectable.dart';

import 'payment_notification_service.dart';

/// Keeps the app process alive on Android while a payment is being polled,
/// via a foreground service + ongoing "Processing payment…" notification.
/// Mirrors Android's `PaymentProcessingNotificationService` — same intent:
/// the OS should not kill the polling when the user leaves the app.
///
/// The isolated background isolate itself does no API work. Polling stays
/// in [CheckoutBloc]'s main isolate; the foreground service exists solely
/// to prevent Android from suspending that isolate during a short (~30s)
/// backgrounding window. iOS does not honour long-lived background
/// services, so on iOS this class falls back to a persistent notification
/// via [PaymentNotificationService] and the main-isolate poll runs as
/// long as iOS grants it.
@lazySingleton
class PaymentPollingService {
  PaymentPollingService(this._notifications);

  final PaymentNotificationService _notifications;
  final FlutterBackgroundService _service = FlutterBackgroundService();

  bool _configured = false;

  /// Wires the foreground-service entry point + notification channel.
  /// Idempotent — safe to call at cold start.
  Future<void> init() async {
    if (_configured) return;
    _configured = true;
    if (!Platform.isAndroid) return;

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onBackgroundStart,
        autoStart: false,
        isForegroundMode: true,
        autoStartOnBoot: false,
        notificationChannelId: 'payment_processing_channel',
        initialNotificationTitle: 'Processing payment…',
        initialNotificationContent: 'Please keep the app open',
        foregroundServiceNotificationId: 9101,
        foregroundServiceTypes: [AndroidForegroundType.dataSync],
      ),
      // iOS still needs a config block — the service won't actually run for
      // more than iOS's brief background window, so this is a stub.
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onBackgroundStart,
        onBackground: _onIosBackground,
      ),
    );
  }

  /// Show the "Processing payment…" ongoing UI. On Android this starts the
  /// foreground service; on iOS it falls back to a persistent local
  /// notification since a long-lived background service isn't allowed.
  Future<void> startProcessing(int orderId) async {
    if (Platform.isAndroid) {
      if (await _service.isRunning()) return;
      await _service.startService();
    } else {
      // iOS: only the local notification. Main-isolate polling in
      // CheckoutBloc runs for as long as iOS's background window allows.
      await _notifications.showProcessing(orderId);
    }
  }

  /// Terminal — pair with every [startProcessing]. Fires on success /
  /// retry / failure / user-abort and on bloc close.
  Future<void> stopProcessing() async {
    if (Platform.isAndroid) {
      if (!await _service.isRunning()) return;
      _service.invoke('stopService');
    } else {
      // iOS: cancel the persistent processing notification. Result
      // notifications are the caller's responsibility (see
      // [PaymentNotificationService.showSuccess] et al.).
      await _notifications.cancelAll();
    }
  }
}

/// Entry point for the flutter_background_service Android isolate. Kept as
/// a top-level @pragma so tree shaking doesn't drop it; the isolate runs
/// in a fresh Dart VM so nothing from the main isolate is visible here.
@pragma('vm:entry-point')
void _onBackgroundStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  service.on('stopService').listen((_) async {
    await service.stopSelf();
  });
}

/// iOS background fetch handler. Returns true to satisfy the plugin's
/// contract; iOS gates the actual work.
@pragma('vm:entry-point')
Future<bool> _onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}
