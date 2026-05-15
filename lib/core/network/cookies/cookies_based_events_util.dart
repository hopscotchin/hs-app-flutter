import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../../services/pref_manager.dart';
import 'hs_cookie_store.dart';

class CookiesBasedEventsUtil {
  CookiesBasedEventsUtil._();
  static final CookiesBasedEventsUtil _instance = CookiesBasedEventsUtil._();
  static CookiesBasedEventsUtil get instance => _instance;

  PrefManager? _prefManager;

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
          for (final part in cookie.value.split(',')) {
            final kv = part.split('=');
            if (kv.length != 2) continue;
            final key = kv[0].trim().toLowerCase();
            final value = kv[1].trim();
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
          if (cookie.value.isNotEmpty) _experimentCookies = cookie.value;
      }
    }
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

    final isExperimentChanged =
        _experimentCookies != null &&
        _experimentCookies!.isNotEmpty &&
        _experimentCookies != _previousExperimentCookies;
    _previousExperimentCookies = _experimentCookies;

    if (kDebugMode) {
      if (isSessionChange) {
        developer.log('Session changed: $_sessionId', name: 'CookiesEvents');
      }
      if (isUserTypeChange) {
        developer.log('User type changed: $_userType', name: 'CookiesEvents');
      }
      if (isExperimentChanged) {
        developer.log('Experiments changed', name: 'CookiesEvents');
      }
    }

    if (isSessionChange) {
      _sessionCount++;
      await _prefManager?.persistSessionData(
        sessionCount: _sessionCount,
        startSessionId: _startSessionId,
        currentUserType: _currentUserType,
        previousExperiments: _previousExperimentCookies,
      );
    }
  }
}
