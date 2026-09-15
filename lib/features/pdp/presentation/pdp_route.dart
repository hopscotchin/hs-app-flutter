import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import '../domain/entities/pdp_entry_args.dart';
import '../../../core/analytics/pdp/pdp_analytics_tracker.dart';
import 'bloc/pdp_bloc.dart';
import 'pages/pdp_page.dart';

class PdpRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.pdp,
    name: 'pdp',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      final productId = int.parse(state.pathParameters['productId']!);

      // The analytics entry context, or defaults for a deeplink-style open.
      final args = state.extra is PdpEntryArgs
          ? state.extra! as PdpEntryArgs
          : const PdpEntryArgs();

      // ONE tracker per PDP route, owned by the provider.
      //
      // It holds per-visit suppression state (size-change guard, once-per-PID
      // flags, scroll high-water marks), so the Bloc and the widgets must share
      // the *same* instance — two would split the state and silently drop the
      // widget-side events. Mirrors Android, where `PDPAnalytics` is owned by
      // the ViewModel and handed to the views.
      //
      // **`create:`, never `.value`.** GoRouter re-runs this builder on every
      // navigation event, so `sl<PdpAnalyticsTracker>()` at builder scope mints
      // a fresh tracker each time a route is pushed or popped above the PDP —
      // one with no product loaded. `create` is invoked once per element and
      // survives those rebuilds, which is the lifetime the tracker needs.
      // `RepositoryProvider.value` documents the same rule: it is for objects
      // created elsewhere, never for one constructed inline.
      return RepositoryProvider<PdpAnalyticsTracker>(
        create: (_) => sl<PdpAnalyticsTracker>()..setEntryArgs(args),
        child: BlocProvider(
          // Reads the tracker back out of the provider rather than closing over
          // a local, so there is no second reference that can drift from it.
          create: (context) =>
              sl<PdpBloc>(param1: context.read<PdpAnalyticsTracker>())
                ..add(PdpEvent.loadProductDetails(productId: productId)),
          child: const PdpPage(),
        ),
      );
    },
  );
}
