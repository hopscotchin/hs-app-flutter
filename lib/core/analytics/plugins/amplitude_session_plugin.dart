import 'package:segment_analytics/event.dart';
import 'package:segment_analytics/plugin.dart';

import '../../services/pref_manager.dart';
import '../constants/analytics_defaults.dart';
import '../constants/analytics_properties.dart';

/// Injects `integrations.Amplitude = {session_id: ...}` on every event
/// (Flutter Segment SDK has no per-event Options API).
class AmplitudeSessionPlugin extends EventPlugin {
  AmplitudeSessionPlugin(this._prefs) : super(PluginType.enrichment);

  final PrefManager _prefs;

  @override
  Future<RawEvent?> execute(RawEvent event) async {
    final sessionId = _prefs.startSessionId;
    if (sessionId == null || sessionId.isEmpty) return event;
    final integrations = Map<String, dynamic>.from(event.integrations ?? {});
    integrations[AnalyticsDefaults.integrationAmplitude] = <String, dynamic>{
      AnalyticsProperties.sessionId: sessionId,
    };
    event.integrations = integrations;
    return event;
  }

  @override
  Future<void> flush() async {}

  @override
  void reset() {}
}
