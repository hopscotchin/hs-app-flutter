import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import 'pages/account_page.dart';

class AccountRoute {
  static StatefulShellBranch getBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteNames.account,
        name: 'account',
        builder: (context, state) => const AccountPage(),
      ),
    ],
  );
}
