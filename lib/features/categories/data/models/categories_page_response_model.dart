import 'package:json_annotation/json_annotation.dart';

import '../../../discover/data/models/home_page_response_model.dart';
import '../../../discover/data/models/page_component_model.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../../domain/entities/categories_page_entity.dart';

part 'categories_page_response_model.g.dart';

/// `GET v2/loadDepartments` response model. Reuses Home's `PageMeta`/
/// `PageComponentModel` parsing (`parsePageMetaJson`) so both endpoints stay
/// on one JSON contract, per `SEARCH_CATEGORIES_PAGE_API_CONTRACT.md` §0.
@JsonSerializable(createToJson: false)
class CategoriesPageResponseModel {
  const CategoriesPageResponseModel({
    this.action,
    this.pageMeta,
    this.searchPlaceHolder,
    this.pageComponents = const [],
  });

  final String? action;

  @JsonKey(fromJson: parsePageMetaJson)
  final PageMeta? pageMeta;
  final String? searchPlaceHolder;

  @JsonKey(fromJson: _parseComponents)
  final List<PageComponentModel> pageComponents;

  factory CategoriesPageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesPageResponseModelFromJson(json);
}

List<PageComponentModel> _parseComponents(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map<String, dynamic>>()
      .map(PageComponentModel.fromJson)
      .toList();
}

extension CategoriesPageResponseModelX on CategoriesPageResponseModel {
  CategoriesPageEntity toEntity() => CategoriesPageEntity(
    action: action,
    pageMeta: pageMeta,
    searchPlaceHolder: searchPlaceHolder,
    pageComponents: pageComponents.map((m) => m.toComponent()).toList(),
  );
}
