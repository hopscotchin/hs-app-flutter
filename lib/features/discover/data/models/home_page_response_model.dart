import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../domain/entities/home_page_entity.dart';
import 'page_component_model.dart';

part 'home_page_response_model.g.dart';

@JsonSerializable(createToJson: false)
class HomePageResponseModel {
  const HomePageResponseModel({
    this.action,
    this.popUpMessage,
    this.messageBars = const [],
    this.pageMeta,
    this.sortingOptions = const [],
    this.pageComponents = const [],
  });

  final String? action;
  final String? popUpMessage;
  @JsonKey(fromJson: _parseMessageBars)
  final List<MessageBarEntity> messageBars;

  @JsonKey(fromJson: _parsePageMeta)
  final PageMeta? pageMeta;

  @JsonKey(fromJson: _parseSortingOptions)
  final List<SortingOption> sortingOptions;

  @JsonKey(fromJson: _parseComponents)
  final List<PageComponentModel> pageComponents;

  factory HomePageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HomePageResponseModelFromJson(json);
}

List<PageComponentModel> _parseComponents(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map<String, dynamic>>()
      .map(PageComponentModel.fromJson)
      .toList();
}

List<MessageBarEntity> _parseMessageBars(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map<String, dynamic>>()
      .map(MessageBarModel.fromJson)
      .toList();
}

PageMeta? _parsePageMeta(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  return PageMeta(
    pageName: json['pageName'] as String?,
    pageId: (json['pageId'] as num?)?.toInt(),
    totalCollections: (json['totalCollections'] as num?)?.toInt() ?? 0,
    hasNextPage: json['hasNextPage'] as bool? ?? false,
    headerImageUrl: json['headerImageUrl'] as String?,
    isDarkHeader: json['isDarkHeader'] as bool? ?? false,
  );
}

List<SortingOption> _parseSortingOptions(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map<String, dynamic>>()
      .map(
        (e) => SortingOption(
          label: e['label'] as String? ?? '',
          id: e['id'] as String? ?? '',
        ),
      )
      .toList();
}

extension HomePageResponseModelX on HomePageResponseModel {
  HomePageEntity toEntity() => HomePageEntity(
    action: action,
    popUpMessage: popUpMessage,
    messageBars: messageBars,
    pageMeta: pageMeta,
    sortingOptions: sortingOptions,
    pageComponents: pageComponents.map((m) => m.toComponent()).toList(),
  );
}
