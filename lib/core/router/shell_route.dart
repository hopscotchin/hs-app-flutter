import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/features/account/presentation/account_route.dart';
import 'package:hs_app_flutter/features/cart/presentation/cart_route.dart';
import 'package:hs_app_flutter/features/categories/presentation/categories_route.dart';
import 'package:hs_app_flutter/features/discover/discover_route.dart';
import 'package:hs_app_flutter/features/main/presentation/pages/main_shell_page.dart';
import 'package:hs_app_flutter/features/moments/presentation/moments_route.dart';

final StatefulShellRoute shellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      MainShellPage(navigationShell: navigationShell),
  branches: [
    DiscoverRoute.getBranch(),
    CategoriesRoute.getBranch(),
    MomentsRoute.getBranch(),
    AccountRoute.getBranch(),
    CartRoute.getBranch(),
  ],
);
