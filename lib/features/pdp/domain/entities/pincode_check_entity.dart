import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import 'edd_info_entity.dart';
import 'service_guarantee_entity.dart';
import 'sku_entity.dart';

part 'pincode_check_entity.freezed.dart';

@freezed
abstract class PincodeCheckEntity with _$PincodeCheckEntity {
  const factory PincodeCheckEntity({
    String? action,
    String? message,
    @Default([]) List<SkuEntity> skus,
    bool? isServiceable,
    EddInfoEntity? eddInfo,
    @Default([]) List<VisualCueEntity> visualCues,
    @Default([]) List<ServiceGuaranteeEntity> serviceGuarantee,
    String? noPinCodeMessage,

    /// The pincode-scoped slice of `product.trackingMeta` — `from_pincode` and
    /// `delivery_days`, the two keys a pincode change moves.
    ///
    /// **Partial.** Merged over the product's existing node key by key; replacing
    /// it would drop the other 23 keys and every event after a pincode check
    /// would lose `brand`, `category`, `price` and the rest. See
    /// `docs/analytics/pdp/contract/passthrough-spec.md` §2.
    Map<String, dynamic>? trackingMeta,
  }) = _PincodeCheckEntity;
}
