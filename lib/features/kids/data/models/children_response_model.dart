import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/message_bar_model.dart';
import '../../domain/entities/kids_list_content_entity.dart';
import 'add_child_container_model.dart';
import 'child_model.dart';
import 'empty_state_model.dart';

part 'children_response_model.g.dart';

/// `GET v2/questionnaire/list` response. The My Kids list screen's
/// backend-driven copy (`emptyState`, `addChildContainer`, `messageBar`) now
/// arrives as direct siblings of `children` — no more `content` wrapper.
@JsonSerializable(createToJson: false)
class ChildrenResponseModel {
  const ChildrenResponseModel({
    this.action,
    this.message,
    this.children = const [],
    this.emptyState,
    this.addChildContainer,
    this.messageBar,
  });

  final String? action;
  final String? message;
  @JsonKey(defaultValue: []) final List<ChildModel> children;
  final EmptyStateModel? emptyState;
  final AddChildContainerModel? addChildContainer;
  final MessageBarModel? messageBar;

  factory ChildrenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChildrenResponseModelFromJson(json);
}

extension ChildrenResponseModelX on ChildrenResponseModel {
  bool get isSuccess => action?.toLowerCase() == 'success';

  KidsListContentEntity toContentEntity() {
    final fallback = KidsListContentEntity.fallback();
    return KidsListContentEntity(
      emptyStateTitle: emptyState?.title ?? fallback.emptyStateTitle,
      emptyStateSubtitle: emptyState?.subTitle ?? fallback.emptyStateSubtitle,
      emptyStateIcon: emptyState?.icon,
      // No local fallback copy for this one — null means no banner at all.
      messageBar: messageBar,
      addChildTitle: addChildContainer?.title ?? fallback.addChildTitle,
      addChildSubtitle: addChildContainer?.subTitle ?? fallback.addChildSubtitle,
      addChildLeadingIcon: addChildContainer?.leadingIcon,
      addChildTrailingIcon: addChildContainer?.trailingIcon,
    );
  }
}
