import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  // API Configuration
  static String get apiHost => dotenv.env['API_HOST'] ?? 'www.hopscotch.in';
  static String get apiHostQa => dotenv.env['API_HOST_QA'] ?? 'qa.hopscotch.in';
  static String get apiHostQaVpn => dotenv.env['API_HOST_QA_VPN'] ?? 'qa-vpn.hopscotch.in';
  static String get apiHostWeb => dotenv.env['API_HOST_WEB'] ?? '';
  static String get httpsScheme => dotenv.env['HTTPS_SCHEME'] ?? 'https://';
  static String get httpScheme => dotenv.env['HTTP_SCHEME'] ?? 'http://';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v2';

  // Web Configuration (webview URLs)
  static String get webHost => dotenv.env['WEB_HOST'] ?? 'www.hopscotch.in';
  static String get webHostQa => dotenv.env['WEB_HOST_QA'] ?? 'qa.hopscotch.in';
  static String get webHostQaVpn => dotenv.env['WEB_HOST_QA_VPN'] ?? 'qa-vpn.hopscotch.in';

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
  static String get n7DebugMagicSecurityKey => dotenv.env['N7_DEBUG_MAGIC_SECURITY_KEY'] ?? '';

  // Segment
  static String get segmentDebugUrl => dotenv.env['SEGMENT_DEBUG_URL'] ?? '';
  static String get segmentReleaseUrl => dotenv.env['SEGMENT_RELEASE_URL'] ?? '';

  // HTTP Toolkit Proxy
  static bool get enableHttpToolkitProxy => dotenv.env['ENABLE_HTTP_TOOLKIT_PROXY'] == 'true';
  // static String get proxyHost => dotenv.env['PROXY_HOST'] ?? '127.0.0.1';
  // static int get proxyPort => int.parse(dotenv.env['PROXY_PORT'] ?? '8000');
}
