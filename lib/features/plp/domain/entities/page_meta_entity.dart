import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_meta_entity.freezed.dart';

@freezed
abstract class PageMetaEntity with _$PageMetaEntity {
  const factory PageMetaEntity({
    @Default(1) int page,
    @Default(20) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasNextPage,
    String? pageTitle,
    String? pageSubtitle,
    int? plpId,
    @Default(-1) int orderRule,
  }) = _PageMetaEntity;
}
