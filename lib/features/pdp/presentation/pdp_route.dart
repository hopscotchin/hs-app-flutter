import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/core/di/injection.dart';

import 'bloc/pdp_bloc.dart';
import 'pages/pdp_page.dart';

class PdpRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.pdp,
    name: 'pdp',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      final productId = int.parse(state.pathParameters['productId']!);
      return BlocProvider(
        create: (_) =>
            sl<PdpBloc>()
              ..add(PdpEvent.loadProductDetails(productId: productId)),
        child: const PdpPage(),
      );
    },
  );
}
