// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/orders_page_entity.dart';
import 'order_info_model.dart';

part 'orders_page_response_model.freezed.dart';
part 'orders_page_response_model.g.dart';

/// Network envelope for a page of the user's order history.
///
/// Carries only success-path fields. Error envelopes (`action`, `errorMsg`)
/// are detected and thrown as `ApiFailureException` inside `ApiClient` and
/// then mapped to `Failure` by `safeApiCall` — so this model assumes success.
@freezed
abstract class OrdersPageResponseModel with _$OrdersPageResponseModel {
  const OrdersPageResponseModel._();

  const factory OrdersPageResponseModel({
    @JsonKey(fromJson: parseToInt) @Default(0) int totalRecords,
    @Default(<OrderInfoModel>[]) List<OrderInfoModel> items,
  }) = _OrdersPageResponseModel;

  factory OrdersPageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersPageResponseModelFromJson(json);

  OrdersPageEntity toEntity() => OrdersPageEntity(
    totalRecords: totalRecords,
    items: items.map((m) => m.toEntity()).toList(growable: false),
  );
}
