import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/page_meta_entity.dart';

part 'page_meta_model.g.dart';

int _parseOrderRule(dynamic value) => parseToIntOrNull(value) ?? -1;

@JsonSerializable(createToJson: false)
class PageMetaModel {
  const PageMetaModel({
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.hasNextPage = false,
    this.pageTitle,
    this.pageSubtitle,
    this.plpId,
    this.orderRule = -1,
  });

  @JsonKey(fromJson: parseToInt) final int page;
  @JsonKey(fromJson: parseToInt) final int pageSize;
  @JsonKey(fromJson: parseToInt) final int totalCount;
  @JsonKey(fromJson: parseToBool) final bool hasNextPage;
  @JsonKey(fromJson: parseToStringOrNull) final String? pageTitle;
  @JsonKey(fromJson: parseToStringOrNull) final String? pageSubtitle;
  @JsonKey(fromJson: parseToIntOrNull) final int? plpId;
  @JsonKey(fromJson: _parseOrderRule) final int orderRule;

  factory PageMetaModel.fromJson(Map<String, dynamic> json) =>
      _$PageMetaModelFromJson(json);

  PageMetaEntity toEntity() => PageMetaEntity(
    page: page,
    pageSize: pageSize,
    totalCount: totalCount,
    hasNextPage: hasNextPage,
    pageTitle: pageTitle,
    pageSubtitle: pageSubtitle,
    plpId: plpId,
    orderRule: orderRule,
  );
}
