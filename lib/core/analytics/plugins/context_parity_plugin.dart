import 'package:flutter/foundation.dart';
import 'package:segment_analytics/event.dart';
import 'package:segment_analytics/plugin.dart';

import '../../services/pref_manager.dart';

/// Aligns Flutter Segment SDK's `context` block with Android Java SDK's
/// wire format: refreshes `context.traits` per event and mirrors trait
/// `advertisingId` into `context.device`.
class ContextParityPlugin extends EventPlugin {
  ContextParityPlugin(this._prefs) : super(PluginType.enrichment);

  final PrefManager _prefs;

  @override
  Future<RawEvent?> execute(RawEvent event) async {
    final context = event.context;
    if (context == null) return event;

    final userInfo = await analytics!.state.userInfo.state;
    final userTraits = userInfo.userTraits;
    if (userTraits != null) {
      context.traits = userTraits;
    }

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final adId = _prefs.advertisingId;
    if (adId != null && adId.isNotEmpty) {
      context.device.advertisingId = adId;
      context.device.adTrackingEnabled = true;
      // Not a built-in ContextDevice field; routed through `custom` so it
      // lands at `context.device.advertisingIdType` on the wire.
      context.device.custom['advertisingIdType'] = isAndroid ? 'AAID' : 'IDFA';
    }

    return event;
  }

  @override
  Future<void> flush() async {}

  @override
  void reset() {}
}
