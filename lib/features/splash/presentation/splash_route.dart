import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import 'pages/splash_page.dart';

class SplashRoute {
  static GoRoute getRoute() => GoRoute(
    path: RouteNames.splash,
    name: 'splash',
    builder: (context, state) => const SplashPage(),
  );
}
