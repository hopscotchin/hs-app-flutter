import '../../../plp/data/models/listing_product_model.dart';
import '../../../plp/domain/entities/listing_product_entity.dart';
import '../../domain/entities/home_page_entity.dart';

/// Parses the `data` field of a PageComponent based on its `type`.
/// Mirrors the v13 JSON contract (pageMeta/sortingOptions/viewConfig/ctaButton/tiles).
class ComponentDataParser {
  static ComponentMargins? parseMargins(Map<String, dynamic>? json) {
    if (json == null) return null;
    return ComponentMargins(
      top: (json['top'] as num?)?.toDouble() ?? 0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 0,
      horizontal: (json['horizontal'] as num?)?.toDouble() ?? 16,
      innerHorizontalMargin:
          (json['innerHorizontalMargin'] as num?)?.toDouble() ?? 8,
      innerVerticalMargin:
          (json['innerVerticalMargin'] as num?)?.toDouble() ?? 0,
      ctaTopMargin: (json['ctaTopMargin'] as num?)?.toDouble() ?? 0,
      ctaHorizontalMargin:
          (json['ctaHorizontalMargin'] as num?)?.toDouble() ?? 0,
      titleBottomMargin: (json['titleBottomMargin'] as num?)?.toDouble() ?? 16,
      titleHorizontalMargin:
          (json['titleHorizontalMargin'] as num?)?.toDouble() ?? 16,
    );
  }

  // ─── Shared helpers ───

  static TitleImage? _parseTitle(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    return TitleImage(
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );
  }

  static CtaButton? _parseCtaButton(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    return CtaButton(
      label: json['label'] as String? ?? json['text'] as String?,
      actionType: json['actionType'] as String?,
      actionUri: json['actionUri'] as String? ?? json['actionUrl'] as String?,
      type: json['type'] as String?,
    );
  }

  static TileGridItem _parseTileGridItem(Map<String, dynamic> json) {
    return TileGridItem(
      imageUrl: json['imageUrl'] as String?,
      actionUri: json['actionUri'] as String? ?? json['action'] as String?,
      actionUriWeb: json['actionUriWeb'] as String?,
      mimeType: json['mimeType'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      actionType: json['action_type'] as String? ?? json['actionType'] as String?,
      actionValue:
          json['action_value'] as String? ?? json['actionValue'] as String?,
      appImageUrl: json['appImageUrl'] as String?,
      isTitleItem: json['isTitleItem'] as bool? ?? false,
      trackingMeta: _readTrackingMeta(json),
    );
  }

  static List<TileGridItem> _parseTileGrid(Object? json) {
    if (json is! List) return const [];
    return json
        .whereType<Map<String, dynamic>>()
        .map(_parseTileGridItem)
        .toList();
  }

  /// Parses the unified product shape (id/name/brandName/priceInfo/wishlistInfo/
  /// media/trackingMeta/visualCues) used by PageCarousel tiles and PRODUCT_GRID
  /// tiles. Delegates to [ListingProductModel] so PLP and Discover stay aligned.
  static ListingProductEntity? _parseHomepageProduct(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    if (json['id'] == null || json['name'] == null) return null;
    return ListingProductModel.fromJson(json).toEntity();
  }

  // ─── Hero ───

  static HeroCarouselData parseHero(Map<String, dynamic> json) {
    final viewConfigJson = json['viewConfig'] as Map<String, dynamic>?;
    final viewConfig = viewConfigJson == null
        ? null
        : HeroViewConfig(
            title: viewConfigJson['title'] as String?,
            position: (viewConfigJson['position'] as num?)?.toInt(),
            transitionType: viewConfigJson['transitionType'] as String?,
            imageCornerRadius:
                (viewConfigJson['imageCornerRadius'] as num?)?.toDouble() ?? 0,
            scrollDuration: (viewConfigJson['scrollDuration'] as num?)?.toInt(),
          );

    final rawTiles = json['tiles'] as List<dynamic>? ?? const [];
    final tiles = rawTiles
        .whereType<Map<String, dynamic>>()
        .map((tileJson) {
          final rawDetails = tileJson['tile_details'] as List<dynamic>? ??
              tileJson['tileDetails'] as List<dynamic>? ??
              const [];
          final tileDetails = rawDetails
              .whereType<Map<String, dynamic>>()
              .map(
                (d) => HeroTileDetail(
                  tileDetailId: (d['tile_detail_id'] as num?)?.toInt() ??
                      (d['tileDetailId'] as num?)?.toInt(),
                  tileGrid: _parseTileGrid(d['tileGrid']),
                  trackingMeta: _readTrackingMeta(d),
                ),
              )
              .toList();

          return HeroTile(
            id: (tileJson['id'] as num?)?.toInt(),
            name: tileJson['name'] as String?,
            type: tileJson['type'] as String?,
            pageName: tileJson['page_name'] as String? ??
                tileJson['pageName'] as String?,
            position: (tileJson['position'] as num?)?.toInt(),
            tileDetails: tileDetails,
            trackingMeta: _readTrackingMeta(tileJson),
          );
        })
        .where((tile) => tile.firstImage != null)
        .toList();

    return HeroCarouselData(
      viewConfig: viewConfig,
      tiles: tiles,
      trackingMeta: _readTrackingMeta(json),
    );
  }

  // ─── CustomTiles ───

  static CustomTilesData parseCustomTiles(Map<String, dynamic> json) {
    final viewConfigJson = json['viewConfig'] as Map<String, dynamic>?;
    final viewConfig = viewConfigJson == null
        ? null
        : CustomTilesViewConfig(
            name: viewConfigJson['name'] as String?,
            type: viewConfigJson['type'] as String?,
            pageName: viewConfigJson['pageName'] as String? ??
                viewConfigJson['page_name'] as String?,
            imageCornerRadius:
                (viewConfigJson['imageCornerRadius'] as num?)?.toDouble() ?? 0,
          );

    final rawTiles = json['tiles'] as List<dynamic>? ??
        json['tile_details'] as List<dynamic>? ??
        json['tileDetails'] as List<dynamic>? ??
        const [];

    final tiles = rawTiles
        .whereType<Map<String, dynamic>>()
        .map(
          (t) => CustomTilesTile(
            tileDetailId: (t['tile_detail_id'] as num?)?.toInt() ??
                (t['tileDetailId'] as num?)?.toInt(),
            tileGrid: _parseTileGrid(t['tileGrid']),
            trackingMeta: _readTrackingMeta(t),
          ),
        )
        .toList();

    return CustomTilesData(
      viewConfig: viewConfig,
      ctaButton: _parseCtaButton(json['ctaButton']),
      title: _parseTitle(json['title'] ?? json['titleImage']),
      tiles: tiles,
      trackingMeta: _readTrackingMeta(json),
    );
  }

  // ─── PageCarousel ───

  static PageCarouselData parsePageCarousel(Map<String, dynamic> json) {
    final viewConfigJson = json['viewConfig'] as Map<String, dynamic>?;
    final viewConfig = viewConfigJson == null
        ? null
        : PageCarouselViewConfig(
            tileWidth: (viewConfigJson['tileWidth'] as num?)?.toInt(),
            tileHeight: (viewConfigJson['tileHeight'] as num?)?.toInt(),
            minTilesToShow:
                (viewConfigJson['minTilesToShow'] as num?)?.toInt(),
            navigation: viewConfigJson['navigation'] as bool? ?? false,
            snapping: viewConfigJson['snapping'] as bool? ?? false,
            showPageIndicators:
                viewConfigJson['showPageIndicators'] as bool? ?? false,
            peepingFactor:
                (viewConfigJson['peepingFactor'] as num?)?.toInt() ?? 0,
            imageCornerRadius:
                (viewConfigJson['imageCornerRadius'] as num?)?.toDouble() ?? 0,
          );

    final rawTiles = json['tiles'] as List<dynamic>? ?? const [];
    final tiles = rawTiles
        .whereType<Map<String, dynamic>>()
        .map(
          (t) => PageCarouselTile(
            id: (t['id'] as num?)?.toInt(),
            imageUrl: t['imageUrl'] as String?,
            actionUri: t['actionUri'] as String? ?? t['actionUrl'] as String?,
            mimeType: t['mimeType'] as String?,
            sort: t['sort'] as String?,
            product: _parseHomepageProduct(t['product']),
            trackingMeta: _readTrackingMeta(t),
          ),
        )
        .toList();

    return PageCarouselData(
      viewConfig: viewConfig,
      title: _parseTitle(json['title'] ?? json['titleImage']),
      tiles: tiles,
      trackingMeta: _readTrackingMeta(json),
    );
  }

  // ─── ProductGrid ───

  static ProductGridData parseProductGrid(Map<String, dynamic> json) {
    final viewConfigJson = json['viewConfig'] as Map<String, dynamic>?;
    final viewConfig = viewConfigJson == null
        ? null
        : ProductGridViewConfig(
            name: viewConfigJson['name'] as String?,
            useCase: viewConfigJson['useCase'] as String?,
          );

    LayoutInfoData? layoutInfo;
    if (json['layoutInfo'] is Map<String, dynamic>) {
      final li = json['layoutInfo'] as Map<String, dynamic>;
      layoutInfo = LayoutInfoData(
        columns: (li['columns'] as num?)?.toInt(),
        showProductInfo: li['showProductInfo'] as bool? ?? true,
      );
    }

    final rawTiles = json['tiles'] as List<dynamic>? ?? const [];
    final tiles = rawTiles
        .whereType<Map<String, dynamic>>()
        .map(_parseHomepageProduct)
        .whereType<ListingProductEntity>()
        .toList();

    return ProductGridData(
      viewConfig: viewConfig,
      ctaButton: _parseCtaButton(json['ctaButton']),
      title: _parseTitle(json['title'] ?? json['titleImage']),
      layoutInfo: layoutInfo,
      tiles: tiles,
      trackingMeta: _readTrackingMeta(json),
    );
  }

  /// Extracts the raw `trackingMeta` map from a component's JSON payload
  /// verbatim. Every key/value goes straight through to impression / click
  /// analytics payloads — the backend owns the analytics contract, the
  /// client just passes what it's told.
  static Map<String, dynamic>? _readTrackingMeta(Map<String, dynamic> json) {
    final raw = json['trackingMeta'];
    return raw is Map<String, dynamic> ? Map<String, dynamic>.of(raw) : null;
  }

  // ─── Dispatcher ───

  static Object? parseComponentData(String type, Map<String, dynamic>? data) {
    if (data == null) return null;
    return switch (type) {
      PageComponentType.hero => parseHero(data),
      PageComponentType.customTiles => parseCustomTiles(data),
      PageComponentType.productGrid => parseProductGrid(data),
      PageComponentType.pageCarousel => parsePageCarousel(data),
      _ => null,
    };
  }
}
