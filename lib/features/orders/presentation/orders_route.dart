import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/constants/analytics_defaults.dart';
import '../../../core/analytics/events/analytics_helper.dart';
import '../../../core/constants/route_names.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/pref_manager.dart';
import '../domain/entities/orders_entry_args.dart';
import '../domain/entities/orders_tab.dart';
import 'listing/bloc/orders_listing_bloc.dart';
import 'listing/pages/orders_listing_page.dart';

/// Key under which [OrdersEntryArgs] travels in a route's `extra` map.
///
/// A constant rather than a literal so producer and consumer cannot drift — a
/// typo would silently drop the entry context, and `from_screen` would quietly
/// fall back to its default on every event.
const String ordersEntryArgsKey = 'ordersEntryArgs';

/// Every route the orders module owns.
///
/// `getRoutes` rather than `getRoute` because details, return, exchange and
/// track land here next — the same shape auth already uses for its three
/// screens.
class OrdersRoute {
  static List<GoRoute> getRoutes(GlobalKey<NavigatorState> rootKey) => [
    GoRoute(
      path: RouteNames.orders,
      name: 'orders',
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final entryArgs =
            extra?[ordersEntryArgsKey] as OrdersEntryArgs? ??
            const OrdersEntryArgs(fromScreen: FromScreens.account);

        return BlocProvider(
          // One bloc for both tabs. The rule that BlocProvider lives only in
          // the route file is what rules out a provider per tab inside the
          // TabBarView — so the bloc keeps a state per tab instead.
          create: (_) => sl<OrdersListingBloc>()
            ..entryArgs = entryArgs
            ..add(const OrdersListingEvent.load(OrdersTab.orders)),
          // The Gift Cards tab loads on first visit, not here: firing both
          // requests on entry would put a call on the wire for a tab the user
          // may never open.
          child: OrdersListingPage(
            analytics: sl<AnalyticsHelper>(),
            customerCareNumber: sl<PrefManager>().customerCareContact,
          ),
        );
      },
    ),
  ];
}
