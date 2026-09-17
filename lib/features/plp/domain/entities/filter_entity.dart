import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';

part 'filter_entity.freezed.dart';

@freezed
abstract class FilterEntity with _$FilterEntity {
  const factory FilterEntity({
    String? filterKey,
    String? filterValue,
    int? count,
    String? label,
    @Default(false) bool isSelected,
    @Default(false) bool isMultiSelect,
    String? type,
    @Default([]) List<FilterEntity> filters,
    String? colorHex,
    String? ovalImgUrl,
    @Default(false) bool isSection,
    String? pincode,
    VisualCueEntity? visualCue,

    /// Analytics blob for this leaf. Carries `sectionTracking` — the analytics
    /// name for the section, deliberately different from [filterKey] (`browse`
    /// on the wire is `department` in Segment) — and `isAttribute`, which
    /// decides whether a selection lands in `filter_attribute`.
    ///
    /// Forwarded verbatim; see PLP_ANALYTICS_BACKEND_CONTRACT.md.
    Map<String, dynamic>? trackingMeta,
  }) = _FilterEntity;
}
