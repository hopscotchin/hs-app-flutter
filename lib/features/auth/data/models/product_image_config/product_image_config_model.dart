import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user_config/user_config_entity.dart';

part 'product_image_config_model.g.dart';

@JsonSerializable(createToJson: false)
class ProductImageConfigModel {
  const ProductImageConfigModel({
    this.aspectRatio,
    this.imageLayout,
    this.transformation,
  });

  final String? aspectRatio;
  final String? imageLayout;
  final String? transformation;

  factory ProductImageConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageConfigModelFromJson(json);
}

extension ProductImageConfigModelX on ProductImageConfigModel {
  ProductImageConfigEntity toEntity() => ProductImageConfigEntity(
    aspectRatio: aspectRatio,
    imageLayout: imageLayout,
    transformation: transformation,
  );
}
