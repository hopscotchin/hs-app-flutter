import 'package:equatable/equatable.dart';

class ColorVariantsEntity extends Equatable {
  final String? heading;
  final MediaMetaDataEntity? mediaMetaData;
  final List<ColorVariantEntity> variants;

  const ColorVariantsEntity({
    this.heading,
    this.mediaMetaData,
    this.variants = const [],
  });

  @override
  List<Object?> get props => [heading, mediaMetaData, variants];
}

class ColorVariantEntity extends Equatable {
  final int? productId;
  final List<String> colors;
  final String? mediaUrl;

  const ColorVariantEntity({
    this.productId,
    this.colors = const [],
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [productId, colors, mediaUrl];
}

class MediaMetaDataEntity extends Equatable {
  final int? width;
  final int? height;

  const MediaMetaDataEntity({this.width, this.height});

  @override
  List<Object?> get props => [width, height];
}
