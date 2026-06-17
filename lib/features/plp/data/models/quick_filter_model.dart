import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/quick_filter_entity.dart';

part 'quick_filter_model.g.dart';

@JsonSerializable(createToJson: false)
class QuickFilterModel {
  const QuickFilterModel({
    this.filterKey,
    this.label,
    this.isApplied = false,
    this.trackingMeta = const <String, dynamic>{},
  });

  final String? filterKey;
  final String? label;
  @JsonKey(defaultValue: false) final bool isApplied;
  @JsonKey(defaultValue: <String, dynamic>{}) final Map<String, dynamic> trackingMeta;

  factory QuickFilterModel.fromJson(Map<String, dynamic> json) =>
      _$QuickFilterModelFromJson(json);

  QuickFilterEntity toEntity() => QuickFilterEntity(
    filterKey: filterKey,
    label: label,
    isApplied: isApplied,
    trackingMeta: trackingMeta,
  );
}
