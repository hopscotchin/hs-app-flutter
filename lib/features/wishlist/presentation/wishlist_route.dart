import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import '../../../core/di/injection.dart';
import '../../pdp/presentation/bloc/size_chart_bloc.dart';
import 'bloc/wishlist_listing_bloc.dart';
import 'pages/wishlist_page.dart';

class WishlistRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.wishlist,
    name: RouteNames.wishlistName,
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      // `fromScreen` is passed by AppNavigator.goToWishlist as the route's
      // extra — stamped on wishlist_viewed for attribution.
      final fromScreen = state.extra is String ? state.extra as String : null;
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<WishlistListingBloc>()
              ..add(LoadWishlist(fromScreen: fromScreen)),
          ),
          // Backs the size-chart sheet opened from the move-to-bag sheet; loads
          // lazily on first tap.
          BlocProvider(create: (_) => sl<SizeChartBloc>()),
        ],
        child: const WishlistPage(),
      );
    },
  );
}
