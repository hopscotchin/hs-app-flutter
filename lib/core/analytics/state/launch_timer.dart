import 'package:injectable/injectable.dart';

/// Cold-start anchor for `tti` / `ttl` / `install_type` / `from_source`.
/// Runtime-only; consumed by the first viewable screen's `logAppLaunched`.
///
/// `ttl` stamps when the first non-splash route commits to the Navigator
/// via `AppNavigationObserver.didPush` — matches Android's `logTTL` firing
/// from `Activity.onCreate` (route/screen object created, about to render;
/// pre-paint on both platforms).
@lazySingleton
class LaunchTimer {
  LaunchTimer();

  final Stopwatch _stopwatch = Stopwatch();
  int _tti = 0;
  int _ttl = 0;
  bool _isStopped = true;
  String? launchSource;
  String? installType;

  /// Anchor process start; called once from `main()`.
  void recordProcessStart() {
    _stopwatch
      ..reset()
      ..start();
    _isStopped = false;
  }

  void logTti() {
    if (_isStopped) return;
    _tti = _stopwatch.elapsedMilliseconds;
  }

  /// Stamp `ttl` on the first non-splash route commit. Idempotent — the
  /// first real push wins; subsequent screen pushes during the same cold
  /// start (PDP/LP/etc. before `app_launched` fires) don't overwrite.
  /// Reset to 0 by [stop] so the next cold start (hot restart / logout
  /// re-entry) starts fresh.
  void logTtl() {
    if (_isStopped || _ttl != 0) return;
    _ttl = _stopwatch.elapsedMilliseconds;
  }

  int get tti => _tti;
  int get ttl => _ttl;
  bool get isStopped => _isStopped;

  /// Consume the launch. Subsequent [logAppLaunched] callsites see this
  /// stopped state and no-op.
  void stop() {
    _stopwatch.stop();
    _stopwatch.reset();
    _tti = 0;
    _ttl = 0;
    installType = null;
    launchSource = null;
    _isStopped = true;
  }
}
