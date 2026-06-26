import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/tracking_meta_entity.dart';

part 'tracking_meta_model.g.dart';

@JsonSerializable(createToJson: false)
class TrackingMetaModel {
  const TrackingMetaModel({
    this.clusteringExistsForListingPage = false,
    this.excludePreorderFilterApplied = false,
    this.hasXLTiles = false,
    this.plpId,
  });

  @JsonKey(fromJson: parseToBool) final bool clusteringExistsForListingPage;
  @JsonKey(fromJson: parseToBool) final bool excludePreorderFilterApplied;
  @JsonKey(fromJson: parseToBool) final bool hasXLTiles;
  @JsonKey(fromJson: parseToIntOrNull) final int? plpId;

  factory TrackingMetaModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingMetaModelFromJson(json);

  TrackingMetaEntity toEntity() => TrackingMetaEntity(
    clusteringExistsForListingPage: clusteringExistsForListingPage,
    excludePreorderFilterApplied: excludePreorderFilterApplied,
    hasXLTiles: hasXLTiles,
    plpId: plpId,
  );
}
