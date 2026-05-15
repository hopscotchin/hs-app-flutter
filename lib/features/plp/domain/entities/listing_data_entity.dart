import '../../../../core/network/models/action_response.dart';

import 'floating_filter_entity.dart';
import 'listing_header_entity.dart';
import 'listing_product_entity.dart';
import 'plp_config_entity.dart';
import 'plp_filter_entity.dart';
import 'sorting_option_entity.dart';

class ListingDataEntity extends ActionResponse {
  final int? orderRule;
  final List<ListingProductEntity> records;
  final int pageNo;
  final int pageSize;
  final int totalRecords;
  final String? screenName;
  final String? salePlanId;
  final ListingHeaderEntity? salePlanDetail;
  final PlpConfigEntity? plpConfig;
  final PlpFilterEntity? plpFilter;
  final List<SortingOptionEntity> sortingOptions;
  final FloatingFilterEntity? floatingFilter;

  const ListingDataEntity({
    super.action,
    super.message,
    this.orderRule,
    this.records = const [],
    this.pageNo = 0,
    this.pageSize = 20,
    this.totalRecords = 0,
    this.screenName,
    this.salePlanId,
    this.salePlanDetail,
    this.plpConfig,
    this.plpFilter,
    this.sortingOptions = const [],
    this.floatingFilter,
  });

  ListingDataEntity.fromJson(
    super.json, {
    this.orderRule,
    this.records = const [],
    this.pageNo = 0,
    this.pageSize = 20,
    this.totalRecords = 0,
    this.screenName,
    this.salePlanId,
    this.salePlanDetail,
    this.plpConfig,
    this.plpFilter,
    this.sortingOptions = const [],
    this.floatingFilter,
  }) : super.fromJson();

  bool get hasMorePages => totalRecords > (pageNo * pageSize);

  @override
  List<Object?> get props => [
    action,
    orderRule,
    records,
    pageNo,
    pageSize,
    totalRecords,
    screenName,
    salePlanId,
    salePlanDetail,
    plpConfig,
    plpFilter,
    sortingOptions,
    floatingFilter,
  ];
}
