import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../config/env_config.dart';
import '../../config/environment.dart';
import '../cookies/cookies_based_events_util.dart';

class AuthHeaderInterceptor extends Interceptor {
  final DeviceInfoPlugin _deviceInfo;
  final PackageInfo _packageInfo;
  final Uuid _uuid = const Uuid();

  String? _deviceId;
  String? _installId;
  String? _osVersion;
  String? _userAgent;
  String? _browserInfo;
  String? _deviceProfile;
  String? _persistentTicket;
  String? _n7HdToken;
  bool _n7HumanDetectorEnabled = false;

  AuthHeaderInterceptor({
    required DeviceInfoPlugin deviceInfo,
    required PackageInfo packageInfo,
  })  : _deviceInfo = deviceInfo,
        _packageInfo = packageInfo;

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> init() async {
    if (_isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
      _osVersion = 'android_${androidInfo.version.release}';
      _userAgent =
          'Dalvik/2.1.0 (Linux; U; Android ${androidInfo.version.release}; '
          '${androidInfo.model} Build/${androidInfo.id})';
      _deviceProfile = 'normal';
    } else if (_isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor ?? '';
      _osVersion = 'iOS';
      _userAgent =
          'HSApp/iOS ${iosInfo.systemVersion} (${iosInfo.utsname.machine})';
      _deviceProfile = 'normal';
    } else if (kIsWeb) {
      final webInfo = await _deviceInfo.webBrowserInfo;
      final ua = webInfo.userAgent ?? '';
      _deviceId = _uuid.v4();
      _osVersion = _parseOsFromUserAgent(ua);
      _browserInfo = _parseBrowserFromUserAgent(ua);
      _deviceProfile = 'normal';
    }
    _installId = _uuid.v4();
  }

  void setPersistentTicket(String? ticket) => _persistentTicket = ticket;

  void setN7HdToken(String? token) => _n7HdToken = token;

  void setN7HumanDetectorEnabled(bool enabled) =>
      _n7HumanDetectorEnabled = enabled;

  void setDeviceProfile(String profile) => _deviceProfile = profile;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      if (kIsWeb) {
        _applyWebHeaders(options);
      } else {
        _applyNativeHeaders(options);
      }
    } catch (_) {}
    handler.next(options);
  }

  /// Web headers matching mweb curl exactly — no extra headers that would
  /// fail the CORS preflight `Access-Control-Allow-Headers` check.
  void _applyWebHeaders(RequestOptions options) {
    final headers = <String, dynamic>{
      'client-id': 'web-client/1.0',
      'client-auth-method': EnvConfig.authMethod,
      'secret-key': EnvConfig.secretKeyWeb,
      'api-version': EnvConfig.apiVersion,
      'device-id': _deviceId ?? '',
      'device-type': 'mobile',
      'install-id': '',
      'os': _osVersion ?? 'web',
      'browser': _browserInfo ?? '',
      'Accept': 'application/json',
      'x-nv-device': 'sp',
      'x-nv-security-magic': EnvConfig.n7DebugMagicSecurityKey,
      'funnel': '',
      'funnel_section': '',
      'funnel_tile': '',
      'section': '',
      'subsection': '',
    };

    if (_persistentTicket != null && _persistentTicket!.isNotEmpty) {
      headers['hs-persistent-ticket'] = _persistentTicket;
    }

    final experiments = CookiesBasedEventsUtil.instance.experimentCookies;
    if (experiments != null && experiments.isNotEmpty) {
      headers['EXPERIMENTS'] = experiments;
    }

    options.headers.addAll(headers);
  }

  /// Native (Android/iOS) headers — unchanged from original behaviour.
  void _applyNativeHeaders(RequestOptions options) {
    final clientId = _isAndroid
        ? 'android-client/${_packageInfo.version}'
        : 'iphone-client/${_packageInfo.version}';
    final secretKey = _isAndroid
        ? EnvConfig.secretKeyAndroid
        : EnvConfig.secretKeyiOS;

    final headers = <String, dynamic>{
      'client-id': clientId,
      'client-auth-method': EnvConfig.authMethod,
      'secret-key': secretKey,
      'api-version': EnvConfig.apiVersion,
      'device-id': _deviceId ?? '',
      'install-id': _installId ?? '',
      'os': _osVersion ?? EnvConfig.os,
      'appBuild': _packageInfo.buildNumber,
      'appVersion': _packageInfo.version,
      'Accept': 'application/json',
      'device-type': _deviceId ?? '',
      'X-Request-ID': _uuid.v4(),
    };

    if (_userAgent != null) {
      headers['User-Agent'] = _userAgent;
    }

    if (_deviceProfile != null) {
      headers['device-profile'] = _deviceProfile;
    }

    if (_n7HumanDetectorEnabled) {
      headers['x-nv-hd-hl-key'] = EnvConfig.n7HdHlKey;
      headers['x-nv-security-key'] = EnvConfig.n7SecurityKey;
      if (_n7HdToken != null) {
        headers['x-nv-hd-token'] = _n7HdToken;
      }
    }

    if (EnvironmentConfig.isDebug) {
      headers['x-nv'] = 'true';
      headers['x-nv-security-magic'] = EnvConfig.n7DebugMagicSecurityKey;
    }

    if (_persistentTicket != null && _persistentTicket!.isNotEmpty) {
      headers['hs-persistent-ticket'] = _persistentTicket;
    }

    options.headers.addAll(headers);
  }

  // ---------------------------------------------------------------------------
  // Web UA parsers — extract OS & browser from the browser's User-Agent string
  // so the headers match what mweb sends.
  // ---------------------------------------------------------------------------

  String _parseOsFromUserAgent(String ua) {
    final iosMatch = RegExp(r'CPU iPhone OS (\d+[_\.]\d+)').firstMatch(ua);
    if (iosMatch != null) {
      return 'iOS_${iosMatch.group(1)!.replaceAll('_', '.')}';
    }
    final ipadMatch = RegExp(r'CPU OS (\d+[_\.]\d+)').firstMatch(ua);
    if (ipadMatch != null) {
      return 'iOS_${ipadMatch.group(1)!.replaceAll('_', '.')}';
    }
    final androidMatch = RegExp(r'Android (\d+\.?\d*)').firstMatch(ua);
    if (androidMatch != null) return 'android_${androidMatch.group(1)}';
    if (ua.contains('Macintosh')) return 'macOS';
    if (ua.contains('Windows')) return 'Windows';
    return 'web';
  }

  String _parseBrowserFromUserAgent(String ua) {
    // Chrome (must check before Safari — Chrome UA contains "Safari")
    final chromeMatch = RegExp(r'Chrome/(\d+\.?\d*)').firstMatch(ua);
    if (chromeMatch != null) return 'Chrome_${chromeMatch.group(1)}';
    // Safari
    final safariMatch = RegExp(r'Version/(\d+\.?\d*).*Safari').firstMatch(ua);
    if (safariMatch != null) {
      final isMobile = ua.contains('Mobile');
      return '${isMobile ? 'Mobile ' : ''}Safari_${safariMatch.group(1)}';
    }
    // Firefox
    final ffMatch = RegExp(r'Firefox/(\d+\.?\d*)').firstMatch(ua);
    if (ffMatch != null) return 'Firefox_${ffMatch.group(1)}';
    // Edge
    final edgeMatch = RegExp(r'Edg/(\d+\.?\d*)').firstMatch(ua);
    if (edgeMatch != null) return 'Edge_${edgeMatch.group(1)}';
    return '';
  }
}
