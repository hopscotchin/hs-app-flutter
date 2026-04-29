import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import 'pages/moments_page.dart';

class MomentsRoute {
  static StatefulShellBranch getBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteNames.moments,
        name: 'moments',
        builder: (context, state) => const MomentsPage(),
      ),
    ],
  );
}
