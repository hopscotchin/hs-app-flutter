import '../../domain/entities/home_page_entity.dart';
import 'component_models.dart';

class PageComponentModel extends PageComponent {
  const PageComponentModel({
    required super.type,
    super.position,
    super.data,
    super.parsedData,
    super.margins,
  });

  factory PageComponentModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? '';
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return PageComponentModel(
      type: type,
      position: json['position'] as int? ?? 0,
      data: data,
      parsedData: ComponentDataParser.parseComponentData(type, data),
      margins: ComponentDataParser.parseMargins(
        data['margins'] as Map<String, dynamic>?,
      ),
    );
  }
}
