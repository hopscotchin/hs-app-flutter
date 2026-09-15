import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../domain/entities/page_type.dart';
import '../domain/entities/plp_entry_args.dart';
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
      final rawSearchParams = state.uri.queryParameters['rawSearchParams'];
      // Analytics entry context, when the caller supplied it. Absent for
      // deeplinks and for any push that predates the arg — `from_screen` /
      // `from_location` are then simply omitted from the payload.
      final extra = state.extra;
      return PlpPage(
        pageType: pageType,
        plpId: plpId,
        categoryName: categoryName,
        searchQuery: searchQuery,
        rawSearchParams: rawSearchParams,
        entryArgs: extra is PlpEntryArgs ? extra : null,
      );
    },
  );
}
