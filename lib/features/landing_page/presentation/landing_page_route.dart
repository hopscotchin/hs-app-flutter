import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../../core/cubits/shop_the_look_cubit.dart';
import '../../../core/di/injection.dart';
import 'bloc/landing_page_bloc.dart';
import 'pages/landing_page.dart';

class LandingPageRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.landingPage,
    name: 'landingPage',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      final pageName = state.uri.queryParameters['pageName'] ?? '';
      final title = state.uri.queryParameters['title'];
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LandingPageBloc>()),
        ],
        child: LandingPage(pageName: pageName, title: title),
      );
    },
  );
}
