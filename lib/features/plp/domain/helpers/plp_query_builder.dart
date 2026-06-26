import 'dart:convert';

import '../entities/page_type.dart';

class PlpQueryBuilder {
  PageType pageType;
  int plpId;
  String? searchQuery;
  String? rawSearchParams;
  int currentPage;
  int? orderRule;

  /// Set when the current request is the result of the user refining filters
  /// (apply / remove / multi-select / floating). It is intentionally NOT part
  /// of [filterParams] so that it survives independently of the actual filters
  /// and is only emitted by [build] when real filters are present.
  bool isFromRefineFilter = false;

  final Map<String, String> filterParams = {};
  static const int pageSize = 20;

  PlpQueryBuilder({
    this.pageType = PageType.plp,
    this.plpId = 0,
    this.searchQuery,
    this.rawSearchParams,
    this.currentPage = 0,
    this.orderRule,
  });

  Map<String, dynamic> build() {
    final params = <String, dynamic>{'pageNo': currentPage + 1, 'pageSize': pageSize};

    switch (pageType) {
      case PageType.plp:
        params['id'] = plpId;
        break;
      case PageType.boutique:
        params['salePlanId'] = plpId;
        params['filterQuery'] = 'salePlanId=$plpId';
        break;
      case PageType.search:
        if (rawSearchParams != null) {
          params['searchParams'] = base64Encode(utf8.encode(rawSearchParams!));
        } else if (searchQuery != null) {
          params['keyWord'] = searchQuery;
          params['filterQuery'] = 'keyWord=$searchQuery';
        }
        break;
    }

    if (orderRule != null) {
      params['orderRule'] = orderRule;
    }

    params.addAll(filterParams);

    // Only flag a request as a filter-refine when the user actually refined AND
    // real filters are in play. Keeps it off plain pagination (page 2+ with no
    // filters), off initial/deeplink loads, and off a request where every
    // filter was just removed.
    if (isFromRefineFilter && filterParams.isNotEmpty) {
      params['isFromRefineFilter'] = 'true';
    }

    return params;
  }

  void reset({
    required PageType pageType,
    required int plpId,
    String? searchQuery,
    String? rawSearchParams,
    Map<String, String>? initialFilters,
  }) {
    this.pageType = pageType;
    this.plpId = plpId;
    this.searchQuery = searchQuery;
    this.rawSearchParams = rawSearchParams;
    currentPage = 0;
    orderRule = null;
    isFromRefineFilter = false;
    filterParams.clear();
    if (initialFilters != null) {
      filterParams.addAll(initialFilters);
    }
  }

  void nextPage() => currentPage++;

  void prevPage() {
    if (currentPage > 0) currentPage--;
  }
}
