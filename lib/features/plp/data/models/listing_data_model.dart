import '../../domain/entities/listing_data_entity.dart';
import 'floating_filter_model.dart';
import 'listing_header_model.dart';
import 'listing_product_model.dart';
import 'plp_config_model.dart';
import 'plp_filter_model.dart';
import 'sorting_option_model.dart';

class ListingDataModel extends ListingDataEntity {
  const ListingDataModel({
    super.orderRule,
    super.records,
    super.pageNo,
    super.pageSize,
    super.totalRecords,
    super.screenName,
    super.salePlanId,
    super.salePlanDetail,
    super.plpConfig,
    super.plpFilter,
    super.sortingOptions,
    super.floatingFilter,
  });

  ListingDataModel.fromJson(super.json)
    : super.fromJson(
        orderRule: (json['orderRule'] as num?)?.toInt(),
        records:
            (json['records'] as List<dynamic>?)
                ?.map(
                  (e) =>
                      ListingProductModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            const [],
        pageNo: (json['pageNo'] as num?)?.toInt() ?? 0,
        pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
        totalRecords: (json['totalRecords'] as num?)?.toInt() ?? 0,
        screenName: json['screenName'] as String?,
        salePlanId: json['salePlanId']?.toString(),
        salePlanDetail: json['salePlanDetail'] != null
            ? ListingHeaderModel.fromJson(
                json['salePlanDetail'] as Map<String, dynamic>,
              )
            : null,
        plpConfig: json['plpConfig'] != null
            ? PlpConfigModel.fromJson(json['plpConfig'] as Map<String, dynamic>)
            : null,
        plpFilter: json['plpFilter'] != null
            ? PlpFilterModel.fromJson(json['plpFilter'] as Map<String, dynamic>)
            : null,
        sortingOptions:
            (json['sortingOptions'] as List<dynamic>?)
                ?.map(
                  (e) => SortingOptionModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            const [],
        floatingFilter: json['floatingFilter'] != null
            ? FloatingFilterModel.fromJson(
                json['floatingFilter'] as Map<String, dynamic>,
              )
            : null,
      );
}
