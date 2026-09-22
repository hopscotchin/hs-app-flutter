import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import '../../../core/navigation/nav_destination.dart';
import 'pages/cart_page.dart';

class CartRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.cart,
    name: RouteNames.cartName,
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      // Analytics entry context, when the caller supplied it. Android reads the
      // equivalent off the launching intent (`CartFragment.fromScreen`).
      // Absent only for a push made by path instead of through
      // `AppNavigator.goToCart` — `from_screen` / `from_location` then fall
      // back in `CartBloc`.
      final extra = state.extra;
      return CartPage(
        fromBuyNow: state.uri.queryParameters['fromBuyNow'] == 'true',
        sourcePage: extra is SourcePage ? extra : null,
      );
    },
  );
}
