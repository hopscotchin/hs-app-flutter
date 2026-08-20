import 'dart:io';

import 'package:flutter/widgets.dart';

import '../config/environment.dart';
import '../constants/strings/account_strings.dart';
import '../di/injection.dart';
import '../router/app_navigator.dart';
import '../services/pref_manager.dart';
import '../../features/auth/domain/usecases/generate_login_ticket_usecase.dart';

/// Opens the Help Center / Contact Us web pages in the in-app WebView.
///
/// Ported from the Android `HelpCenterUtil`: when the user is logged in a web
/// SSO login ticket is generated and appended so the page opens authenticated;
/// otherwise the page is opened anonymously.
class HelpCenterLauncher {
  HelpCenterLauncher._();

  // The web links already end with `?`, matching `BuildConfig.HELP_CENTER_LINK`.
  static const _helpPath = 'helpcenter/#/?';
  static const _contactUsPath = 'helpcenter/#/contact_us?';

  /// Help Center landing page.
  static Future<void> openHelpCenter(BuildContext context) =>
      _launch(context, path: _helpPath, title: AccountStrings.help);

  /// Contact Us section of the Help Center.
  static Future<void> openContactUs(BuildContext context) =>
      _launch(context, path: _contactUsPath, title: AccountStrings.help);

  static Future<void> _launch(
    BuildContext context, {
    required String path,
    required String title,
  }) async {
    final base = '${EnvironmentConfig.webBaseUrl}/$path';
    final site = Platform.isIOS ? 'ios' : 'android';

    var query = 'id=app&site=$site';
    if (sl<PrefManager>().isLoggedIn) {
      final result = await sl<GenerateLoginTicketUseCase>()(
        const GenerateLoginTicketParams(),
      );
      final ticket = result.fold((_) => null, (t) => t.isEmpty ? null : t);
      if (ticket != null) query = 'loginTicket=$ticket&id=app&site=$site';
    }

    if (context.mounted) {
      AppNavigator.goToWebView(context, url: '$base$query', title: title);
    }
  }
}
