import 'dart:convert';

import '../entities/page_type.dart';

class PlpQueryBuilder {
  PageType pageType;
  int plpId;
  String? searchQuery;
  String? rawSearchParams;
  int currentPage;
  int? orderRule;
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
    final params = <String, dynamic>{
      'pageNo': currentPage + 1,
      'pageSize': pageSize,
    };

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
          params['keyword'] = searchQuery;
        }
        break;
    }

    if (orderRule != null) {
      params['orderRule'] = orderRule;
    }

    params.addAll(filterParams);

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
