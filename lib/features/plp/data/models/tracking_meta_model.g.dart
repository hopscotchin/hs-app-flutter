// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingMetaModel _$TrackingMetaModelFromJson(Map<String, dynamic> json) =>
    TrackingMetaModel(
      clusteringExistsForListingPage:
          json['clusteringExistsForListingPage'] == null
          ? false
          : parseToBool(json['clusteringExistsForListingPage']),
      excludePreorderFilterApplied: json['excludePreorderFilterApplied'] == null
          ? false
          : parseToBool(json['excludePreorderFilterApplied']),
      hasXLTiles: json['hasXLTiles'] == null
          ? false
          : parseToBool(json['hasXLTiles']),
      plpId: parseToIntOrNull(json['plpId']),
    );
