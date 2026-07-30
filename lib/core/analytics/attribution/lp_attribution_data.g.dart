// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lp_attribution_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LpAttributionEntry _$LpAttributionEntryFromJson(Map<String, dynamic> json) =>
    _LpAttributionEntry(
      meta: json['meta'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      landingPageName: json['landingPageName'] as String?,
      landingPageId: json['landingPageId'] as String?,
    );

Map<String, dynamic> _$LpAttributionEntryToJson(_LpAttributionEntry instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'landingPageName': instance.landingPageName,
      'landingPageId': instance.landingPageId,
    };
