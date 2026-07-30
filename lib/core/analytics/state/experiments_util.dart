import 'package:injectable/injectable.dart';

import '../../services/pref_manager.dart';

/// Runtime + persisted view of the EXPERIMENTS cookie. Cookie interceptor
/// writes [experimentCookies]; identify reads [experimentsList].
@lazySingleton
class ExperimentsUtil {
  ExperimentsUtil(this._prefs);

  final PrefManager _prefs;

  String? experimentCookies;

  String? get previousExperimentCookies => _prefs.previousExperiments;

  Future<void> setPreviousExperimentCookies(String? value) =>
      _prefs.setPreviousExperiments(value);

  List<String> get experimentsList {
    final raw = experimentCookies;
    if (raw == null || raw.isEmpty) return const <String>[];
    return raw.split(',');
  }
}
