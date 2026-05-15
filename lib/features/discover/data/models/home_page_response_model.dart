import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../domain/entities/home_page_entity.dart';
import 'page_component_model.dart';

part 'home_page_response_model.g.dart';

@JsonSerializable(createToJson: false)
class HomePageResponseModel {
  const HomePageResponseModel({
    this.pageName,
    this.pageBackgroundColor,
    this.headerBgImageUrl,
    this.totalCollections = 0,
    this.totalSections = 0,
    this.pageComponents = const [],
    this.action,
    this.popUpMessage,
    this.messageBars = const [],
  });

  final String? pageName;
  final String? pageBackgroundColor;
  final String? headerBgImageUrl;
  @JsonKey(defaultValue: 0)
  final int totalCollections;
  @JsonKey(defaultValue: 0)
  final int totalSections;
  @JsonKey(fromJson: _parseComponents)
  final List<PageComponentModel> pageComponents;
  final String? action;
  final String? popUpMessage;
  @JsonKey(fromJson: _parseMessageBars)
  final List<MessageBarEntity> messageBars;

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

extension HomePageResponseModelX on HomePageResponseModel {
  HomePageEntity toEntity() => HomePageEntity(
    action: action,
    popUpMessage: popUpMessage,
    messageBars: messageBars,
    pageName: pageName,
    pageBackgroundColor: pageBackgroundColor,
    headerBgImageUrl: headerBgImageUrl,
    totalCollections: totalCollections,
    totalSections: totalSections,
    pageComponents: pageComponents.map((m) => m.toComponent()).toList(),
  );
}
