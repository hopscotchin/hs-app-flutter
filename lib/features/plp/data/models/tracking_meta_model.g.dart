// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingMetaModel _$TrackingMetaModelFromJson(Map<String, dynamic> json) =>
    TrackingMetaModel(
      clusteringExistsForListingPage:
          json['clusteringExistsForListingPage'] as bool? ?? false,
      excludePreorderFilterApplied:
          json['excludePreorderFilterApplied'] as bool? ?? false,
      hasXLTiles: json['hasXLTiles'] as bool? ?? false,
      plpId: (json['plpId'] as num?)?.toInt(),
    );
