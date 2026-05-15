import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../domain/entities/page_type.dart';
import 'pages/plp_page.dart';

class PlpRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.plp,
    name: 'plp',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      final pageTypeStr = state.uri.queryParameters['pageType'] ?? 'plp';
      final pageType = PageType.values.firstWhere(
        (e) => e.name == pageTypeStr,
        orElse: () => PageType.plp,
      );
      final plpId =
          int.tryParse(state.uri.queryParameters['plpId'] ?? '0') ?? 0;
      final categoryName = state.uri.queryParameters['categoryName'];
      final searchQuery = state.uri.queryParameters['searchQuery'];
      return PlpPage(
        pageType: pageType,
        plpId: plpId,
        categoryName: categoryName,
        searchQuery: searchQuery,
      );
    },
  );
}
