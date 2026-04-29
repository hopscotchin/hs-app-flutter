import '../../domain/entities/home_page_entity.dart';
import 'page_component_model.dart';

class HomePageResponseModel extends HomePageEntity {
  const HomePageResponseModel({
    super.pageName,
    super.pageBackgroundColor,
    super.totalCollections,
    super.totalSections,
    super.pageComponents,
  });

  HomePageResponseModel.fromJson(super.json)
      : super.fromJson(
          pageName: json['pageName'] as String?,
          pageBackgroundColor: json['pageBackgroundColor'] as String?,
          totalCollections: json['totalCollections'] as int? ?? 0,
          totalSections: json['totalSections'] as int? ?? 0,
          pageComponents: _parseComponents(json),
        );

  static List<PageComponent> _parseComponents(Map<String, dynamic> json) {
    final rawComponents = json['pageComponents'] as List<dynamic>? ?? [];
    return rawComponents
        .map((e) => PageComponentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
