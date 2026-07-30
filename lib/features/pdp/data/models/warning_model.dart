import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/warning_entity.dart';

part 'warning_model.g.dart';

@JsonSerializable(createToJson: false)
class WarningModel {
  const WarningModel({this.text, this.textColor});

  @JsonKey(defaultValue: null)
  final String? text;
  @JsonKey(defaultValue: null)
  final String? textColor;

  factory WarningModel.fromJson(Map<String, dynamic> json) =>
      _$WarningModelFromJson(json);
}

extension WarningModelX on WarningModel {
  WarningEntity toEntity() => WarningEntity(text: text, textColor: textColor);
}
