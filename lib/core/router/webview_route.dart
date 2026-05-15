import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/components/atoms/in_app_webview_page.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

class WebViewRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.webView,
    name: 'webview',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};
      return InAppWebViewPage(
        url: extra['url'] as String? ?? '',
        title: extra['title'] as String?,
      );
    },
  );
}
