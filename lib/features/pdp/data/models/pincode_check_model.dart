import '../../../../core/models/visual_cue_model.dart';
import '../../domain/entities/pincode_check_entity.dart';
import 'edd_info_model.dart';
import 'service_guarantee_model.dart';
import 'sku_model.dart';

class PincodeCheckModel extends PincodeCheckEntity {
  const PincodeCheckModel({
    super.skus,
    super.isServiceable,
    super.eddInfo,
    super.visualCues,
    super.serviceGuarantee,
    super.noPinCodeMessage,
  });

  PincodeCheckModel.fromJson(super.json)
    : super.fromJson(
        skus: _parseSkus(json),
        isServiceable: json['isServiceable'] as bool?,
        eddInfo: json['eddInfo'] != null
            ? EddInfoModel.fromJson(json['eddInfo'] as Map<String, dynamic>)
            : null,
        visualCues: _parseVisualCues(json),
        serviceGuarantee: _parseServiceGuarantee(json),
        noPinCodeMessage: json['noPinCodeMessage'] as String?,
      );

  static List<SkuModel> _parseSkus(Map<String, dynamic> json) {
    final rawSkus = json['skus'] as List<dynamic>? ?? [];
    return rawSkus
        .map((e) => SkuModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<VisualCueModel> _parseVisualCues(Map<String, dynamic> json) {
    final raw = json['visualCues'] as List<dynamic>? ?? [];
    return raw
        .map((e) => VisualCueModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<ServiceGuaranteeModel> _parseServiceGuarantee(
    Map<String, dynamic> json,
  ) {
    final raw = json['serviceGuarantee'] as List<dynamic>? ?? [];
    return raw
        .map((e) => ServiceGuaranteeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
