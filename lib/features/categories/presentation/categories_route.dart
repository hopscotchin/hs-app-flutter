import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import 'pages/categories_page.dart';

class CategoriesRoute {
  static StatefulShellBranch getBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteNames.categories,
        name: 'categories',
        builder: (context, state) => const CategoriesPage(),
      ),
    ],
  );
}
