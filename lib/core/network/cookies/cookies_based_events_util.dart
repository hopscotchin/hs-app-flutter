import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';

import '../../analytics/attribution/utm_header_util.dart';
import '../../analytics/events/analytics_helper.dart';
import '../../analytics/services/clarity_helper.dart';
import '../../analytics/state/experiments_util.dart';
import '../../services/pref_manager.dart';
import 'hs_cookie_store.dart';

class CookiesBasedEventsUtil {
  CookiesBasedEventsUtil._();
  static final CookiesBasedEventsUtil _instance = CookiesBasedEventsUtil._();
  static CookiesBasedEventsUtil get instance => _instance;

  PrefManager? _prefManager;
  AnalyticsHelper? _analyticsHelper;
  UtmHeaderUtil? _utm;
  ExperimentsUtil? _experiments;
  ClarityHelper? _clarity;

  String? _sessionId;
  String? _startSessionId;
  String? _lastVisitDate;
  int _daysSinceLastVisit = 0;
  String? _userType;
  String? _currentUserType;
  String? _segmentUserType;
  String? _experimentCookies;
  String? _previousExperimentCookies;
  int _sessionCount = 0;

  String? get sessionId => _sessionId;
  String? get lastVisitDate => _lastVisitDate;
  int get daysSinceLastVisit => _daysSinceLastVisit;
  String? get userType => _userType;
  String? get segmentUserType => _segmentUserType;
  String? get experimentCookies => _experimentCookies;
  int get sessionCount => _sessionCount;

  void init(PrefManager prefManager) {
    _prefManager = prefManager;
  }

  /// Wire analytics collaborators. Called from `main.dart` AFTER
  /// `configureDependencies()` completes, since [AnalyticsHelper] is itself
  /// dependent on `PackageInfo` / `DeviceInfo` / `PrefManager` which are
  /// pre-resolved before this util's interceptor starts seeing responses.
  ///
  /// Until [wireAnalytics] runs, the util tracks session state silently but
  /// does NOT fire identify or session_started — matching Android's
  /// initialization ordering where `AnalyticsHelper.getInstance()` exists
  /// before the first response interceptor fires.
  void wireAnalytics({
    required AnalyticsHelper analyticsHelper,
    required UtmHeaderUtil utm,
    required ExperimentsUtil experiments,
    required ClarityHelper clarity,
  }) {
    _analyticsHelper = analyticsHelper;
    _utm = utm;
    _experiments = experiments;
    _clarity = clarity;
  }

  Future<void> handleCookiesAndSessionStartEvent() async {
    await _addCookies();
    await _handleCookies();
  }

  Future<void> loadPersistedData() async {
    final prefs = _prefManager;
    if (prefs == null) return;

    _sessionCount = prefs.sessionCount;
    _startSessionId = prefs.startSessionId;
    _currentUserType = prefs.currentUserType;
    _previousExperimentCookies = prefs.previousExperiments;
  }

  Future<void> _addCookies() async {
    final cookies = await HSCookieStore.getCookiesList();
    if (cookies.isEmpty) return;

    for (final cookie in cookies) {
      switch (cookie.name.toLowerCase()) {
        case 'othersessioninfo':
          // Cookie is a compound k=v,k=v,k=v value. Some server responses
          // wrap the outer value in double quotes (RFC 6265 §4.1.1 allows
          // `cookie-value = *cookie-octet / ( DQUOTE *cookie-octet DQUOTE )`)
          // and some URL-encode the internal `=` / `,` separators. Android's
          // okhttp3 strips both automatically; the Flutter cookie parser
          // does not. Normalise here so the split-by-`,` / split-by-`=`
          // pipeline below always sees the expected shape.
          final raw = Uri.decodeComponent(cookie.value)
              .replaceAll('"', '')
              .trim();
          for (final part in raw.split(',')) {
            final trimmed = part.trim();
            if (trimmed.isEmpty) continue;
            final eqIdx = trimmed.indexOf('=');
            if (eqIdx <= 0) continue;
            final key = trimmed.substring(0, eqIdx).trim().toLowerCase();
            final value = trimmed.substring(eqIdx + 1).trim();
            if (key == 'sessionstarttime') _sessionId = value;
            if (key == 'lastvisitdate') _lastVisitDate = value;
            if (key == 'dayssincelastvisit') {
              _daysSinceLastVisit = int.tryParse(value) ?? 0;
            }
          }
        case 'website_customersegment':
          _userType = cookie.value;
        case 'segment_user_type':
          _segmentUserType = cookie.value;
        case 'experiments':
          // Same okhttp3-vs-Flutter parity quirk as `othersessioninfo` above:
          // some responses ship the cookie DQUOTE-wrapped (RFC 6265 §4.1.1)
          // and/or URL-encoded. Android strips both; Flutter's cookie parser
          // preserves them literally. Left as-is, the surrounding `"`
          // characters leak into `_experimentCookies` and the downstream
          // `experimentsList` split-on-`,` attaches `\"` to the first + last
          // elements of the identify trait.
          //
          // Strip only the RFC-6265 surrounding DQUOTE pair — not every `"`
          // in the value — so a hypothetical experiment name containing an
          // internal quote survives.
          //
          // Mirror Android `CookiesBasedEventsUtil.java:68-74` — empty value
          // falls back to the sentinel `AnalyticsDefaults.NONE` so the trait
          // wire format still includes something the dashboards can key on.
          var raw = Uri.decodeComponent(cookie.value).trim();
          if (raw.length >= 2 && raw.startsWith('"') && raw.endsWith('"')) {
            raw = raw.substring(1, raw.length - 1).trim();
          }
          _experimentCookies = raw.isNotEmpty ? raw : AnalyticsDefaults.none;
      }
    }

    // Persist trait values so AnalyticsHelper.identifyOnCookieChange can
    // read them. PrefManager's userType / segmentUserType / lastVisitDate /
    // daysSinceLastVisit are the canonical home — see storage_backbone.md.
    final prefs = _prefManager;
    if (prefs != null) {
      if (_userType != null) await prefs.setUserType(_userType);
      if (_segmentUserType != null) await prefs.setSegmentUserType(_segmentUserType);
      if (_lastVisitDate != null) await prefs.setLastVisitDate(_lastVisitDate);
      await prefs.setDaysSinceLastVisit(_daysSinceLastVisit);
    }

    // Mirror the cookie value into the runtime ExperimentsUtil so the
    // identifyOnCookieChange call reads the same string it just parsed.
    _experiments?.experimentCookies = _experimentCookies;

    // Push the absolute user type (userType with segmentUserType fallback) as
    // a Clarity custom tag. Mirrors Android `CookiesBasedEventsUtil.java:80`
    // — `ClarityHelper.setUserType(AppRecordData.getAbsoluteUserType())`
    // fires on every response so replays surface the current segment.
    final absoluteUserType = _userType?.isNotEmpty == true
        ? _userType
        : _segmentUserType;
    _clarity?.setUserType(absoluteUserType);
  }

  Future<void> _handleCookies() async {
    final isSessionChange =
        _sessionId != null &&
        _sessionId!.isNotEmpty &&
        _sessionId != _startSessionId;
    _startSessionId = _sessionId;

    final isUserTypeChange =
        _userType != null &&
        _userType!.isNotEmpty &&
        _userType != _currentUserType;
    _currentUserType = _userType;

    final isUtmChange = _utm?.isUtmChanged ?? false;
    _utm?.isUtmChanged = false;

    final isExperimentChanged =
        _experimentCookies != null &&
        _experimentCookies!.isNotEmpty &&
        _experimentCookies != _previousExperimentCookies;
    _previousExperimentCookies = _experimentCookies;
    await _experiments?.setPreviousExperimentCookies(_experimentCookies);

    //TODO: Needed this debug log to verify all these in real time
    if (kDebugMode) {
      if (isSessionChange) {
        developer.log('Session changed: $_sessionId', name: 'CookiesEvents');
      }
      if (isUserTypeChange) {
        developer.log('User type changed: $_userType', name: 'CookiesEvents');
      }
      if (isUtmChange) {
        developer.log('UTM changed', name: 'CookiesEvents');
      }
      if (isExperimentChanged) {
        developer.log('Experiments changed', name: 'CookiesEvents');
      }
    }

    // Fire identify on ANY of the four diffs. The helper has its own
    // change-flag guard so identifies are not spammed when nothing changed.
    await _analyticsHelper?.identifyOnCookieChange(
      sessionChange: isSessionChange,
      utmChange: isUtmChange,
      userTypeChange: isUserTypeChange,
      experimentChange: isExperimentChanged,
    );

    if (isSessionChange) {
      _sessionCount++;
      await _prefManager?.persistSessionData(
        sessionCount: _sessionCount,
        startSessionId: _startSessionId,
        currentUserType: _currentUserType,
        previousExperiments: _previousExperimentCookies,
      );
      // session_started fires AFTER identify so the freshly-written traits
      // ride on the event's `context.traits` (via ContextParityPlugin).
      await _analyticsHelper?.fireSessionStartedEvent();
    }
  }
}
