import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/media_entity.dart';

part 'media_model.g.dart';

@JsonSerializable(createToJson: false)
class MediaModel {
  const MediaModel({this.height, this.mimeType, this.url, this.width});

  @JsonKey(defaultValue: null) final int? height;
  @JsonKey(defaultValue: null) final String? mimeType;
  @JsonKey(defaultValue: null) final String? url;
  @JsonKey(defaultValue: null) final int? width;

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);
}

extension MediaModelX on MediaModel {
  MediaEntity toEntity() =>
      MediaEntity(height: height, mimeType: mimeType, url: url, width: width);
}
