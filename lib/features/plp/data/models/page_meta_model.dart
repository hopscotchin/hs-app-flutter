import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/page_meta_entity.dart';

part 'page_meta_model.g.dart';

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

  @JsonKey(defaultValue: 1) final int page;
  @JsonKey(defaultValue: 20) final int pageSize;
  @JsonKey(defaultValue: 0) final int totalCount;
  @JsonKey(defaultValue: false) final bool hasNextPage;
  final String? pageTitle;
  final String? pageSubtitle;
  final int? plpId;
  @JsonKey(defaultValue: -1) final int orderRule;

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
