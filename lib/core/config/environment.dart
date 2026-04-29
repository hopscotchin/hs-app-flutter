import 'package:flutter/foundation.dart';

import 'env_config.dart';

enum Environment {
  debug,
  debugVPN,
  release,
}

class EnvironmentConfig {
  EnvironmentConfig._();

  static Environment _currentEnvironment = kReleaseMode
      ? Environment.release
      : Environment.debug;

  static Environment get current => _currentEnvironment;

  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.debug:
        if(kIsWeb) {
          return '${EnvConfig.httpScheme}${EnvConfig.apiHostWeb}';
        }
        return '${EnvConfig.httpsScheme}${EnvConfig.apiHostQa}';
      case Environment.debugVPN:
        return '${EnvConfig.httpsScheme}${EnvConfig.apiHostQaVpn}';
      case Environment.release:
        return '${EnvConfig.httpsScheme}${EnvConfig.apiHost}';
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

  static bool get isDebug => _currentEnvironment == Environment.debug ||
                              _currentEnvironment == Environment.debugVPN;
}
