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

extension BannerEntityX on BannerEntity? {
  /// True when the backend attached a deeplink to this banner, so the UI knows
  /// whether to make it tappable at all.
  bool get hasAction => this?.actionUri?.isNotEmpty ?? false;
}
