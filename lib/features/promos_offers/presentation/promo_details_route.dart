import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import '../../../core/di/injection.dart';
import 'bloc/promo_details_bloc.dart';
import 'pages/promo_details_page.dart';

/// Route for the promo detail screen, reached from the "See terms" link on an
/// offer card via the `hopscotch://offers?id=<promoId>` deeplink.
class PromoDetailsRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.promoDetails,
    name: 'promoDetails',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      // A non-numeric id can only come from a malformed deeplink; 0 makes the
      // page show its "no longer available" message rather than crash.
      final promoId = int.tryParse(state.pathParameters['promoId'] ?? '') ?? 0;
      return BlocProvider(
        create: (_) =>
            sl<PromoDetailsBloc>()..add(PromoDetailsEvent.load(promoId)),
        child: const PromoDetailsPage(),
      );
    },
  );
}
