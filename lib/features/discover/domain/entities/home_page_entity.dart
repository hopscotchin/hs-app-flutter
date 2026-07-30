import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';
import '../../../plp/domain/entities/listing_product_entity.dart';

part 'home_page_entity.freezed.dart';

@freezed
abstract class HomePageEntity with _$HomePageEntity {
  const factory HomePageEntity({
    String? action,
    String? popUpMessage,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
    PageMeta? pageMeta,
    @Default(<SortingOption>[]) List<SortingOption> sortingOptions,
    @Default(<PageComponent>[]) List<PageComponent> pageComponents,
  }) = _HomePageEntity;
}

extension HomePageEntityX on HomePageEntity {
  // null action = no explicit failure signalled; treat as success
  bool get isSuccessful =>
      action == null || action!.toLowerCase() == 'success';

  String? get pageName => pageMeta?.pageName;
  String? get headerImageUrl => pageMeta?.headerImageUrl;
  bool get isDarkHeader => pageMeta?.isDarkHeader ?? false;
  int get totalCollections => pageMeta?.totalCollections ?? 0;
  bool get hasNextPage => pageMeta?.hasNextPage ?? false;
}

/// Top-level page metadata (v13 `pageMeta`).
class PageMeta extends Equatable {
  final String? pageName;
  final int? pageId;
  final int totalCollections;
  final bool hasNextPage;
  final String? headerImageUrl;
  final bool isDarkHeader;

  const PageMeta({
    this.pageName,
    this.pageId,
    this.totalCollections = 0,
    this.hasNextPage = false,
    this.headerImageUrl,
    this.isDarkHeader = false,
  });

  @override
  List<Object?> get props => [
    pageName,
    pageId,
    totalCollections,
    hasNextPage,
    headerImageUrl,
    isDarkHeader,
  ];
}

/// Top-level `sortingOptions` entries — drive the tab strip on Discover.
class SortingOption extends Equatable {
  final String label;
  final String id;

  const SortingOption({required this.label, required this.id});

  @override
  List<Object?> get props => [label, id];
}

/// Each `pageComponents[]` entry: a `type` + a `data` block plus shared
/// `margins` / `position` fields. The typed payload is pre-parsed into
/// [parsedData] so build-time has no JSON cost.
class PageComponent extends Equatable {
  final String type;
  final int position;
  final Map<String, dynamic>? data;
  final Object? parsedData;
  final ComponentMargins? margins;

  /// Component-level tracking overrides supplied by the backend. When
  /// present, every key/value in this map is merged verbatim into every
  /// impression / click payload produced for this component — the backend's
  /// contract for extensible analytics without client changes. Merged LAST
  /// so backend-supplied keys win over locally-assembled defaults.
  final Map<String, dynamic>? trackingMeta;

  const PageComponent({
    required this.type,
    this.position = 0,
    this.data,
    this.parsedData,
    this.margins,
    this.trackingMeta,
  });

  @override
  List<Object?> get props => [type, position, data, margins, trackingMeta];
}

/// `type` constants from the v13 API.
class PageComponentType {
  static const String hero = 'Hero';
  static const String customTiles = 'CustomTiles';
  static const String pageCarousel = 'PageCarousel';
  static const String productGrid = 'PRODUCT_GRID';
  static const String ctaButton = 'CTA_BUTTON';
}

// ─── Shared building blocks ───

/// `title` block — image-as-section-header used by most components.
class TitleImage extends Equatable {
  final String? url;
  final int? width;
  final int? height;

  const TitleImage({this.url, this.width, this.height});

  @override
  List<Object?> get props => [url, width, height];
}

/// `ctaButton` block — explore/view-all button on ProductGrid, CustomTiles, etc.
class CtaButton extends Equatable {
  final String? label;
  final String? actionType;
  final String? actionUri;
  final String? type;

  const CtaButton({this.label, this.actionType, this.actionUri, this.type});

  @override
  List<Object?> get props => [label, actionType, actionUri, type];
}

/// Single tile inside a `tileGrid` array (used by Hero and CustomTiles).
class TileGridItem extends Equatable {
  final String? imageUrl;
  final String? actionUri;
  final String? actionUriWeb;
  final String? mimeType;
  final int? width;
  final int? height;
  final String? actionType;
  final String? actionValue;
  final String? appImageUrl;
  final bool isTitleItem;

  /// Leaf-level tracking overrides. Merged onto click / impression payloads
  /// deepest-wins.
  final Map<String, dynamic>? trackingMeta;

  const TileGridItem({
    this.imageUrl,
    this.actionUri,
    this.actionUriWeb,
    this.mimeType,
    this.width,
    this.height,
    this.actionType,
    this.actionValue,
    this.appImageUrl,
    this.isTitleItem = false,
    this.trackingMeta,
  });

  double get aspectRatio =>
      (width != null && height != null && height! > 0)
      ? width! / height!
      : 1.0;

  @override
  List<Object?> get props => [
    imageUrl,
    actionUri,
    mimeType,
    width,
    height,
    actionType,
    isTitleItem,
  ];
}

// ─── PageCarousel ───

class PageCarouselData extends Equatable {
  final PageCarouselViewConfig? viewConfig;
  final TitleImage? title;
  final List<PageCarouselTile> tiles;

  /// Component-scoped tracking overrides from the backend. See
  /// [PageComponent.trackingMeta] for the merge contract.
  final Map<String, dynamic>? trackingMeta;

  const PageCarouselData({
    this.viewConfig,
    this.title,
    this.tiles = const [],
    this.trackingMeta,
  });

  double get parsedAspectRatio {
    final w = viewConfig?.tileWidth;
    final h = viewConfig?.tileHeight;
    if (w != null && h != null && h > 0) return w / h;
    return 1.0;
  }

  @override
  List<Object?> get props => [viewConfig, title, tiles, trackingMeta];
}

class PageCarouselViewConfig extends Equatable {
  final int? tileWidth;
  final int? tileHeight;
  final int? minTilesToShow;
  final bool navigation;
  final bool snapping;
  final bool showPageIndicators;
  final int peepingFactor;
  final double imageCornerRadius;

  const PageCarouselViewConfig({
    this.tileWidth,
    this.tileHeight,
    this.minTilesToShow,
    this.navigation = false,
    this.snapping = false,
    this.showPageIndicators = false,
    this.peepingFactor = 0,
    this.imageCornerRadius = 0,
  });

  @override
  List<Object?> get props => [
    tileWidth,
    tileHeight,
    minTilesToShow,
    navigation,
    snapping,
    showPageIndicators,
    peepingFactor,
    imageCornerRadius,
  ];
}

class PageCarouselTile extends Equatable {
  final int? id;
  final String? imageUrl;
  final String? actionUri;
  final String? mimeType;
  final String? sort;
  final ListingProductEntity? product;
  final Map<String, dynamic>? trackingMeta;

  const PageCarouselTile({
    this.id,
    this.imageUrl,
    this.actionUri,
    this.mimeType,
    this.sort,
    this.product,
    this.trackingMeta,
  });

  @override
  List<Object?> get props =>
      [id, imageUrl, actionUri, mimeType, sort, product, trackingMeta];
}

// ─── Hero ───

class HeroCarouselData extends Equatable {
  final HeroViewConfig? viewConfig;
  final List<HeroTile> tiles;

  /// Component-scoped tracking overrides from the backend. See
  /// [PageComponent.trackingMeta].
  final Map<String, dynamic>? trackingMeta;

  const HeroCarouselData({
    this.viewConfig,
    this.tiles = const [],
    this.trackingMeta,
  });

  @override
  List<Object?> get props => [viewConfig, tiles, trackingMeta];
}

class HeroViewConfig extends Equatable {
  final String? title;
  final int? position;
  final String? transitionType;
  final double imageCornerRadius;
  final int? scrollDuration;

  const HeroViewConfig({
    this.title,
    this.position,
    this.transitionType,
    this.imageCornerRadius = 0,
    this.scrollDuration,
  });

  @override
  List<Object?> get props => [
    title,
    position,
    transitionType,
    imageCornerRadius,
    scrollDuration,
  ];
}

/// v13 Hero tile: holds metadata + `tile_details[].tileGrid[]`.
/// Each tile renders as a single image (first non-empty grid entry).
class HeroTile extends Equatable {
  final int? id;
  final String? name;
  final String? type;
  final String? pageName;
  final int? position;
  final List<HeroTileDetail> tileDetails;
  final Map<String, dynamic>? trackingMeta;

  const HeroTile({
    this.id,
    this.name,
    this.type,
    this.pageName,
    this.position,
    this.tileDetails = const [],
    this.trackingMeta,
  });

  TileGridItem? get firstImage {
    for (final detail in tileDetails) {
      for (final item in detail.tileGrid) {
        if ((item.imageUrl ?? '').isNotEmpty) return item;
      }
    }
    return null;
  }

  String get imageUrl => firstImage?.imageUrl ?? '';
  String? get actionUri => firstImage?.actionUri;
  int get width => firstImage?.width ?? 960;
  int get height => firstImage?.height ?? 960;
  double get aspectRatio => height > 0 ? width / height : 1.0;

  @override
  List<Object?> get props =>
      [id, name, type, pageName, position, tileDetails, trackingMeta];
}

class HeroTileDetail extends Equatable {
  final int? tileDetailId;
  final List<TileGridItem> tileGrid;
  final Map<String, dynamic>? trackingMeta;

  const HeroTileDetail({
    this.tileDetailId,
    this.tileGrid = const [],
    this.trackingMeta,
  });

  @override
  List<Object?> get props => [tileDetailId, tileGrid, trackingMeta];
}

// ─── CustomTiles ───

class CustomTilesData extends Equatable {
  final CustomTilesViewConfig? viewConfig;
  final CtaButton? ctaButton;
  final TitleImage? title;
  final List<CustomTilesTile> tiles;

  /// Component-scoped tracking overrides from the backend. See
  /// [PageComponent.trackingMeta].
  final Map<String, dynamic>? trackingMeta;

  const CustomTilesData({
    this.viewConfig,
    this.ctaButton,
    this.title,
    this.tiles = const [],
    this.trackingMeta,
  });

  @override
  List<Object?> get props => [viewConfig, ctaButton, title, tiles, trackingMeta];
}

class CustomTilesViewConfig extends Equatable {
  final String? name;
  final String? type;
  final String? pageName;
  final double imageCornerRadius;

  const CustomTilesViewConfig({
    this.name,
    this.type,
    this.pageName,
    this.imageCornerRadius = 0,
  });

  @override
  List<Object?> get props => [name, type, pageName, imageCornerRadius];
}

/// CustomTiles entry — a tileGrid row plus the original tile_detail_id.
class CustomTilesTile extends Equatable {
  final int? tileDetailId;
  final List<TileGridItem> tileGrid;
  final Map<String, dynamic>? trackingMeta;

  const CustomTilesTile({
    this.tileDetailId,
    this.tileGrid = const [],
    this.trackingMeta,
  });

  bool get isTitleRow =>
      tileGrid.isNotEmpty && tileGrid.every((t) => t.isTitleItem);

  @override
  List<Object?> get props => [tileDetailId, tileGrid, trackingMeta];
}

// ─── ProductGrid ───

class ProductGridData extends Equatable {
  final ProductGridViewConfig? viewConfig;
  final CtaButton? ctaButton;
  final TitleImage? title;
  final LayoutInfoData? layoutInfo;
  final List<ListingProductEntity> tiles;

  /// Component-scoped tracking overrides from the backend. See
  /// [PageComponent.trackingMeta].
  final Map<String, dynamic>? trackingMeta;

  const ProductGridData({
    this.viewConfig,
    this.ctaButton,
    this.title,
    this.layoutInfo,
    this.tiles = const [],
    this.trackingMeta,
  });

  @override
  List<Object?> get props => [
    viewConfig,
    ctaButton,
    title,
    layoutInfo,
    tiles,
    trackingMeta,
  ];
}

class ProductGridViewConfig extends Equatable {
  final String? name;
  final String? useCase;

  const ProductGridViewConfig({this.name, this.useCase});

  @override
  List<Object?> get props => [name, useCase];
}

class LayoutInfoData extends Equatable {
  final int? columns;
  final bool showProductInfo;

  const LayoutInfoData({this.columns, this.showProductInfo = true});

  @override
  List<Object?> get props => [columns, showProductInfo];
}

/// Mirrors Android's Margins model. Controls outer/inner spacing per component.
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
