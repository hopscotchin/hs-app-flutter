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
  }) = _PincodeCheckEntity;
}
