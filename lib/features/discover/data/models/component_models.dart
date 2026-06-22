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
          );
        })
        .where((tile) => tile.firstImage != null)
        .toList();

    return HeroCarouselData(viewConfig: viewConfig, tiles: tiles);
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
                (viewConfigJson['imageCornerRadius'] as num?)?.toDouble() ?? 4,
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
          ),
        )
        .toList();

    return CustomTilesData(
      viewConfig: viewConfig,
      ctaButton: _parseCtaButton(json['ctaButton']),
      title: _parseTitle(json['title'] ?? json['titleImage']),
      tiles: tiles,
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
          ),
        )
        .toList();

    return PageCarouselData(
      viewConfig: viewConfig,
      title: _parseTitle(json['title'] ?? json['titleImage']),
      tiles: tiles,
    );
  }

  // ─── TabbedCustomTiles ───

  static CustomTilesData? parseTabbedCustomTiles(Map<String, dynamic> json) {
    final tabs = json['tabs'] as List<dynamic>? ?? const [];
    if (tabs.isEmpty) return null;

    Map<String, dynamic>? selectedTab;
    for (final tab in tabs) {
      if (tab is! Map<String, dynamic>) continue;
      if (tab['isSelected'] == true) {
        selectedTab = tab;
        break;
      }
    }
    selectedTab ??= tabs.first as Map<String, dynamic>;

    final customTilesJson = selectedTab['customTiles'] as Map<String, dynamic>?;
    if (customTilesJson == null) return null;
    return parseCustomTiles(customTilesJson);
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
    );
  }

  // ─── ShopTheLook ───

  static ShopTheLookData parseShopTheLook(Map<String, dynamic> json) {
    ShopTheLookViewConfig? viewConfig;
    if (json['viewConfig'] is Map<String, dynamic>) {
      final vc = json['viewConfig'] as Map<String, dynamic>;
      viewConfig = ShopTheLookViewConfig(
        itemWidth: (vc['itemWidth'] as num?)?.toInt(),
        itemHeight: (vc['itemHeight'] as num?)?.toInt(),
        minTilesToShow: (vc['minTilesToShow'] as num?)?.toInt(),
        peepingFactor: (vc['peepingFactor'] as num?)?.toInt(),
      );
    }

    final rawTiles = json['tiles'] as List<dynamic>? ??
        json['items'] as List<dynamic>? ??
        const [];

    final tiles = rawTiles.whereType<Map<String, dynamic>>().map((itemJson) {
      final itemPrice = _parseShopTheLookPrice(itemJson['price']);

      final rawProducts = itemJson['productTiles'] as List<dynamic>? ?? const [];
      final productTiles = rawProducts.whereType<Map<String, dynamic>>().map((
        tileJson,
      ) {
        final rawSkus = tileJson['skus'] as List<dynamic>? ?? const [];
        final skus = rawSkus.whereType<Map<String, dynamic>>().map((skuJson) {
          return ShopTheLookSku(
            skuId: skuJson['skuId'] as String?,
            size: skuJson['size'] as String?,
            availableQuantity: (skuJson['availableQuantity'] as num?)?.toInt(),
            price: _parseShopTheLookPrice(skuJson['price']),
          );
        }).toList();

        final media = tileJson['media'];
        final imageUrl = media is Map<String, dynamic>
            ? media['url'] as String?
            : media is String
                ? media
                : null;

        return ShopTheLookProduct(
          id: (tileJson['id'] as num?)?.toInt(),
          actionUri: tileJson['actionUri'] as String?,
          actionUriWeb: tileJson['actionUriWeb'] as String?,
          hasInv: tileJson['hasInv'] as bool?,
          hasSizeChart: tileJson['hasSizeChart'] as bool?,
          imageUrl: imageUrl,
          productName: tileJson['productName'] as String?,
          skus: skus,
        );
      }).toList();

      return ShopTheLookTile(
        id: (itemJson['id'] as num?)?.toInt(),
        productTiles: productTiles,
        price: itemPrice,
      );
    }).toList();

    return ShopTheLookData(
      id: (json['id'] as num?)?.toInt(),
      title: _parseTitle(json['title'] ?? json['titleImage']),
      viewConfig: viewConfig,
      tiles: tiles,
    );
  }

  static ShopTheLookPrice? _parseShopTheLookPrice(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    return ShopTheLookPrice(
      displayValue: json['displayValue'] as String?,
      mrp: json['mrp'] as String?,
      absoluteValue: (json['absoluteValue'] as num?)?.toInt(),
      absoluteMrp: (json['absoluteMrp'] as num?)?.toInt(),
      discount: json['discount'] as String?,
    );
  }

  // ─── Dispatcher ───

  static Object? parseComponentData(String type, Map<String, dynamic>? data) {
    if (data == null) return null;
    return switch (type) {
      PageComponentType.hero => parseHero(data),
      PageComponentType.customTiles => parseCustomTiles(data),
      PageComponentType.productGrid => parseProductGrid(data),
      PageComponentType.pageCarousel => parsePageCarousel(data),
      PageComponentType.tabbedCustomTiles => parseTabbedCustomTiles(data),
      PageComponentType.shopTheLook => parseShopTheLook(data),
      _ => null,
    };
  }
}
