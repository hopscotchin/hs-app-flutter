import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hs_app_flutter/core/analytics/analytics_service.dart';

/// Tracks screen navigation events and time spent on each screen.
///
/// Attach to [GoRouter] via the `observers` parameter.
/// Automatically logs:
///   - Screen views to [AnalyticsService]
///   - Time spent on each screen (duration between push/pop)
///
/// Usage:
/// ```dart
/// GoRouter(
///   observers: [AppNavigationObserver(analyticsService: sl())],
///   ...
/// )
/// ```
class AppNavigationObserver extends NavigatorObserver {
  AppNavigationObserver({required AnalyticsService analyticsService})
    : _analyticsService = analyticsService;

  final AnalyticsService _analyticsService;

  final Map<String, DateTime> _screenEntryTimes = {};
  String? _currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logScreenExit(previousRoute);
    _logScreenEntry(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logScreenExit(route);
    _logScreenEntry(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logScreenExit(oldRoute);
    _logScreenEntry(newRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logScreenExit(route);
  }

  void _logScreenEntry(Route<dynamic>? route) {
    final name = _routeName(route);
    if (name == null) return;
    if (kDebugMode) {
      print('Entering route: $name');
    }
    _currentRoute = name;
    _screenEntryTimes[name] = DateTime.now();
    _analyticsService.trackScreenView(name);
  }

  void _logScreenExit(Route<dynamic>? route) {
    final name = _routeName(route);
    if (name == null) return;
    if (kDebugMode) {
      print('Exiting route: $name');
    }
  }

  String? _routeName(Route<dynamic>? route) {
    return route?.settings.name;
  }

  /// The currently active route name, if any.
  String? get currentRoute => _currentRoute;
}
