import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_entity.freezed.dart';

@freezed
abstract class BannerEntity with _$BannerEntity {
  const factory BannerEntity({
    String? imageUrl,
    @Default(1.0) double aspectRatio,
    String? altText,
    String? actionUri,
  }) = _BannerEntity;
}
