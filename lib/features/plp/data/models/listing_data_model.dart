import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/listing_data_entity.dart';
import 'banners_wrapper_model.dart';
import 'floating_filter_model.dart';
import 'listing_product_model.dart';
import 'notification_nudge_model.dart';
import 'page_meta_model.dart';
import 'plp_filter_model.dart';
import 'query_correction_model.dart';
import 'tracking_meta_model.dart';

part 'listing_data_model.g.dart';

@JsonSerializable(createToJson: false)
class ListingDataModel {
  const ListingDataModel({
    this.pageMeta,
    this.trackingMeta,
    this.notificationNudge,
    this.banners,
    this.floatingFilter,
    this.filters,
    this.records = const [],
    this.queryCorrection,
    this.messageBars = const [],
    this.orderRule = -1,
    this.action,
    this.message,
  });

  /// `"success"` | `"failure"` — the BFF returns HTTP 200 even for logical
  /// failures, signalling the error via this field (with a human [message]).
  @JsonKey(fromJson: parseToStringOrNull)
  final String? action;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? message;

  final PageMetaModel? pageMeta;
  final TrackingMetaModel? trackingMeta;
  final NotificationNudgeModel? notificationNudge;

  final BannersWrapperModel? banners;

  final FloatingFilterModel? floatingFilter;
  final PlpFilterModel? filters;
  @JsonKey(defaultValue: [])
  final List<ListingProductModel> records;

  /// New v8 field. The Android equivalent is `queryCorrection` on
  /// `ListingDataDTO`. Drives the "Showing results for / Did you mean"
  /// banner shown above the product grid.
  final QueryCorrectionModel? queryCorrection;

  /// Info/promo strips shown above the product grid (e.g. "Get an extra 5% off
  /// …"). The response transformer passes the raw `messageBars` array through
  /// unchanged; parsing reuses the shared core [MessageBarModel] so the bars
  /// render through the same [MessageBarsWidget] as the rest of the app.
  @JsonKey(fromJson: _parseMessageBars)
  final List<MessageBarEntity> messageBars;

  @JsonKey(fromJson: _parseOrderRule)
  final int orderRule;

  bool get isFailure => action?.toLowerCase() == 'failure';

  factory ListingDataModel.fromJson(Map<String, dynamic> json) => _$ListingDataModelFromJson(json);

  ListingDataEntity toEntity() {
    final pageBanner = banners?.pageBanner?.toEntity();

    return ListingDataEntity(
      pageMeta: pageMeta?.toEntity(),
      trackingMeta: trackingMeta?.toEntity(),
      notificationNudge: notificationNudge?.toEntity(),
      banners: pageBanner == null ? const [] : [pageBanner],
      floatingFilter: floatingFilter?.toEntity(),
      filters: filters?.toEntity(),
      records: records.map((r) => r.toEntity()).toList(),
      queryCorrection: queryCorrection?.toEntity(),
      messageBars: messageBars,
      orderRule: orderRule,
    );
  }
}

List<MessageBarEntity> _parseMessageBars(Object? json) {
  if (json is! List) return const [];
  return json.whereType<Map<String, dynamic>>().map(MessageBarModel.fromJson).toList();
}

int _parseOrderRule(dynamic value) => parseToIntOrNull(value) ?? -1;
