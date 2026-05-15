import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_page_entity.dart';
import 'component_models.dart';

part 'page_component_model.g.dart';

@JsonSerializable(createToJson: false)
class PageComponentModel {
  const PageComponentModel({
    required this.type,
    this.position = 0,
    this.rawData,
    this.parsedData,
    this.margins,
  });

  @JsonKey(defaultValue: '')
  final String type;

  @JsonKey(defaultValue: 0)
  final int position;

  /// Raw JSON data map for this component (may be nested under 'data' key or at root).
  @JsonKey(name: 'data', fromJson: _rawDataFromJson, includeToJson: false)
  final Map<String, dynamic>? rawData;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Object? parsedData;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ComponentMargins? margins;

  factory PageComponentModel.fromJson(Map<String, dynamic> json) {
    // Use generated code for annotated fields (type, position, rawData).
    final base = _$PageComponentModelFromJson(json);
    final type = base.type;
    // 'data' may be a nested object OR absent (data lives at root).
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return PageComponentModel(
      type: type,
      position: base.position,
      rawData: data,
      parsedData: ComponentDataParser.parseComponentData(type, data),
      // margins may live inside data, inside data.viewConfig, or at root
      margins: ComponentDataParser.parseMargins(
        (data['margins']
                ?? (data['viewConfig'] as Map<String, dynamic>?)?['margins']
                ?? json['margins'])
            as Map<String, dynamic>?,
      ),
    );
  }
}

Map<String, dynamic>? _rawDataFromJson(Object? json) =>
    json is Map<String, dynamic> ? json : null;

extension PageComponentModelX on PageComponentModel {
  PageComponent toComponent() => PageComponent(
    type: type,
    position: position,
    data: rawData,
    parsedData: parsedData,
    margins: margins,
  );
}
