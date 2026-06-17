import '../../domain/entities/warning_entity.dart';

class WarningModel extends WarningEntity {
  const WarningModel({super.text, super.textColor});

  factory WarningModel.fromJson(Map<String, dynamic> json) {
    return WarningModel(
      text: json['text'] as String?,
      textColor: json['textColor'] as String?,
    );
  }
}
