import '../../domain/entities/floating_filter_entity.dart';

class FloatingFilterTileModel extends FloatingFilterTileEntity {
  const FloatingFilterTileModel({
    super.id,
    super.name,
    super.param,
    super.imageUrl,
    super.text,
    super.color,
    super.bgColor,
    super.isSelected,
  });

  factory FloatingFilterTileModel.fromJson(Map<String, dynamic> json) {
    return FloatingFilterTileModel(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      param: json['param'] as String?,
      imageUrl: json['imageUrl'] as String?,
      text: json['text'] as String?,
      color: json['color'] as String?,
      bgColor: json['bgColor'] as String?,
      isSelected: json['isSelected']?.toString(),
    );
  }
}

class FloatingFilterSectionModel extends FloatingFilterSectionEntity {
  const FloatingFilterSectionModel({
    super.title,
    super.type,
    super.position,
    super.tileWidth,
    super.tileHeight,
    super.carouselType,
    super.tiles,
  });

  factory FloatingFilterSectionModel.fromJson(Map<String, dynamic> json) {
    return FloatingFilterSectionModel(
      title: json['title'] as String?,
      type: json['type'] as String?,
      position: (json['position'] as num?)?.toInt(),
      tileWidth: (json['tileWidth'] as num?)?.toInt(),
      tileHeight: (json['tileHeight'] as num?)?.toInt(),
      carouselType: json['carouselType'] as String?,
      tiles:
          (json['tiles'] as List<dynamic>?)
              ?.map(
                (e) =>
                    FloatingFilterTileModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}

class FloatingFilterModel extends FloatingFilterEntity {
  const FloatingFilterModel({super.type, super.sections});

  factory FloatingFilterModel.fromJson(Map<String, dynamic> json) {
    return FloatingFilterModel(
      type: json['type'] as String?,
      sections:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => FloatingFilterSectionModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );
  }
}
