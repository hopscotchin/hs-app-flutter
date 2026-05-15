import 'package:equatable/equatable.dart';

class FloatingFilterTileEntity extends Equatable {
  final String? id;
  final String? name;
  final String? param;
  final String? imageUrl;
  final String? text;
  final String? color;
  final String? bgColor;
  final String? isSelected;

  const FloatingFilterTileEntity({
    this.id,
    this.name,
    this.param,
    this.imageUrl,
    this.text,
    this.color,
    this.bgColor,
    this.isSelected,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    param,
    imageUrl,
    text,
    color,
    bgColor,
    isSelected,
  ];
}

class FloatingFilterSectionEntity extends Equatable {
  final String? title;
  final String? type;
  final int? position;
  final int? tileWidth;
  final int? tileHeight;
  final String? carouselType;
  final List<FloatingFilterTileEntity> tiles;

  const FloatingFilterSectionEntity({
    this.title,
    this.type,
    this.position,
    this.tileWidth,
    this.tileHeight,
    this.carouselType,
    this.tiles = const [],
  });

  @override
  List<Object?> get props => [
    title,
    type,
    position,
    tileWidth,
    tileHeight,
    carouselType,
    tiles,
  ];
}

class FloatingFilterEntity extends Equatable {
  final String? type;
  final List<FloatingFilterSectionEntity> sections;

  const FloatingFilterEntity({this.type, this.sections = const []});

  @override
  List<Object?> get props => [type, sections];
}
