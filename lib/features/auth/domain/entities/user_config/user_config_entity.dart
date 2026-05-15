import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_config_entity.freezed.dart';

@freezed
abstract class ProductImageConfigEntity with _$ProductImageConfigEntity {
  const factory ProductImageConfigEntity({
    String? aspectRatio,
    String? imageLayout,
    String? transformation,
  }) = _ProductImageConfigEntity;
}

@freezed
abstract class UserConfigEntity with _$UserConfigEntity {
  const factory UserConfigEntity({
    @Default(false) bool continueBrowsingEligibleVisitor,
    ProductImageConfigEntity? productImageConfig,
  }) = _UserConfigEntity;
}
