import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_meta_entity.freezed.dart';

@freezed
abstract class TrackingMetaEntity with _$TrackingMetaEntity {
  const factory TrackingMetaEntity({
    @Default(false) bool clusteringExistsForListingPage,
    @Default(false) bool excludePreorderFilterApplied,
    @Default(false) bool hasXLTiles,
    int? plpId,
  }) = _TrackingMetaEntity;
}
