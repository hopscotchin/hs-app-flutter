import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../../core/di/injection.dart';
import 'bloc/orders_bloc.dart';
import 'pages/orders_page.dart';

class OrdersRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.orders,
    name: 'orders',
    parentNavigatorKey: rootKey,
    builder: (context, state) => BlocProvider(
      create: (_) => sl<OrdersBloc>()..add(const LoadOrders()),
      child: const OrdersPage(),
    ),
  );
}
