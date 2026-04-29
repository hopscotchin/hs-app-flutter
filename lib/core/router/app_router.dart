import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/router/shell_route.dart';
import 'package:hs_app_flutter/features/splash/presentation/splash_route.dart';

import '../constants/route_names.dart';
import 'webview_route.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      SplashRoute.getRoute(),
      shellRoute,
      WebViewRoute.getRoute(_rootNavigatorKey),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
