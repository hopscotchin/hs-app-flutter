import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';

part 'home_page_entity.freezed.dart';

@freezed
abstract class HomePageEntity with _$HomePageEntity {
  const factory HomePageEntity({
    String? action,
    String? popUpMessage,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
    String? pageName,
    String? pageBackgroundColor,
    String? headerBgImageUrl,
    @Default(0) int totalCollections,
    @Default(0) int totalSections,
    @Default(<PageComponent>[]) List<PageComponent> pageComponents,
  }) = _HomePageEntity;
}

extension HomePageEntityX on HomePageEntity {
  // null action = no explicit failure signalled; treat as success
  bool get isSuccessful =>
      action == null || action!.toLowerCase() == 'success';
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
  List<Object?> get props => [
    title,
    sectionName,
    scrollDuration,
    transitionType,
    useCase,
    tiles,
  ];
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
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    actionUrl,
    priceText,
    originalPriceText,
    discountText,
  ];
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

// ─── ShopTheLook (StyleCarousel) entities ───

class ShopTheLookData extends Equatable {
  final int? id;
  final TitleImageData? titleImage;
  final ShopTheLookViewConfig? viewConfig;
  final List<ShopTheLookItem> items;

  const ShopTheLookData({
    this.id,
    this.titleImage,
    this.viewConfig,
    this.items = const [],
  });

  @override
  List<Object?> get props => [id, titleImage, viewConfig, items];
}

class ShopTheLookViewConfig extends Equatable {
  final int? itemWidth;
  final int? itemHeight;
  final int? minTilesToShow;
  final int? peepingFactor;

  const ShopTheLookViewConfig({
    this.itemWidth,
    this.itemHeight,
    this.minTilesToShow,
    this.peepingFactor,
  });

  @override
  List<Object?> get props => [
    itemWidth,
    itemHeight,
    minTilesToShow,
    peepingFactor,
  ];
}

class ShopTheLookItem extends Equatable {
  final int? id;
  final List<ShopTheLookProduct> productTiles;
  final ShopTheLookPrice? price;

  const ShopTheLookItem({this.id, this.productTiles = const [], this.price});

  @override
  List<Object?> get props => [id, productTiles, price];
}

class ShopTheLookProduct extends Equatable {
  final int? id;
  final String? actionUri;
  final bool? hasInv;
  final bool? hasSizeChart;
  final String? imageUrl;
  final String? productName;
  final List<ShopTheLookSku> skus;

  const ShopTheLookProduct({
    this.id,
    this.actionUri,
    this.hasInv,
    this.hasSizeChart,
    this.imageUrl,
    this.productName,
    this.skus = const [],
  });

  @override
  List<Object?> get props => [
    id,
    actionUri,
    hasInv,
    hasSizeChart,
    imageUrl,
    productName,
    skus,
  ];
}

class ShopTheLookSku extends Equatable {
  final String? skuId;
  final String? size;
  final int? availableQuantity;
  final ShopTheLookPrice? price;

  const ShopTheLookSku({
    this.skuId,
    this.size,
    this.availableQuantity,
    this.price,
  });

  bool get isAvailable => (availableQuantity ?? 0) > 0;

  @override
  List<Object?> get props => [skuId, size, availableQuantity, price];
}

class ShopTheLookPrice extends Equatable {
  final String? displayValue;
  final String? mrp;
  final int? absoluteValue;
  final int? absoluteMrp;
  final String? discount;

  const ShopTheLookPrice({
    this.displayValue,
    this.mrp,
    this.absoluteValue,
    this.absoluteMrp,
    this.discount,
  });

  @override
  List<Object?> get props => [
    displayValue,
    mrp,
    absoluteValue,
    absoluteMrp,
    discount,
  ];
}

class ShopTheLookSelection {
  final int productId;
  final String? skuId;

  const ShopTheLookSelection({required this.productId, this.skuId});
}

// ─── ContinueBrowsing entities ───

class ContinueBrowsingData extends Equatable {
  final int? id;
  final TitleImageData? heading;
  final ContinueBrowsingViewConfig? viewConfig;
  final List<ContinueBrowsingItem> items;

  const ContinueBrowsingData({
    this.id,
    this.heading,
    this.viewConfig,
    this.items = const [],
  });

  @override
  List<Object?> get props => [id, heading, viewConfig, items];
}

class ContinueBrowsingViewConfig extends Equatable {
  final int? viewWidth;
  final int? viewHeight;

  const ContinueBrowsingViewConfig({this.viewWidth, this.viewHeight});

  double get imageAspectRatio =>
      (viewWidth != null && viewHeight != null && viewHeight! > 0)
      ? viewWidth! / viewHeight!
      : 3 / 4;

  @override
  List<Object?> get props => [viewWidth, viewHeight];
}

class ContinueBrowsingItem extends Equatable {
  final String? heading;
  final String? actionUri;
  final List<String> media;

  const ContinueBrowsingItem({
    this.heading,
    this.actionUri,
    this.media = const [],
  });

  @override
  List<Object?> get props => [heading, actionUri, media];
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
    top,
    bottom,
    horizontal,
    innerHorizontalMargin,
    innerVerticalMargin,
    ctaTopMargin,
    ctaHorizontalMargin,
    titleBottomMargin,
    titleHorizontalMargin,
  ];
}
