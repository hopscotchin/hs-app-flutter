import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/features/account/presentation/account_route.dart';
import 'package:hs_app_flutter/features/categories/presentation/categories_route.dart';
import 'package:hs_app_flutter/features/dashboard/dashboard.dart';
import 'package:hs_app_flutter/features/discover/discover_route.dart';

final StatefulShellRoute shellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      DashboardPage(navigationShell: navigationShell),
  branches: [
    DiscoverRoute.getBranch(),
    CategoriesRoute.getBranch(),
    AccountRoute.getBranch(),
  ],
);
