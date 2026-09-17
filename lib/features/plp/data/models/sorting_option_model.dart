import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/sorting_option_entity.dart';

part 'sorting_option_model.g.dart';

@JsonSerializable(createToJson: false)
class SortingOptionModel {
  const SortingOptionModel({
    this.label,
    this.orderRule = 0,
    this.isSelected = false,
    this.eventSortName,
  });

  @JsonKey(fromJson: parseToStringOrNull) final String? label;
  @JsonKey(fromJson: parseToInt) final int orderRule;
  @JsonKey(fromJson: parseToBool) final bool isSelected;

  /// Analytics name for this option, e.g. `PriceHighLow`. Sent at the option's
  /// top level; this is what `sorting_applied` reports, not [label].
  @JsonKey(fromJson: parseToStringOrNull) final String? eventSortName;

  factory SortingOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SortingOptionModelFromJson(json);

  SortingOptionEntity toEntity() => SortingOptionEntity(
    label: label,
    orderRule: orderRule,
    isSelected: isSelected,
    eventSortName: eventSortName,
  );
}
