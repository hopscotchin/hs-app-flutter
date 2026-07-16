import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';

part 'visual_cue_model.g.dart';

@JsonSerializable(createToJson: false)
class VisualCueModel {
  const VisualCueModel({
    this.bgColor,
    this.text,
    this.textColor,
    this.location,
    this.uiType,
    this.imageUrl,
  });

  @JsonKey(defaultValue: null) final String? bgColor;
  @JsonKey(defaultValue: null) final String? text;
  @JsonKey(defaultValue: null) final String? textColor;
  @JsonKey(defaultValue: null) final String? location;
  @JsonKey(defaultValue: null) final String? uiType;
  @JsonKey(defaultValue: null) final String? imageUrl;

  factory VisualCueModel.fromJson(Map<String, dynamic> json) =>
      _$VisualCueModelFromJson(json);
}

extension VisualCueModelX on VisualCueModel {
  VisualCueEntity toEntity() => VisualCueEntity(
    bgColor: bgColor,
    text: text,
    textColor: textColor,
    location: location,
    uiType: uiType,
    imageUrl: imageUrl,
  );
}
