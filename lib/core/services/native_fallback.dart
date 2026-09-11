import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Escape hatch out of the Flutter app and back into the native Android app.
///
/// When this app runs embedded in hs-app-android (add-to-app), `HsFlutterActivity`
/// listens on [_channel]. Calling [bail] makes it disable the Flutter hand-off for
/// the current app version and restart into the native SplashActivity, so a user
/// who hits an unrecoverable Flutter error lands in the working native app
/// instead of a blank screen.
///
/// Anywhere there is no native host - iOS, web, `flutter run` against this
/// project's own android/ host - the channel simply is not registered and [bail]
/// is a no-op.
class NativeFallback {
  NativeFallback._();

  /// Must match HsFlutterActivity.CHANNEL in hs-app-android.
  static const _channel = MethodChannel('in.hopscotch.android/native_fallback');

  static bool _bailing = false;

  /// Set once the app has painted. Errors before this are startup failures and
  /// bail; errors after it are reported but tolerated, because tearing a running
  /// session down loses the user's place and a stray RenderFlex overflow is not a
  /// reason to switch apps.
  static bool hasRenderedFirstFrame = false;

  /// The bail-out policy, in one place. Default: only startup failures.
  ///
  /// Change to `=> true` to bail on *any* unhandled error, at the cost of
  /// throwing a user out of a working session - one stray unawaited future or
  /// RenderFlex overflow would then relaunch them into the native app.
  static bool get shouldBail => !hasRenderedFirstFrame;

  /// Hands the session back to the native app. Safe to call more than once and
  /// safe to call where no native host exists.
  static Future<void> bail(String reason) async {
    if (_bailing) return;
    _bailing = true;
    debugPrint('NativeFallback: handing back to native — $reason');
    try {
      await _channel.invokeMethod<void>('fallbackToNative', {'reason': reason});
    } on Object catch (error) {
      // MissingPluginException on any host that does not implement the channel.
      // Nothing to fall back to, so let the app carry on with the error visible.
      _bailing = false;
      debugPrint('NativeFallback: no native host to fall back to ($error)');
    }
  }
}
