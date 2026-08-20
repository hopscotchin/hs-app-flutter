import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/components/atoms/in_app_webview_page.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../features/auth/domain/usecases/generate_login_ticket_usecase.dart';
import '../di/injection.dart';
import 'app_navigator.dart';

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
        fromNotification: extra['fromNotification'] as bool? ?? false,
        onLoginRequested: _onLoginRequested,
      );
    },
  );

  static Future<String?> _onLoginRequested(
    BuildContext context,
    String? redirectUrl,
  ) async {
    final loggedIn = await AppNavigator.showMobileLoginFlow(context);
    if (!loggedIn || !context.mounted) return null;

    final result = await sl<GenerateLoginTicketUseCase>()(
      const GenerateLoginTicketParams(),
    );
    return result.fold((_) => null, (ticket) => ticket.isEmpty ? null : ticket);
  }
}
