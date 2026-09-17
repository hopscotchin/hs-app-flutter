import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import '../../../core/di/injection.dart';
import '../domain/entities/child_entity.dart';
import 'bloc/kids_bloc.dart';
import 'bloc/manage_kid_bloc.dart';
import 'pages/add_edit_kid_page.dart';
import 'pages/kids_page.dart';

class KidsRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.kids,
    name: RouteNames.kidsName,
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      return BlocProvider(
        create: (_) => sl<KidsBloc>()..add(const KidsEvent.load()),
        child: const KidsPage(),
      );
    },
    routes: [
      GoRoute(
        path: RouteNames.addKid,
        name: RouteNames.addKidName,
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          final existing = (state.extra as Map<String, dynamic>?)?['existing'] as ChildEntity?;
          return BlocProvider(
            create: (_) => sl<ManageKidBloc>(),
            child: AddEditKidPage(existing: existing),
          );
        },
      ),
    ],
  );
}
