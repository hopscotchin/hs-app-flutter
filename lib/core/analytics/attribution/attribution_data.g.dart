// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribution_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttributionData _$AttributionDataFromJson(Map<String, dynamic> json) =>
    _AttributionData(
      trackingMeta:
          json['trackingMeta'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      funnel: json['funnel'] as String?,
      sortBar: json['sortBar'] as String?,
    );

Map<String, dynamic> _$AttributionDataToJson(_AttributionData instance) =>
    <String, dynamic>{
      'trackingMeta': instance.trackingMeta,
      'funnel': instance.funnel,
      'sortBar': instance.sortBar,
    };
