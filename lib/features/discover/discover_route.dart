import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/features/dashboard/back_to_exit_scope.dart';

import 'presentation/pages/discover_page.dart';

class DiscoverRoute {
  static StatefulShellBranch getBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) =>
            const BackToExitScope(child: DiscoverPage()),
      ),
    ],
  );
}
