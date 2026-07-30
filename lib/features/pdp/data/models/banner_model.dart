import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/banner_entity.dart';
import 'media_model.dart';

part 'banner_model.g.dart';

@JsonSerializable(createToJson: false)
class BannerModel {
  const BannerModel({this.actionUri, this.id, this.media, this.position});

  @JsonKey(defaultValue: null)
  final String? actionUri;
  @JsonKey(defaultValue: null, fromJson: _idFromJson)
  final String? id;
  @JsonKey(defaultValue: null, fromJson: _mediaFromJson)
  final MediaModel? media;
  @JsonKey(defaultValue: null, fromJson: _positionFromJson)
  final int? position;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}

String? _idFromJson(Object? json) => json?.toString();

MediaModel? _mediaFromJson(Object? json) =>
    json is Map<String, dynamic> ? MediaModel.fromJson(json) : null;

int? _positionFromJson(Object? json) {
  if (json is int) return json;
  if (json is String) return int.tryParse(json);
  return null;
}

extension BannerModelX on BannerModel {
  BannerEntity toEntity() => BannerEntity(
    actionUri: actionUri,
    id: id,
    media: media?.toEntity(),
    position: position,
  );
}
