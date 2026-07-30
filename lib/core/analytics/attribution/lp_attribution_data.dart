// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'lp_attribution_data.freezed.dart';
part 'lp_attribution_data.g.dart';

/// One landing-page visit in the LP attribution deque. `meta` is the opaque
/// merged `trackingMeta` blob from the tile tap that entered this LP; name/id
/// are the client-owned identity of the landing page being entered.
@freezed
abstract class LpAttributionEntry with _$LpAttributionEntry {
  const factory LpAttributionEntry({
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
    String? landingPageName,
    String? landingPageId,
  }) = _LpAttributionEntry;

  factory LpAttributionEntry.fromJson(Map<String, dynamic> json) =>
      _$LpAttributionEntryFromJson(json);
}
