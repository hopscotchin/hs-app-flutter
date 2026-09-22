import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../discover/domain/entities/home_page_entity.dart';

part 'categories_page_entity.freezed.dart';

/// `GET v2/loadDepartments` response — the Categories tab's full page
/// content, on the same component-driven shape as Home (`PageComponent`).
/// See `SEARCH_CATEGORIES_PAGE_API_CONTRACT.md` for the wire contract.
@freezed
abstract class CategoriesPageEntity with _$CategoriesPageEntity {
  const factory CategoriesPageEntity({
    String? action,
    PageMeta? pageMeta,
    String? searchPlaceHolder,
    @Default(<PageComponent>[]) List<PageComponent> pageComponents,
  }) = _CategoriesPageEntity;
}

extension CategoriesPageEntityX on CategoriesPageEntity {
  // null action = no explicit failure signalled; treat as success — same
  // convention as HomePageEntity.isSuccessful.
  bool get isSuccessful => action == null || action!.toLowerCase() == 'success';
}
