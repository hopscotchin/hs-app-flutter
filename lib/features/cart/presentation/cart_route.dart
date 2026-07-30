import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import 'pages/cart_page.dart';

class CartRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.cart,
    name: RouteNames.cartName,
    parentNavigatorKey: rootKey,
    builder: (context, state) => const CartPage(),
  );
}
