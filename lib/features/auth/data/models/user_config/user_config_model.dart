import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user_config/user_config_entity.dart';
import '../product_image_config/product_image_config_model.dart';

part 'user_config_model.g.dart';

@JsonSerializable(createToJson: false)
class UserConfigModel {
  const UserConfigModel({this.productImageConfig});

  final ProductImageConfigModel? productImageConfig;

  factory UserConfigModel.fromJson(Map<String, dynamic> json) =>
      _$UserConfigModelFromJson(json);
}

extension UserConfigModelX on UserConfigModel {
  UserConfigEntity toEntity() =>
      UserConfigEntity(productImageConfig: productImageConfig?.toEntity());
}
