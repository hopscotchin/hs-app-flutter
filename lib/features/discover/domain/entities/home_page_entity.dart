import 'package:equatable/equatable.dart';

import '../../../../core/network/models/action_response.dart';

class HomePageEntity extends ActionResponse {
  final String? pageName;
  final String? pageBackgroundColor;
  final int totalCollections;
  final int totalSections;
  final List<PageComponent> pageComponents;

  const HomePageEntity({
    super.action,
    super.message,
    super.errorMsg,
    this.pageName,
    this.pageBackgroundColor,
    this.totalCollections = 0,
    this.totalSections = 0,
    this.pageComponents = const [],
  });

  HomePageEntity.fromJson(
    super.json, {
    this.pageName,
    this.pageBackgroundColor,
    this.totalCollections = 0,
    this.totalSections = 0,
    this.pageComponents = const [],
  }) : super.fromJson();

  @override
  List<Object?> get props => [
        action,
        pageName,
        pageBackgroundColor,
        totalCollections,
        totalSections,
        pageComponents,
      ];
}

/// Mirrors Android's PageComponent class.
/// Each component has a `type` and a generic `data` object
/// that is parsed differently based on the type.
class PageComponent extends Equatable {
  final String type;
  final int position;
  final Map<String, dynamic>? data;

  /// Pre-parsed typed data to avoid repeated JSON parsing during builds.
  final Object? parsedData;

  /// Margins from the API controlling outer and inner spacing.
  final ComponentMargins? margins;

  const PageComponent({
    required this.type,
    this.position = 0,
    this.data,
    this.parsedData,
    this.margins,
  });

  @override
  List<Object?> get props => [type, position, data, margins];
}

/// Type constants matching Android's PageComponent.TYPE_* constants
class PageComponentType {
  static const String hero = 'Hero';
  static const String collection = 'Collection';
  static const String customTiles = 'CustomTiles';
  static const String pageCarousel = 'PageCarousel';
  static const String tabbedCustomTiles = 'TABBED_CUSTOM_TILES';
  static const String tabbedDecorationFinder = 'TABBED_DECORATION_FINDER';
  static const String productGrid = 'PRODUCT_GRID';
  static const String productGridRow = 'PRODUCT_GRID_ROW';
  static const String ctaButton = 'CTA_BUTTON';
  static const String testimonial = 'TESTIMONIALS';
  static const String continueBrowsing = 'CONTINUE_BROWSING';
  static const String childrenManager = 'CHILDREN_MANAGER';
  static const String shopTheLook = 'SHOP_THE_LOOK';
  static const String webContent = 'WEB_CONTENT';
}

// ─── Parsed data models extracted from the `data` field ───

class HeroCarouselData extends Equatable {
  final String? title;
  final String? sectionName;
  final int? scrollDuration;
  final String? transitionType;
  final String? useCase;
  final List<HeroTile> tiles;

  const HeroCarouselData({
    this.title,
    this.sectionName,
    this.scrollDuration,
    this.transitionType,
    this.useCase,
    this.tiles = const [],
  });

  @override
  List<Object?> get props =>
      [title, sectionName, scrollDuration, transitionType, useCase, tiles];
}

class HeroTile extends Equatable {
  final String imageUrl;
  final String? actionUri;
  final int width;
  final int height;

  const HeroTile({
    required this.imageUrl,
    this.actionUri,
    this.width = 960,
    this.height = 960,
  });

  double get aspectRatio => width / height;

  @override
  List<Object?> get props => [imageUrl, actionUri, width, height];
}

class CollectionData extends Equatable {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? actionUrl;
  final bool? showInBoutiqueSetting;
  final String? pageId;

  const CollectionData({
    this.id,
    this.name,
    this.imageUrl,
    this.actionUrl,
    this.showInBoutiqueSetting,
    this.pageId,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, actionUrl];
}

class CustomTilesData extends Equatable {
  final int? id;
  final String? name;
  final String? type;
  final String? pageName;
  final bool showName;
  final TitleImageData? titleImage;
  final List<StoreTileDetail> tileDetails;

  const CustomTilesData({
    this.id,
    this.name,
    this.type,
    this.pageName,
    this.showName = false,
    this.titleImage,
    this.tileDetails = const [],
  });

  @override
  List<Object?> get props => [id, name, type, pageName, tileDetails];
}

class TitleImageData extends Equatable {
  final String? url;
  final int? width;
  final int? height;

  const TitleImageData({this.url, this.width, this.height});

  @override
  List<Object?> get props => [url, width, height];
}

class StoreTileDetail extends Equatable {
  final List<TileImage> tileGrid;

  const StoreTileDetail({this.tileGrid = const []});

  @override
  List<Object?> get props => [tileGrid];
}

class TileImage extends Equatable {
  final String? imageUrl;
  final String? actionUri;
  final String? mimeType;
  final int? width;
  final int? height;

  const TileImage({
    this.imageUrl,
    this.actionUri,
    this.mimeType,
    this.width,
    this.height,
  });

  @override
  List<Object?> get props => [imageUrl, actionUri, mimeType, width, height];
}

class ProductGridData extends Equatable {
  final String? id;
  final String? name;
  final String? pageName;
  final TitleImageData? title;
  final LayoutInfoData? layoutInfo;
  final List<ProductGridRowData> rows;
  final CtaData? cta;

  const ProductGridData({
    this.id,
    this.name,
    this.pageName,
    this.title,
    this.layoutInfo,
    this.rows = const [],
    this.cta,
  });

  @override
  List<Object?> get props => [id, name, pageName, title, layoutInfo, rows, cta];
}

class ProductGridRowData extends Equatable {
  final List<ProductGridItem> items;

  const ProductGridRowData({this.items = const []});

  @override
  List<Object?> get props => [items];
}

class ProductGridItem extends Equatable {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? actionUrl;
  final String? priceText;
  final String? originalPriceText;
  final String? discountText;

  const ProductGridItem({
    this.id,
    this.name,
    this.imageUrl,
    this.actionUrl,
    this.priceText,
    this.originalPriceText,
    this.discountText,
  });

  @override
  List<Object?> get props =>
      [id, name, imageUrl, actionUrl, priceText, originalPriceText, discountText];
}

class LayoutInfoData extends Equatable {
  final int? columns;
  final bool showProductInfo;

  const LayoutInfoData({this.columns, this.showProductInfo = true});

  @override
  List<Object?> get props => [columns, showProductInfo];
}

class PageCarouselData extends Equatable {
  final int? id;
  final String? type;
  final String? title;
  final String? sectionName;
  final int? tileWidth;
  final int? tileHeight;
  final String? itemAspectRatio;
  final int? minTilesToShow;
  final bool showPageIndicators;
  final bool snapBehaviour;
  final TitleImageData? titleImage;
  final String? tracking;
  final List<PageCarouselTile> tiles;
  final Map<String, dynamic>? queryParams;
  final String? useCase;
  final int? peepingFactor;

  const PageCarouselData({
    this.id,
    this.type,
    this.title,
    this.sectionName,
    this.tileWidth,
    this.tileHeight,
    this.itemAspectRatio,
    this.minTilesToShow,
    this.showPageIndicators = false,
    this.snapBehaviour = false,
    this.titleImage,
    this.tracking,
    this.tiles = const [],
    this.queryParams,
    this.useCase,
    this.peepingFactor,
  });

  double get parsedAspectRatio {
    if (itemAspectRatio != null && itemAspectRatio!.contains(':')) {
      final parts = itemAspectRatio!.split(':');
      final w = double.tryParse(parts[0]) ?? 1;
      final h = double.tryParse(parts[1]) ?? 1;
      if (h > 0) return w / h;
    }
    if (tileWidth != null && tileHeight != null && tileHeight! > 0) {
      return tileWidth! / tileHeight!;
    }
    return 1.0;
  }

  @override
  List<Object?> get props => [id, type, title, sectionName, tiles];
}

class PageCarouselTile extends Equatable {
  final int? id;
  final String? imageUrl;
  final String? actionUrl;
  final String? mimeType;
  final String? collectionName;
  final PageCarouselProduct? product;

  const PageCarouselTile({
    this.id,
    this.imageUrl,
    this.actionUrl,
    this.mimeType,
    this.collectionName,
    this.product,
  });

  @override
  List<Object?> get props => [id, imageUrl, actionUrl];
}

class PageCarouselProduct extends Equatable {
  final String? name;
  final int discount;
  final double regularPrice;
  final double retailPrice;

  const PageCarouselProduct({
    this.name,
    this.discount = 0,
    this.regularPrice = 0,
    this.retailPrice = 0,
  });

  @override
  List<Object?> get props => [name, discount, regularPrice, retailPrice];
}

class CtaData extends Equatable {
  final String? text;
  final String? actionUrl;
  final String? tracking;

  const CtaData({this.text, this.actionUrl, this.tracking});

  @override
  List<Object?> get props => [text, actionUrl, tracking];
}

/// Mirrors Android's Margins model.
/// Controls outer and inner spacing for each PageComponent.
class ComponentMargins extends Equatable {
  final double top;
  final double bottom;
  final double horizontal;
  final double innerHorizontalMargin;
  final double innerVerticalMargin;
  final double ctaTopMargin;
  final double ctaHorizontalMargin;
  final double titleBottomMargin;
  final double titleHorizontalMargin;

  const ComponentMargins({
    this.top = 0,
    this.bottom = 0,
    this.horizontal = 0,
    this.innerHorizontalMargin = 0,
    this.innerVerticalMargin = 0,
    this.ctaTopMargin = 0,
    this.ctaHorizontalMargin = 0,
    this.titleBottomMargin = 0,
    this.titleHorizontalMargin = 0,
  });

  @override
  List<Object?> get props => [
        top, bottom, horizontal,
        innerHorizontalMargin, innerVerticalMargin,
        ctaTopMargin, ctaHorizontalMargin,
        titleBottomMargin, titleHorizontalMargin,
      ];
}
