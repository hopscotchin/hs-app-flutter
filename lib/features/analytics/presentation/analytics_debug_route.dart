import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import 'pages/analytics_debug_page.dart';

class AnalyticsDebugRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.analyticsDebug,
    name: 'analytics-debug',
    parentNavigatorKey: rootKey,
    builder: (context, state) => const AnalyticsDebugPage(),
  );
}
