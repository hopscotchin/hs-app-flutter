import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/analytics/analytics_service.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/core/router/navigation_observer.dart';
import 'package:hs_app_flutter/core/router/shell_route.dart';
import 'package:hs_app_flutter/features/address/presentation/address_route.dart';
import 'package:hs_app_flutter/features/auth/presentation/auth_route.dart';
import 'package:hs_app_flutter/features/landing_page/presentation/landing_page_route.dart';
import 'package:hs_app_flutter/features/legal/presentation/legal_route.dart';
import 'package:hs_app_flutter/features/plp/presentation/plp_route.dart';
import 'package:hs_app_flutter/features/search/presentation/search_route.dart';
import 'package:hs_app_flutter/features/splash/presentation/splash_route.dart';

import '../constants/route_names.dart';
import 'webview_route.dart';

class AppRouter {
  AppRouter._();

  static final _navigationObserver = AppNavigationObserver(
    analyticsService: sl<AnalyticsService>(),
  );
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navigatorKey => _rootNavigatorKey;

  /// Exposed so [MaterialApp.router] can attach it for analytics.
  static AppNavigationObserver get navigationObserver => _navigationObserver;

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    observers: [_navigationObserver],
    routes: [
      SplashRoute.getRoute(),
      shellRoute,
      ...AuthRoute.getRoutes(_rootNavigatorKey),
      PlpRoute.getRoute(_rootNavigatorKey),
      SearchRoute.getRoute(_rootNavigatorKey),
      WebViewRoute.getRoute(_rootNavigatorKey),
      LandingPageRoute.getRoute(_rootNavigatorKey),
      AddressRoute.getRoute(_rootNavigatorKey),
      LegalRoute.getRoute(_rootNavigatorKey),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
