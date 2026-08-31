import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  // API Configuration
  static String get apiHost => dotenv.env['API_HOST'] ?? 'www.hopscotch.in';
  static String get apiHostQa => dotenv.env['API_HOST_QA'] ?? 'qa.hopscotch.in';
  static String get apiHostQaVpn =>
      dotenv.env['API_HOST_QA_VPN'] ?? 'qa-vpn.hopscotch.in';
  static String get apiHostWeb => dotenv.env['API_HOST_WEB'] ?? '';
  static String get httpsScheme => dotenv.env['HTTPS_SCHEME'] ?? 'https://';
  static String get httpScheme => dotenv.env['HTTP_SCHEME'] ?? 'http://';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v2';

  // Web Configuration (webview URLs)
  static String get webHost => dotenv.env['WEB_HOST'] ?? 'www.hopscotch.in';
  static String get webHostQa => dotenv.env['WEB_HOST_QA'] ?? 'qa.hopscotch.in';
  static String get webHostQaVpn =>
      dotenv.env['WEB_HOST_QA_VPN'] ?? 'qa-vpn.hopscotch.in';

  // Client Credentials
  static String get authMethod => dotenv.env['AUTH_METHOD'] ?? 'v1';
  static String get secretKeyAndroid => dotenv.env['SECRET_KEY_ANDROID'] ?? '';
  static String get secretKeyiOS => dotenv.env['SECRET_KEY_iOS'] ?? '';
  static String get secretKeyWeb => dotenv.env['SECRET_KEY_WEB'] ?? '';

  // App Info
  static String get versionName => dotenv.env['VERSION_NAME'] ?? '1.0.0';
  static String get versionCode => dotenv.env['VERSION_CODE'] ?? '1';
  static String get os => dotenv.env['OS'] ?? 'Android';

  // N7 Security Keys
  static String get n7HdHlKey => dotenv.env['N7_HD_HL_KEY'] ?? '';
  static String get n7SecurityKey => dotenv.env['N7_SECURITY_KEY'] ?? '';
  static String get n7DebugMagicSecurityKey =>
      dotenv.env['N7_DEBUG_MAGIC_SECURITY_KEY'] ?? '';

  // Segment — ingestion endpoints (mirror Android APIConstants.SEGMENT_DEBUG /
  // SEGMENT_RELEASE). Stored hostname-only without scheme; the SDK prepends https.
  static String get segmentDebugUrl => dotenv.env['SEGMENT_DEBUG_URL'] ?? '';
  static String get segmentReleaseUrl =>
      dotenv.env['SEGMENT_RELEASE_URL'] ?? '';

  // HTTP Toolkit Proxy
  static bool get enableHttpToolkitProxy =>
      dotenv.env['ENABLE_HTTP_TOOLKIT_PROXY'] == 'true';
  // static String get proxyHost => dotenv.env['PROXY_HOST'] ?? '127.0.0.1';
  // static int get proxyPort => int.parse(dotenv.env['PROXY_PORT'] ?? '8000');

  // Analytics — Segment write keys + computed per-build accessors.
  static String get analyticsDebugKey => dotenv.env['ANALYTICS_DEBUG'] ?? '';
  static String get analyticsReleaseKey =>
      dotenv.env['ANALYTICS_RELEASE'] ?? '';

  /// Write key picked at runtime via kReleaseMode — debug keys go to the
  /// dev Segment workspace, release keys to production.
  static String get segmentWriteKey =>
      kReleaseMode ? analyticsReleaseKey : analyticsDebugKey;

  /// Segment ingestion host (proxied through hopscotch.in to bypass ad-blockers).
  /// Returned as hostname + path with no scheme.
  static String get segmentApiHost =>
      kReleaseMode ? segmentReleaseUrl : segmentDebugUrl;

  // AppsFlyer — single dev key for both platforms (matches Android setup).
  static String get appsFlyerKey => dotenv.env['APPSFLYER_KEY'] ?? '';

  // CleverTap — per-flavour credentials, mirrors Android `build.gradle`'s
  // debug-vs-release `resValue "string", "clevertap_account_id", ...` split.
  static String get cleverTapAccountId => kReleaseMode
      ? (dotenv.env['CLEVERTAP_ACCOUNT_ID_RELEASE'] ?? '')
      : (dotenv.env['CLEVERTAP_ACCOUNT_ID_DEBUG'] ?? '');
  static String get cleverTapToken => kReleaseMode
      ? (dotenv.env['CLEVERTAP_TOKEN_RELEASE'] ?? '')
      : (dotenv.env['CLEVERTAP_TOKEN_DEBUG'] ?? '');

  // Microsoft Clarity — per-flavour project id. Mirrors Android
  // `KeysProvider.getClarityProjectId(BuildConfig.DEBUG)`.
  static String get clarityProjectId => kReleaseMode
      ? (dotenv.env['CLARITY_PROJECT_ID_RELEASE'] ?? '')
      : (dotenv.env['CLARITY_PROJECT_ID_DEBUG'] ?? '');

  /// Apple App Store id. Required by AppsFlyer iOS init; ignored on Android.
  ///
  /// The `.env` value is stored in the App Store URL shape `id945949424` for
  /// parity with Android, but the AppsFlyer Flutter SDK validates against
  /// `^\d{8,11}$` (pure digits only — no `id` prefix). Strip the prefix here
  /// so callers get a value the SDK accepts.
  static String get appleAppId {
    final raw = dotenv.env['APPLE_APP_ID'] ?? '';
    return raw.startsWith('id') ? raw.substring(2) : raw;
  }
}
