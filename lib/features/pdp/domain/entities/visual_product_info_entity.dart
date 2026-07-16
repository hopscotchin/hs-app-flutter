import 'package:freezed_annotation/freezed_annotation.dart';

part 'visual_product_info_entity.freezed.dart';

@freezed
abstract class VisualProductInfoEntity with _$VisualProductInfoEntity {
  const factory VisualProductInfoEntity({
    String? groupName,
    @Default([]) List<VisualProductItemEntity> items,
    String? title,
  }) = _VisualProductInfoEntity;
}

@freezed
abstract class VisualProductItemEntity with _$VisualProductItemEntity {
  const factory VisualProductItemEntity({
    String? id,
    String? name,
    String? type,
    String? url,
  }) = _VisualProductItemEntity;
}
