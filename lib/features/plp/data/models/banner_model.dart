import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/banner_entity.dart';

part 'banner_model.g.dart';

@JsonSerializable(createToJson: false)
class BannerModel {
  const BannerModel({this.imageUrl, this.height, this.width, this.title, this.actionUri});

  final String? imageUrl;
  final int? height;
  final int? width;
  @JsonKey(name: 'title')
  final String? title;
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
