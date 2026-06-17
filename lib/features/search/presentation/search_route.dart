import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import '../../../core/di/injection.dart';
import 'bloc/search_bloc.dart';
import 'pages/search_page.dart';

class SearchRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.search,
    name: 'search',
    parentNavigatorKey: rootKey,
    builder: (_, _) => BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: const SearchPage(),
    ),
  );
}
