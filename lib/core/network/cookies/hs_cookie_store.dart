import 'dart:convert';

import '../../services/pref_manager.dart';

class HSCookieStore {
  static String? _host;
  static PrefManager? _prefManager;

  static void init(PrefManager prefManager) {
    _prefManager = prefManager;
  }

  static void setHost(String host) {
    _host = host;
  }

  static String get host => _host ?? '';

  static Future<void> setCookies(Set<String> rawSetCookies) async {
    final cookiesMap = await _setAndGetUnExpiredCookies(rawSetCookies);
    _prefManager!.setCookies(_storageKey, jsonEncode(cookiesMap));
  }

  static Future<Set<String>> getCookies() async {
    final cookiesMap = _getCookiesMap();
    return _getUnExpiredCookies(cookiesMap);
  }

  static Future<List<ParsedCookie>> getCookiesList() async {
    final cookiesSet = await getCookies();
    return cookiesSet
        .map(ParsedCookie.parse)
        .whereType<ParsedCookie>()
        .toList(growable: false);
  }

  static Future<Map<String, ParsedCookie>> getCurrentCookiesMap() async {
    final cookies = await getCookiesList();
    return {for (final c in cookies) c.name: c};
  }

  static Future<void> clearCookies() async {
    _prefManager!.removeCookies(_storageKey);
  }

  // ─── Internal ──────────────────────────────────────────────────

  static String get _storageKey => _host ?? 'default';

  static Future<Map<String, String>> _setAndGetUnExpiredCookies(
    Set<String> rawSetCookies,
  ) async {
    final existingMap = _getCookiesMap();

    for (final raw in rawSetCookies) {
      final cookie = ParsedCookie.parseSetCookie(raw);
      if (cookie == null) continue;
      existingMap[cookie.name] = raw;
    }

    final now = DateTime.now();
    existingMap.removeWhere((_, rawCookie) {
      final cookie = ParsedCookie.parseSetCookie(rawCookie);
      if (cookie == null) return true;
      return cookie.expiresAt != null && cookie.expiresAt!.isBefore(now);
    });

    return existingMap;
  }

  static Set<String> _getUnExpiredCookies(Map<String, String> cookiesMap) {
    final result = <String>{};
    final now = DateTime.now();
    for (final entry in cookiesMap.entries) {
      final cookie = ParsedCookie.parseSetCookie(entry.value);
      if (cookie == null) continue;
      if (cookie.expiresAt != null && cookie.expiresAt!.isBefore(now)) continue;
      result.add('${cookie.name}=${cookie.value}');
    }
    return result;
  }

  static Map<String, String> _getCookiesMap() {
    final jsonStr = _prefManager?.getCookies(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return {};

    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }
}

class ParsedCookie {
  final String name;
  final String value;
  final String? domain;
  final String? path;
  final DateTime? expiresAt;
  final bool httpOnly;
  final bool secure;

  const ParsedCookie({
    required this.name,
    required this.value,
    this.domain,
    this.path,
    this.expiresAt,
    this.httpOnly = false,
    this.secure = false,
  });

  static ParsedCookie? parseSetCookie(String setCookieHeader) {
    final parts = setCookieHeader.split(';');
    if (parts.isEmpty) return null;

    final nameValue = parts.first.trim();
    final eqIndex = nameValue.indexOf('=');
    if (eqIndex <= 0) return null;

    final name = nameValue.substring(0, eqIndex).trim();
    final value = nameValue.substring(eqIndex + 1).trim();

    String? domain;
    String? path;
    DateTime? expiresAt;
    bool httpOnly = false;
    bool secure = false;

    for (var i = 1; i < parts.length; i++) {
      final attr = parts[i].trim().toLowerCase();
      if (attr.startsWith('domain=')) {
        domain = parts[i].trim().substring(7);
      } else if (attr.startsWith('path=')) {
        path = parts[i].trim().substring(5);
      } else if (attr.startsWith('expires=')) {
        final dateStr = parts[i].trim().substring(8);
        expiresAt = _parseHttpDate(dateStr);
      } else if (attr.startsWith('max-age=')) {
        final seconds = int.tryParse(attr.substring(8));
        if (seconds != null) {
          expiresAt = DateTime.now().add(Duration(seconds: seconds));
        }
      } else if (attr == 'httponly') {
        httpOnly = true;
      } else if (attr == 'secure') {
        secure = true;
      }
    }

    return ParsedCookie(
      name: name,
      value: value,
      domain: domain,
      path: path,
      expiresAt: expiresAt,
      httpOnly: httpOnly,
      secure: secure,
    );
  }

  static ParsedCookie? parse(String cookieString) {
    final eqIndex = cookieString.indexOf('=');
    if (eqIndex <= 0) return null;
    return ParsedCookie(
      name: cookieString.substring(0, eqIndex).trim(),
      value: cookieString.substring(eqIndex + 1).trim(),
    );
  }

  static DateTime? _parseHttpDate(String dateStr) {
    final cleaned = dateStr.replaceAll(' GMT', '').replaceAll(' UTC', '');
    const months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4,
      'may': 5, 'jun': 6, 'jul': 7, 'aug': 8,
      'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    final parts = cleaned.split(RegExp(r'[\s,]+'));
    if (parts.length < 5) return null;

    final day = int.tryParse(parts[1]);
    final month = months[parts[2].toLowerCase()];
    final year = int.tryParse(parts[3]);
    final timeParts = parts[4].split(':');
    if (day == null || month == null || year == null || timeParts.length < 3) {
      return null;
    }
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts[1]) ?? 0;
    final second = int.tryParse(timeParts[2]) ?? 0;

    return DateTime.utc(year, month, day, hour, minute, second);
  }

  @override
  String toString() => '$name=$value';
}
