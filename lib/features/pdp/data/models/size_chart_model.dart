import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/size_chart_entity.dart';

part 'size_chart_model.g.dart';

@JsonSerializable(createToJson: false)
class SizeChartModel {
  const SizeChartModel({this.sizeChartDTOList = const []});

  @JsonKey(defaultValue: [])
  final List<SizeChartDtoModel> sizeChartDTOList;

  factory SizeChartModel.fromJson(Map<String, dynamic> json) =>
      _$SizeChartModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class SizeChartDtoModel {
  const SizeChartDtoModel({
    this.illustrationImageUrl,
    this.lengthUnit,
    this.weightUnit,
    this.notesList = const [],
    this.cueImageUrlList = const [],
    this.sizeChartParameterValueDTOList = const [],
    this.parameterNamesList = const [],
    this.parameterMeasureTypeList = const [],
    this.importantInfo,
  });

  final String? illustrationImageUrl;
  final String? lengthUnit;
  final String? weightUnit;
  @JsonKey(defaultValue: []) final List<String> notesList;
  @JsonKey(defaultValue: []) final List<String> cueImageUrlList;
  @JsonKey(defaultValue: [])
  final List<SizeChartParameterValueModel> sizeChartParameterValueDTOList;
  @JsonKey(defaultValue: []) final List<String> parameterNamesList;
  @JsonKey(defaultValue: []) final List<String> parameterMeasureTypeList;
  final String? importantInfo;

  factory SizeChartDtoModel.fromJson(Map<String, dynamic> json) =>
      _$SizeChartDtoModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class SizeChartParameterValueModel {
  const SizeChartParameterValueModel({this.valueList = const []});

  @JsonKey(defaultValue: []) final List<String> valueList;

  factory SizeChartParameterValueModel.fromJson(Map<String, dynamic> json) =>
      _$SizeChartParameterValueModelFromJson(json);
}

extension SizeChartModelX on SizeChartModel {
  SizeChartEntity toEntity() => SizeChartEntity(
    charts: sizeChartDTOList.map((dto) => dto.toEntity()).toList(),
  );
}

extension SizeChartDtoModelX on SizeChartDtoModel {
  SizeChartDtoEntity toEntity() => SizeChartDtoEntity(
    illustrationImageUrl: illustrationImageUrl,
    lengthUnit: lengthUnit,
    weightUnit: weightUnit,
    notesList: notesList,
    cueImageUrlList: cueImageUrlList,
    rows: sizeChartParameterValueDTOList
        .map((r) => SizeChartRowEntity(values: r.valueList))
        .toList(),
    parameterNames: parameterNamesList,
    parameterMeasureTypes: parameterMeasureTypeList,
    importantInfo: importantInfo,
  );
}
