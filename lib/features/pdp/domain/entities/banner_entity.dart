import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_entity.dart';

part 'banner_entity.freezed.dart';

@freezed
abstract class BannerEntity with _$BannerEntity {
  const factory BannerEntity({
    String? actionUri,
    String? id,
    MediaEntity? media,
    int? position,
  }) = _BannerEntity;
}
