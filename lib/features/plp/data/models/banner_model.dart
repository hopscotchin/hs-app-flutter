import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/banner_entity.dart';

part 'banner_model.g.dart';

@JsonSerializable(createToJson: false)
class BannerModel {
  const BannerModel({this.imageUrl, this.height, this.width, this.title, this.actionUri});

  @JsonKey(fromJson: parseToStringOrNull)
  final String? imageUrl;
  @JsonKey(fromJson: parseToIntOrNull) final int? height;
  @JsonKey(fromJson: parseToIntOrNull) final int? width;
  @JsonKey(name: 'title', fromJson: parseToStringOrNull)
  final String? title;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? actionUri;

  factory BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);

  BannerEntity toEntity() => BannerEntity(
    imageUrl: imageUrl,
    aspectRatio: _computeAspectRatio(),
    altText: title,
    actionUri: actionUri,
  );

  double _computeAspectRatio() {
    if (height == null || width == null || height == 0) return 1.0;
    return width! / height!;
  }
}
