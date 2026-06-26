import 'dart:io';

import 'package:flutter/widgets.dart';

import '../../features/legal/domain/entities/legal_touch_point.dart';
import '../config/environment.dart';
import '../router/app_navigator.dart';

/// Opens a [LegalTouchPoint] web page (Terms / Privacy / About Us) in the
/// in-app WebView.
///
/// Ported from the Android `LegalUtils.open`: builds the environment-specific
/// URL and appends the `id=app&site=<platform>` params the web app expects.
class LegalLauncher {
  LegalLauncher._();

  static void open(BuildContext context, LegalTouchPoint touchPoint) {
    final site = Platform.isIOS ? 'ios' : 'android';
    final url = '${EnvironmentConfig.webBaseUrl}/${touchPoint.path}?id=app&site=$site';
    AppNavigator.goToWebView(context, url: url, title: touchPoint.title);
  }
}