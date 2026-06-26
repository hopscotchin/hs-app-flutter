import 'package:flutter/foundation.dart';

import 'env_config.dart';

enum Environment { debug, debugVPN, release }

class EnvironmentConfig {
  EnvironmentConfig._();

  static Environment _currentEnvironment = kReleaseMode ? Environment.release : Environment.debug;

  static Environment get current => _currentEnvironment;

  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  /// API base URL. The host values in `.env` already include the `/api`
  /// path segment, so this returns the host as-is.
  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.debug:
        if (kIsWeb && EnvConfig.apiHostWeb.isNotEmpty) {
          return '${EnvConfig.httpsScheme}${EnvConfig.apiHostWeb}';
        }
        return '${EnvConfig.httpsScheme}${EnvConfig.apiHostQa}';
      case Environment.debugVPN:
        return '${EnvConfig.httpsScheme}${EnvConfig.apiHostQaVpn}';
      case Environment.release:
        return '${EnvConfig.httpsScheme}${EnvConfig.apiHost}';
    }
  }

  /// Web/webview base URL. Uses the dedicated `WEB_HOST*` config,
  static String get webBaseUrl {
    switch (_currentEnvironment) {
      case Environment.debug:
        if (kIsWeb && EnvConfig.apiHostWeb.isNotEmpty) {
          return '${EnvConfig.httpsScheme}${EnvConfig.apiHostWeb}';
        }
        return '${EnvConfig.httpsScheme}${EnvConfig.webHostQa}';
      case Environment.debugVPN:
        return '${EnvConfig.httpsScheme}${EnvConfig.webHostQaVpn}';
      case Environment.release:
        return '${EnvConfig.httpsScheme}${EnvConfig.webHost}';
    }
  }

  static String get environmentName {
    switch (_currentEnvironment) {
      case Environment.debug:
        return 'Debug';
      case Environment.debugVPN:
        return 'Debug VPN';
      case Environment.release:
        return 'Release';
    }
  }

  static bool get isProduction => _currentEnvironment == Environment.release;

  static bool get isDebug =>
      _currentEnvironment == Environment.debug || _currentEnvironment == Environment.debugVPN;
}
