import '../entities/visual_cue_entity.dart';

class VisualCueModel extends VisualCueEntity {
  const VisualCueModel({
    super.bgColor,
    super.text,
    super.textColor,
    super.location,
    super.uiType,
    super.imageUrl,
  });

  factory VisualCueModel.fromJson(Map<String, dynamic> json) {
    return VisualCueModel(
      bgColor: json['backgroundColor'] as String?,
      text: json['text'] as String?,
      textColor: json['textColor'] as String?,
      location: json['location'] as String?,
      uiType: json['uiType'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
