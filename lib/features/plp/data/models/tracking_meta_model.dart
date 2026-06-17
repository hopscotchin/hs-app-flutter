import 'package:json_annotation/json_annotation.dart';

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

  @JsonKey(defaultValue: false) final bool clusteringExistsForListingPage;
  @JsonKey(defaultValue: false) final bool excludePreorderFilterApplied;
  @JsonKey(defaultValue: false) final bool hasXLTiles;
  final int? plpId;

  factory TrackingMetaModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingMetaModelFromJson(json);

  TrackingMetaEntity toEntity() => TrackingMetaEntity(
    clusteringExistsForListingPage: clusteringExistsForListingPage,
    excludePreorderFilterApplied: excludePreorderFilterApplied,
    hasXLTiles: hasXLTiles,
    plpId: plpId,
  );
}
