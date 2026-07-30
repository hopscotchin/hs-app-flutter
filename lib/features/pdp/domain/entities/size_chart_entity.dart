import 'package:freezed_annotation/freezed_annotation.dart';

part 'size_chart_entity.freezed.dart';

@freezed
abstract class SizeChartEntity with _$SizeChartEntity {
  const factory SizeChartEntity({
    @Default([]) List<SizeChartDtoEntity> charts,
  }) = _SizeChartEntity;
}

@freezed
abstract class SizeChartDtoEntity with _$SizeChartDtoEntity {
  const factory SizeChartDtoEntity({
    String? illustrationImageUrl,

    /// Default length unit from API: "cm" or "in"
    String? lengthUnit,

    /// Default weight unit from API: "kg" or "lb"
    String? weightUnit,
    @Default([]) List<String> notesList,
    @Default([]) List<String> cueImageUrlList,

    /// Rows of table data; each row contains one value per column.
    @Default([]) List<SizeChartRowEntity> rows,

    /// Column header names (e.g. ["Size", "Chest", "Length"]).
    @Default([]) List<String> parameterNames,

    /// Per-column measure type: "L" for length, "W" for weight, else no conversion.
    @Default([]) List<String> parameterMeasureTypes,
    String? importantInfo,
  }) = _SizeChartDtoEntity;
}

@freezed
abstract class SizeChartRowEntity with _$SizeChartRowEntity {
  const factory SizeChartRowEntity({@Default([]) List<String> values}) =
      _SizeChartRowEntity;
}
