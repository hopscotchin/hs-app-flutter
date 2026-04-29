import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_names.dart';

abstract final class AppNavigator {
  static void goToHome(BuildContext context) => context.go(RouteNames.home);

  static void goToCategories(BuildContext context) =>
      context.go(RouteNames.categories);

  static void goToMoments(BuildContext context) =>
      context.go(RouteNames.moments);

  static void goToAccount(BuildContext context) =>
      context.go(RouteNames.account);

  static void goToCart(BuildContext context) => context.go(RouteNames.cart);

  static void goToPdp(BuildContext context, String productId) {
    context.pushNamed('pdp', pathParameters: {'productId': productId});
  }

  static void goToLogin(BuildContext context) => context.pushNamed('login');

  static void goToJoinUs(BuildContext context) => context.pushNamed('joinUs');

  static void goToLandingPage(
    BuildContext context, {
    required String pageName,
    String? title,
  }) {
    final queryParams = <String, String>{'pageName': pageName};
    if (title != null) queryParams['title'] = title;
    context.pushNamed('landingPage', queryParameters: queryParams);
  }

  static void goToWebView(
    BuildContext context, {
    required String url,
    String? title,
  }) {
    context.pushNamed(
      'webview',
      extra: <String, dynamic>{'url': url, 'title': title},
    );
  }

  static void goToOrders(BuildContext context) => context.pushNamed('orders');
}
