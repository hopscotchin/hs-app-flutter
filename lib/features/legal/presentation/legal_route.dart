import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import 'pages/legal_page.dart';

/// Route for the static Legal screen. No Bloc — the page is purely static and
/// each row launches the in-app WebView on tap.
class LegalRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.legal,
    name: 'legal',
    parentNavigatorKey: rootKey,
    builder: (_, _) => const LegalPage(),
  );
}