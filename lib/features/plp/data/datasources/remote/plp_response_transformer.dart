/// Pure transformation: old PLP server JSON → new normalized JSON.
///
/// The server still ships the legacy shape. This function rewrites every section
/// so the output matches the new API contract exactly, which is what models parse.
///
/// Old → New highlights:
///   pageNo / pageSize / totalRecords / screenName / action
///     → pageMeta.{page, pageSize, totalCount, hasNextPage, pageTitle, pageSubtitle, plpId}
///
///   clusteringExistsForListingPage / hasXLTiles
///     → trackingMeta
///
///   sortingOptions[] at root
///     → filters.sortingOptions.{label, options[]}
///
///   plpFilter.filterSection[].filterList[].filter[]
///     → filters.filterSections[].filterList[].filters[]   (key: filter→filters)
///       filter item renames: name→label, param→filterValue, add filterKey
///
///   plpFilter.selectedFilters[].{key, param}
///     → filters.selectedFilters[].{filterKey, filterValue}
///
///   floatingFilter.data[].tiles[]
///     → floatingFilter.sections[].chips[]
///       tile renames: name→label, param→filterValue, id→filterValue (see below),
///                     color→textColor, bgColor→backgroundColor, isSelected string→bool
///
///   records[]: imageUrls, price obj, canWishlist bool, colorVariants string
///
///   messageBars / notificationNudge / banners / trackingMeta injected.
Map<String, dynamic> transformPlpResponse(Map<String, dynamic> old) {
  final pageNo = (old['pageNo'] as num?)?.toInt() ?? 1;
  final pageSize = (old['pageSize'] as num?)?.toInt() ?? 20;
  final totalCount = (old['totalRecords'] as num?)?.toInt() ?? 0;
  final hasNextPage = totalCount > (pageNo * pageSize);

  return {
    'pageMeta': {
      'page': pageNo,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'hasNextPage': hasNextPage,
      'pageTitle': old['screenName'] as String? ?? '',
      'pageSubtitle': '$totalCount products',
      'plpId': (old['plpSeoData']['plpId'] as num?)?.toInt() ?? 0,
      'orderRule': (old['orderRule'] as num?)?.toInt() ?? -1,
    },
    'trackingMeta': {
      'clusteringExistsForListingPage': old['clusteringExistsForListingPage'] as bool? ?? false,
      'excludePreorderFilterApplied': false,
      'hasXLTiles': old['hasXLTiles'] as bool? ?? false,
      'plpId': (old['plpSeoData']['plpId'] as num?)?.toInt() ?? 0,
    },
    'messageBars': _transformMessageBars(old['messageBars']),
    'notificationNudge': _transformNotificationNudge(old['notificationNudge']),
    'banners': _transformBanners(old['banners'], old['salePlanDetail']),
    'floatingFilter': _transformFloatingFilter(old['floatingFilter']),
    'filters': _transformFilters(old),
    'records': _transformRecords(old['records']),
  };
}

// ── messageBars ──────────────────────────────────────────────────────────────

List<Map<String, dynamic>> _transformMessageBars(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().toList();
}

// ── notificationNudge ────────────────────────────────────────────────────────

Map<String, dynamic>? _transformNotificationNudge(dynamic raw) {
  if (raw is! Map) return null;
  return Map<String, dynamic>.from(raw);
}

// ── banners ──────────────────────────────────────────────────────────────────

/// Builds the final banners list.
///
/// If [salePlanDetail] has a `bannerImageUrl` it is prepended as the first
/// banner. Aspect ratio is derived from `bannerImageWidth / bannerImageHeight`
/// when available; falls back to 4/3 (≈ 1.33) which matches the 600×450 px
/// dimensions in the current API response.
List<Map<String, dynamic>> _transformBanners(dynamic raw, [dynamic salePlanDetail]) {
  final banners = <Map<String, dynamic>>[];

  if (salePlanDetail is Map) {
    final url = salePlanDetail['flexiImageUrl'] ?? salePlanDetail['bannerImageUrl'];
    if (url != null && url.isNotEmpty) {
      final w = (salePlanDetail['bannerImageWidth'] as num?)?.toDouble();
      final h = (salePlanDetail['bannerImageHeight'] as num?)?.toDouble();
      final ratio = (w != null && h != null && h > 0) ? w / h : 4 / 3;
      banners.add({
        'imageUrl': url,
        'aspectRatio': ratio,
        'altText': salePlanDetail['name'] as String? ?? '',
        'actionUri': null,
      });
    }
  }

  if (raw is List) {
    banners.addAll(
      raw.whereType<Map<String, dynamic>>().map(
        (b) => {
          'imageUrl': b['imageUrl'] as String? ?? '',
          'aspectRatio': (b['aspectRatio'] as num?)?.toDouble() ?? 1.0,
          'altText': b['altText'] as String? ?? '',
          'actionUri': b['actionUri'] as String?,
        },
      ),
    );
  }

  return banners;
}

// ── floatingFilter ───────────────────────────────────────────────────────────

Map<String, dynamic> _transformFloatingFilter(dynamic raw) {
  if (raw == null) return {'type': null, 'sections': []};
  final ff = raw as Map;
  return {'type': ff['type'] as String?, 'sections': _transformFloatingSections(ff['data'])};
}

List<Map<String, dynamic>> _transformFloatingSections(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().map((s) {
    final chipType = s['name'] == 'Colour' ? 'COLOUR' : s['type'] as String?;
    return {
      'title': s['title'] as String?,
      'chipType': chipType,
      'tileWidth': (s['tileWidth'] as num?)?.toInt(),
      'tileHeight': (s['tileHeight'] as num?)?.toInt(),
      'position': (s['position'] as num?)?.toInt(),
      'chips': _transformChips(s['tiles'], chipType),
    };
  }).toList();
}

List<Map<String, dynamic>> _transformChips(dynamic raw, String? chipType) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().map((t) {
    // Accept new format (filterKey/filterValue/label) with old format fallback (param/id/name).
    // COLOUR chips carry bgColor; TEXT and IMAGE chips have no colour fields.
    return {
      'filterKey': t['filterKey'] as String? ?? t['param'] as String? ?? '',
      'filterValue': t['filterValue'] as String? ?? t['id']?.toString() ?? '',
      'label': t['label'] as String? ?? t['name'] as String?,
      'chipType': chipType,
      'imageUrl': t['imageUrl'] as String?,
      'bgColor': t['bgColor'] as String?,
      'textColor': null,
      'isSelected': _parseBool(t['isSelected']),
    };
  }).toList();
}

// ── filters ──────────────────────────────────────────────────────────────────

Map<String, dynamic> _transformFilters(Map<String, dynamic> old) {
  final plpFilter = old['plpFilter'] as Map? ?? {};
  return {
    'quickFilters': _buildQuickFilters(plpFilter['filterSection']),
    'sortingOptions': _transformSortingOptions(old['sortingOptions']),
    'filterSections': _transformFilterSections(plpFilter['filterSection']),
    'selectedFilters': _transformSelectedFilters(plpFilter['selectedFilters']),
  };
}

/// Converts the old `/api/filter` response format to the normalized format
/// that [PlpFilterModel.fromJson] expects.
Map<String, dynamic> transformFilterApiResponse(Map<String, dynamic> old) {
  return {
    'quickFilters': _buildQuickFilters(old['filterSection']),
    'sortingOptions': null,
    'filterSections': _transformFilterSections(old['filterSection']),
    'selectedFilters': _transformSelectedFilters(old['selectedFilters']),
  };
}

Map<String, dynamic> _transformSortingOptions(dynamic raw) {
  if (raw is! List) return {'label': 'Sort By', 'options': []};
  final options = raw.whereType<Map<String, dynamic>>().map((s) {
    return {
      'orderRule': (s['orderRule'] as num?)?.toInt() ?? 0,
      'label': s['sortName'] as String? ?? '',
      'isSelected': s['isSelected'] as bool? ?? false,
      'trackingMeta': {'eventSortName': s['eventSortName'] as String? ?? ''},
    };
  }).toList();
  return {'label': 'Sort By', 'options': options};
}

List<Map<String, dynamic>> _transformFilterSections(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().map((s) {
    return {
      'filterKey': _extractFilterKey(s['filterList']),
      'label': s['name'] as String?,
      'isMultiSelect': s['isMultiSelect'] as bool? ?? false,
      'showSearch': s['showSearch'] as bool? ?? false,
      'uiType': s['uiType'] as String?,
      'hasSelected': s['hasSelected'] as bool? ?? false,
      'filterList': _transformFilterList(s['filterList']),
    };
  }).toList();
}

List<Map<String, dynamic>> _transformFilterList(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().map((group) {
    return {'label': group['label'] as String?, 'filters': _transformFilterItems(group['filter'])};
  }).toList();
}

List<Map<String, dynamic>> _transformFilterItems(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().map((f) {
    return {
      'filterKey': f['param'] as String? ?? '',
      'filterValue': f['id']?.toString() ?? f['param'] as String? ?? '',
      'label': f['name'] as String?,
      'isSelected': f['isSelected'] as bool? ?? false,
      'productCount': (f['count'] as num?)?.toInt(),
      'colorHex': f['value'] as String?,
      'filters': _transformFilterItems(f['filter']),
    };
  }).toList();
}

// ── quickFilters ─────────────────────────────────────────────────────────────

const _eligibleQuickFilterNames = {'gender', 'age', 'price', 'colour'};

List<Map<String, dynamic>> _buildQuickFilters(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .where((s) => _eligibleQuickFilterNames.contains((s['name'] as String? ?? '').toLowerCase()))
      .map((s) {
        final filterKey = _extractFilterKey(s['filterList']);
        return {
          'filterKey': filterKey,
          'label': s['name'] as String?,
          'isApplied': s['hasSelected'] as bool? ?? false,
          'trackingMeta': {'sectionTracking': filterKey},
        };
      })
      .toList();
}

String? _extractFilterKey(dynamic filterList) {
  if (filterList is! List || filterList.isEmpty) return null;
  final group = filterList.first as Map<String, dynamic>?;
  if (group == null) return null;
  final filters = group['filter'] as List?;
  if (filters == null || filters.isEmpty) return null;
  return (filters.first as Map<String, dynamic>?)?['param'] as String?;
}

/// Mirrors Android's `GetAppliedFiltersUseCase` (hsplp).
///
/// The server returns one entry per filter key with comma-joined values:
///   `{ key: "price", param: "100,200", selectedFilterName: "Below ₹100,Below ₹200" }`
///
/// Each chip on the applied-filters strip represents a single (key, value)
/// pair, so we split here on commas — index-aligning `selectedFilterName`
/// with `param` — and emit one entry per value. Single-value entries pass
/// through unchanged.
///
/// Without this split:
/// 1. The strip shows one chip with text "Below ₹100,Below ₹200" — looks
///    like garbage to the user.
/// 2. Tapping ✕ on that chip removes the entire price filter rather than
///    just one of the two selected values — see `_onRemoveFilter` in
///    `PlpBloc` which relies on the per-value contract.
List<Map<String, dynamic>> _transformSelectedFilters(dynamic raw) {
  if (raw is! List) return const [];
  final out = <Map<String, dynamic>>[];
  for (final sf in raw.whereType<Map<String, dynamic>>()) {
    final filterKey = (sf['filterKey'] ?? sf['key']) as String?;
    final filterValue = (sf['filterValue'] ?? sf['param']) as String?;
    final filterName = sf['selectedFilterName'] as String?;
    final showOnUi = sf['showOnUi'] as bool? ?? true;

    final values = filterValue?.split(',') ?? const <String>[];
    final names = filterName?.split(',') ?? const <String>[];

    if (values.length <= 1) {
      out.add({
        'filterKey': filterKey,
        'filterValue': filterValue,
        'selectedFilterName': filterName,
        'showOnUi': showOnUi,
      });
      continue;
    }

    // Multi-value: emit one entry per (value, name) pair. Names list may be
    // shorter; fall back to the value as the display name when missing.
    for (var i = 0; i < values.length; i++) {
      out.add({
        'filterKey': filterKey,
        'filterValue': values[i],
        'selectedFilterName': i < names.length ? names[i] : values[i],
        'showOnUi': showOnUi,
      });
    }
  }
  return out;
}

// ── records ──────────────────────────────────────────────────────────────────

List<Map<String, dynamic>> _transformRecords(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().map(_transformProduct).toList();
}

Map<String, dynamic> _transformProduct(Map<String, dynamic> p) {
  return {
    'id': (p['id'] as num?)?.toInt() ?? 0,
    'name': p['name'] as String? ?? '',
    'brandName': p['brandName'] as String?,
    'isWishlisted': p['isWishlisted'] as bool? ?? false,
    // The listing response delivers wishlistId as an int per product;
    // we stringify because POST /wishlist's response (the canonical add path)
    // returns it as a string (wishlistItemId) and downstream DELETE expects a
    // string path segment. Normalising at the boundary keeps the entity uniform.
    'wishlistId': p['wishlistId'] is num
        ? (p['wishlistId'] as num).toString()
        : p['wishlistId'] as String?,
    'quantity': (p['quantity'] as num?)?.toInt() ?? 0,
    'soldOut': p['soldOut'] as bool? ?? false,
    'isXLTile': p['isXLTile'] as bool? ?? false,
    'isCPT': (p['isTile'] as int? ?? 0) != 0,
    'canWishlist': (p['canWishList'] as num?)?.toInt() == 1,
    'imageUrls': _resolveImageUrls(p),
    'price': _buildPrice(p),
    'colorVariants': _resolveColorVariants(p['colorVariants']),
    'actionUri': p['actionUri'] as String?,
    'visualCue': p['visualCue'] as Map<String, dynamic>?,
    'trackingMeta': p['trackingMeta'],
  };
}

List<String> _resolveImageUrls(Map<String, dynamic> p) {
  final urls = (p['productImageUrls'] as List?)
      ?.whereType<String>()
      .where((s) => s.isNotEmpty)
      .toList();
  if (urls != null && urls.isNotEmpty) return urls;
  for (final key in ['largeImg', 'mediumImg', 'smallImg']) {
    final url = p[key] as String?;
    if (url != null && url.isNotEmpty) return [url];
  }
  return const [];
}

Map<String, dynamic> _buildPrice(Map<String, dynamic> p) {
  final selling = (p['retailPrice'] as num?)?.toInt() ?? 0;
  final mrp = (p['regularPrice'] as num?)?.toInt() ?? 0;
  final discount = (p['discount'] as num?)?.toInt() ?? 0;
  return {
    'sellingPrice': '₹$selling',
    'mrp': '₹$mrp',
    'discountLabel': discount > 0 ? '$discount% OFF' : null,
  };
}

String? _resolveColorVariants(dynamic cv) {
  if (cv == null) return null;
  int count = 0;
  if (cv is List) {
    count = cv.length;
  } else if (cv is Map) {
    for (final key in ['data', 'variants', 'list', 'items', 'colors']) {
      final child = cv[key];
      if (child is List) {
        count = child.length;
        break;
      }
    }
    if (count == 0 && cv['count'] is num) {
      count = (cv['count'] as num).toInt();
    }
  }
  return count > 0 ? '+$count Colors' : null;
}

// ── helpers ──────────────────────────────────────────────────────────────────

List<Map<String, dynamic>> _passThrough(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().toList();
}

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}
