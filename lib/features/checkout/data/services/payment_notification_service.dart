import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

/// The tap-payload contract carried on payment notifications. Encoded as
/// JSON on the wire so `NotificationResponse.payload` (a String) can round-
/// trip it. Deep-linked from the notification tap → the app's router.
enum PaymentNotificationAction { none, orderConfirmation, paymentRetry }

class PaymentNotificationTap {
  final PaymentNotificationAction action;
  final int orderId;

  const PaymentNotificationTap({required this.action, required this.orderId});

  Map<String, dynamic> toJson() => {'action': action.name, 'orderId': orderId};

  static PaymentNotificationTap? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final actionName = decoded['action'] as String?;
      final orderId = decoded['orderId'];
      if (actionName == null || orderId is! int) return null;
      final action = PaymentNotificationAction.values.firstWhere(
        (a) => a.name == actionName,
        orElse: () => PaymentNotificationAction.none,
      );
      return PaymentNotificationTap(action: action, orderId: orderId);
    } catch (_) {
      return null;
    }
  }
}

/// Foreground-facing notifications during payment. Mirrors Android's
/// `LocalNotificationHelper.showPaymentSuccess` / `showPaymentFailure`
/// callbacks fired from `PaymentProcessingNotificationService`.
///
/// Notification IDs:
///  * [_processingId] — a single sticky notification updated in place while
///    polling; canceled when the flow ends. Matches Android's foreground-
///    service ongoing notification.
///  * [_resultId] — the terminal outcome (success / retry / failure)
///    surfaced when polling completes; auto-dismisses on tap.
///
/// Payload shape: JSON `{action, orderId}` — see [PaymentNotificationTap].
@lazySingleton
class PaymentNotificationService {
  static const _channelId = 'payment_processing_channel';
  static const _channelName = 'Payment Processing';
  static const _channelDescription =
      'Shows status while a payment is being processed.';
  static const _processingId = 9101;
  static const _resultId = 9102;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final _tapController = StreamController<PaymentNotificationTap>.broadcast();

  /// Stream of taps on payment notifications — router listens and routes to
  /// order confirmation / retry accordingly. Broadcast so multiple listeners
  /// can attach without racing.
  Stream<PaymentNotificationTap> get taps => _tapController.stream;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Permissions requested lazily via [requestPermissions] rather than at
    // init — matches Android 13+ POST_NOTIFICATIONS runtime pattern and
    // avoids surfacing an iOS prompt on cold start of every user.
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onTap,
    );

    // Android needs an explicit channel creation before showing notifications
    // on 8.0+. Silent low-importance so it doesn't buzz — payment polling
    // isn't an interruption, just information.
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.low,
            playSound: false,
            enableVibration: false,
          ),
        );

    // On cold start, if the app was launched by tapping a notification,
    // deliver that tap immediately so the router can route.
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final tap = PaymentNotificationTap.tryParse(
        launchDetails?.notificationResponse?.payload,
      );
      if (tap != null) _tapController.add(tap);
    }
  }

  /// Requests notification perms. Android 13+ shows a runtime prompt; iOS
  /// shows the standard alert/badge/sound dialog. Call from [CheckoutBloc]
  /// just before starting polling so the ask lands in context.
  Future<bool> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidGranted = await android?.requestNotificationsPermission();

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted = await ios?.requestPermissions(
      alert: true,
      badge: false,
      sound: false,
    );

    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Sticky "Processing payment…" notification shown for the whole polling
  /// window. Ongoing + autoCancel false so the user can't accidentally
  /// dismiss it mid-flow.
  Future<void> showProcessing(int orderId) {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: false,
      ),
    );
    return _plugin.show(
      _processingId,
      'Processing payment…',
      'Please keep the app open',
      details,
      payload: jsonEncode(
        PaymentNotificationTap(
          action: PaymentNotificationAction.none,
          orderId: orderId,
        ).toJson(),
      ),
    );
  }

  Future<void> showSuccess(int orderId) {
    _cancelProcessing();
    return _showResult(
      title: 'Payment successful',
      body: 'Tap to view your order confirmation.',
      action: PaymentNotificationAction.orderConfirmation,
      orderId: orderId,
    );
  }

  Future<void> showRetry(int orderId) {
    _cancelProcessing();
    return _showResult(
      title: 'Payment needs another attempt',
      body: 'Tap to retry.',
      action: PaymentNotificationAction.paymentRetry,
      orderId: orderId,
    );
  }

  Future<void> showFailure(int orderId, {String? message}) {
    _cancelProcessing();
    return _showResult(
      title: 'Payment failed',
      body: message ?? 'Your order could not be placed.',
      action: PaymentNotificationAction.none,
      orderId: orderId,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancel(_processingId);
    await _plugin.cancel(_resultId);
  }

  // ─── internals ────────────────────────────────────────────────────────

  void _cancelProcessing() {
    unawaited(_plugin.cancel(_processingId));
  }

  Future<void> _showResult({
    required String title,
    required String body,
    required PaymentNotificationAction action,
    required int orderId,
  }) {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        autoCancel: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: false,
      ),
    );
    return _plugin.show(
      _resultId,
      title,
      body,
      details,
      payload: jsonEncode(
        PaymentNotificationTap(action: action, orderId: orderId).toJson(),
      ),
    );
  }

  void _onTap(NotificationResponse response) {
    final tap = PaymentNotificationTap.tryParse(response.payload);
    if (tap != null) _tapController.add(tap);
  }
}
