import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/strings/account_strings.dart';
import '../di/injection.dart';

/// Invokes the native share sheet (app referral) and the store rating page.
///
///   - Share  → Open bottom-sheet with available options.
///   - Rate   → opens the Play Store/ App Store with Web fallback.
class AppShareLauncher {
  AppShareLauncher._();

  // Published store identifiers (NOT the Flutter debug appId `*.flutter`).
  static const _androidPackage = 'in.hopscotch.android';

  static const _iosAppStoreId = '945949424';

  /// Opens the system share sheet with the app referral message.
  static Future<void> shareApp() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: AccountStrings.shareAppMessage,
          subject: AccountStrings.shareAppTitle,
        ),
      );
    } catch (e, st) {
      sl<Talker>().handle(e, st, 'AppShareLauncher.shareApp');
    }
  }

  /// Opens the app's store listing so the user can rate it.
  static Future<void> rateApp() async {
    final (primary, fallback) = _storeUris();
    try {
      if (await launchUrl(primary, mode: LaunchMode.externalApplication)) {
        return;
      }
      if (fallback != null) {
        await launchUrl(fallback, mode: LaunchMode.externalApplication);
      }
    } catch (e, st) {
      sl<Talker>().handle(e, st, 'AppShareLauncher.rateApp');
    }
  }

  static (Uri primary, Uri? fallback) _storeUris() {
    if (Platform.isIOS) {
      // `action=write-review` jumps straight to the review composer.
      const review = 'action=write-review';
      return (
        Uri.parse(
          'itms-apps://itunes.apple.com/us/app/id$_iosAppStoreId?$review',
        ),
        Uri.parse('https://apps.apple.com/app/id$_iosAppStoreId?$review'),
      );
    }
    return (
      Uri.parse('market://details?id=$_androidPackage'),
      Uri.parse(
        'https://play.google.com/store/apps/details?id=$_androidPackage',
      ),
    );
  }
}