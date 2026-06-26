import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../core/cubits/shop_the_look_cubit.dart';
import '../../core/di/injection.dart';
import 'presentation/pages/discover_page.dart';

class DiscoverRoute {
  static StatefulShellBranch getBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const DiscoverPage(),
      ),
    ],
  );
}
