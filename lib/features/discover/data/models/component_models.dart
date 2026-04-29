import '../../domain/entities/home_page_entity.dart';

/// Parses the `data` field of a PageComponent based on its type.
class ComponentDataParser {
  static ComponentMargins? parseMargins(Map<String, dynamic>? json) {
    if (json == null) return null;
    return ComponentMargins(
      top: (json['top'] as num?)?.toDouble() ?? 0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 0,
      horizontal: (json['horizontal'] as num?)?.toDouble() ?? 0,
      innerHorizontalMargin:
          (json['innerHorizontalMargin'] as num?)?.toDouble() ?? 0,
      innerVerticalMargin:
          (json['innerVerticalMargin'] as num?)?.toDouble() ?? 0,
      ctaTopMargin: (json['ctaTopMargin'] as num?)?.toDouble() ?? 0,
      ctaHorizontalMargin:
          (json['ctaHorizontalMargin'] as num?)?.toDouble() ?? 0,
      titleBottomMargin:
          (json['titleBottomMargin'] as num?)?.toDouble() ?? 0,
      titleHorizontalMargin:
          (json['titleHorizontalMargin'] as num?)?.toDouble() ?? 0,
    );
  }

  static HeroCarouselData parseHero(Map<String, dynamic> json) {
    final rawTiles = json['tiles'] as List<dynamic>? ?? [];
    final tiles = <HeroTile>[];
    for (final tile in rawTiles) {
      if (tile is! Map<String, dynamic>) continue;
      final tileDetails = tile['tile_details'] as List<dynamic>? ?? [];
      if (tileDetails.isEmpty) continue;

      final firstDetail = tileDetails.first;
      if (firstDetail is! Map<String, dynamic>) continue;

      final tileGrid = firstDetail['tileGrid'] as List<dynamic>? ?? [];
      if (tileGrid.isEmpty) continue;

      final gridItem = tileGrid.first;
      if (gridItem is! Map<String, dynamic>) continue;

      final imageUrl = gridItem['imageUrl'] as String? ?? '';
      if (imageUrl.isEmpty) continue;

      tiles.add(HeroTile(
        imageUrl: imageUrl,
        actionUri: gridItem['actionUri'] as String?,
        width: gridItem['width'] as int? ?? 960,
        height: gridItem['height'] as int? ?? 960,
      ));
    }

    return HeroCarouselData(
      title: json['title'] as String?,
      sectionName: json['sectionName'] as String?,
      scrollDuration: json['scrollDuration'] as int?,
      transitionType: json['transitionType'] as String?,
      useCase: json['useCase'] as String?,
      tiles: tiles,
    );
  }

  static CollectionData parseCollection(Map<String, dynamic> json) {
    return CollectionData(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image'] as String?,
      actionUrl: json['actionUrl'] as String?,
      showInBoutiqueSetting: json['showInBoutiqueSetting'] as bool?,
      pageId: json['pageId']?.toString(),
    );
  }

  static CustomTilesData parseCustomTiles(Map<String, dynamic> json) {
    final rawDetails = json['tile_details'] as List<dynamic>? ??
        json['tileDetails'] as List<dynamic>? ??
        [];

    final tileDetails = rawDetails.map((e) {
      final detailJson = e as Map<String, dynamic>;
      final rawGrid = detailJson['tileGrid'] as List<dynamic>? ?? [];
      final tileGrid = rawGrid.map((t) {
        final tileJson = t as Map<String, dynamic>;
        return TileImage(
          imageUrl: tileJson['imageUrl'] as String?,
          actionUri: tileJson['actionUri'] as String? ??
              tileJson['action'] as String?,
          mimeType: tileJson['mimeType'] as String?,
          width: tileJson['width'] as int?,
          height: tileJson['height'] as int?,
        );
      }).toList();
      return StoreTileDetail(tileGrid: tileGrid);
    }).toList();

    TitleImageData? titleImage;
    if (json['titleImage'] is Map<String, dynamic>) {
      final ti = json['titleImage'] as Map<String, dynamic>;
      titleImage = TitleImageData(
        url: ti['url'] as String?,
        width: ti['width'] as int?,
        height: ti['height'] as int?,
      );
    }

    return CustomTilesData(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      pageName: json['page_name'] as String? ?? json['pageName'] as String?,
      showName: json['show_name'] as bool? ?? json['showName'] as bool? ?? false,
      titleImage: titleImage,
      tileDetails: tileDetails,
    );
  }

  static PageCarouselData parsePageCarousel(Map<String, dynamic> json) {
    TitleImageData? titleImage;
    if (json['titleImage'] is Map<String, dynamic>) {
      final ti = json['titleImage'] as Map<String, dynamic>;
      titleImage = TitleImageData(
        url: ti['url'] as String?,
        width: ti['width'] as int?,
        height: ti['height'] as int?,
      );
    }

    final rawTiles = json['tiles'] as List<dynamic>? ?? [];
    final tiles = rawTiles.map((t) {
      final tileJson = t as Map<String, dynamic>;
      PageCarouselProduct? product;
      if (tileJson['product'] is Map<String, dynamic>) {
        final p = tileJson['product'] as Map<String, dynamic>;
        product = PageCarouselProduct(
          name: p['name'] as String?,
          discount: p['discount'] as int? ?? 0,
          regularPrice: (p['regularPrice'] as num?)?.toDouble() ?? 0,
          retailPrice: (p['retailPrice'] as num?)?.toDouble() ?? 0,
        );
      }
      return PageCarouselTile(
        id: tileJson['id'] as int?,
        imageUrl: tileJson['imageUrl'] as String?,
        actionUrl: tileJson['actionUrl'] as String?,
        mimeType: tileJson['mimeType'] as String?,
        collectionName: tileJson['collectionName'] as String?,
        product: product,
      );
    }).toList();

    return PageCarouselData(
      id: json['carouselId'] as int? ?? json['id'] as int?,
      type: json['carouselType'] as String? ?? json['type'] as String?,
      title: json['title'] as String?,
      sectionName: json['sectionName'] as String?,
      tileWidth: json['tileWidth'] as int?,
      tileHeight: json['tileHeight'] as int?,
      itemAspectRatio: json['itemAspectRatio'] as String?,
      minTilesToShow: json['minTilesToShow'] as int?,
      showPageIndicators: json['showPageIndicators'] as bool? ?? false,
      snapBehaviour: json['snapping'] as bool? ?? false,
      titleImage: titleImage,
      tracking: json['tracking'] as String?,
      tiles: tiles,
      queryParams: json['queryParams'] as Map<String, dynamic>?,
      useCase: json['useCase'] as String?,
      peepingFactor: json['peepingFactor'] as int?,
    );
  }

  static CustomTilesData? parseTabbedCustomTiles(Map<String, dynamic> json) {
    final tabs = json['tabs'] as List<dynamic>? ?? [];
    if (tabs.isEmpty) return null;

    Map<String, dynamic>? selectedTab;
    for (final tab in tabs) {
      final tabMap = tab as Map<String, dynamic>;
      if (tabMap['isSelected'] == true) {
        selectedTab = tabMap;
        break;
      }
    }
    selectedTab ??= tabs.first as Map<String, dynamic>;

    final customTilesJson =
        selectedTab['customTiles'] as Map<String, dynamic>?;
    if (customTilesJson == null) return null;
    return parseCustomTiles(customTilesJson);
  }

  static Object? parseComponentData(String type, Map<String, dynamic>? data) {
    if (data == null) return null;
    return switch (type) {
      PageComponentType.hero => parseHero(data),
      PageComponentType.customTiles => parseCustomTiles(data),
      PageComponentType.collection => parseCollection(data),
      PageComponentType.productGrid => parseProductGrid(data),
      PageComponentType.pageCarousel => parsePageCarousel(data),
      PageComponentType.tabbedCustomTiles => parseTabbedCustomTiles(data),
      _ => null,
    };
  }

  static ProductGridData parseProductGrid(Map<String, dynamic> json) {
    TitleImageData? title;
    if (json['title'] is Map<String, dynamic>) {
      final ti = json['title'] as Map<String, dynamic>;
      title = TitleImageData(
        url: ti['url'] as String?,
        width: ti['width'] as int?,
        height: ti['height'] as int?,
      );
    }

    LayoutInfoData? layoutInfo;
    if (json['layoutInfo'] is Map<String, dynamic>) {
      final li = json['layoutInfo'] as Map<String, dynamic>;
      layoutInfo = LayoutInfoData(
        columns: li['columns'] as int?,
        showProductInfo: li['showProductInfo'] as bool? ?? true,
      );
    }

    final rawRows = json['rows'] as List<dynamic>? ?? [];
    final rows = rawRows.map((r) {
      final rowJson = r as Map<String, dynamic>;
      final rawItems = rowJson['items'] as List<dynamic>? ?? [];
      final items = rawItems.map((i) {
        final itemJson = i as Map<String, dynamic>;
        // Extract from label objects (label1=name, label2=price,
        // label3=originalPrice, label4=discount) or fallback to flat fields
        final label1 = itemJson['label1'] as Map<String, dynamic>?;
        final label2 = itemJson['label2'] as Map<String, dynamic>?;
        final label3 = itemJson['label3'] as Map<String, dynamic>?;
        final label4 = itemJson['label4'] as Map<String, dynamic>?;
        final action = itemJson['action'] as Map<String, dynamic>?;

        return ProductGridItem(
          id: itemJson['id']?.toString(),
          name: label1?['text'] as String? ?? itemJson['name'] as String?,
          imageUrl: itemJson['image'] as String? ??
              itemJson['imageUrl'] as String?,
          actionUrl: action?['uri'] as String? ??
              itemJson['actionUrl'] as String?,
          priceText: label2?['text'] as String?,
          originalPriceText: label3?['text'] as String?,
          discountText: label4?['text'] as String?,
        );
      }).toList();
      return ProductGridRowData(items: items);
    }).toList();

    CtaData? cta;
    if (json['cta'] is Map<String, dynamic>) {
      final c = json['cta'] as Map<String, dynamic>;
      final ctaAction = c['action'] as Map<String, dynamic>?;
      cta = CtaData(
        text: c['title'] as String? ?? c['text'] as String?,
        actionUrl: ctaAction?['uri'] as String? ??
            c['actionUrl'] as String?,
        tracking: c['tracking'] as String?,
      );
    }

    return ProductGridData(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      pageName: json['pageName'] as String?,
      title: title,
      layoutInfo: layoutInfo,
      rows: rows,
      cta: cta,
    );
  }
}
