// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_chart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeChartModel _$SizeChartModelFromJson(Map<String, dynamic> json) =>
    SizeChartModel(
      sizeChartDTOList:
          (json['sizeChartDTOList'] as List<dynamic>?)
              ?.map(
                (e) => SizeChartDtoModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

SizeChartDtoModel _$SizeChartDtoModelFromJson(Map<String, dynamic> json) =>
    SizeChartDtoModel(
      illustrationImageUrl: json['illustrationImageUrl'] as String?,
      lengthUnit: json['lengthUnit'] as String?,
      weightUnit: json['weightUnit'] as String?,
      notesList:
          (json['notesList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      cueImageUrlList:
          (json['cueImageUrlList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      sizeChartParameterValueDTOList:
          (json['sizeChartParameterValueDTOList'] as List<dynamic>?)
              ?.map(
                (e) => SizeChartParameterValueModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      parameterNamesList:
          (json['parameterNamesList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      parameterMeasureTypeList:
          (json['parameterMeasureTypeList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      importantInfo: json['importantInfo'] as String?,
    );

SizeChartParameterValueModel _$SizeChartParameterValueModelFromJson(
  Map<String, dynamic> json,
) => SizeChartParameterValueModel(
  valueList:
      (json['valueList'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);
