import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import 'pages/cart_page.dart';

class CartRoute {
  static StatefulShellBranch getBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteNames.cart,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
    ],
  );
}
