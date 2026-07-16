import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/pincode_check_entity.dart';
import 'edd_info_model.dart';
import 'service_guarantee_model.dart';
import 'sku_model.dart';
import 'visual_cue_model.dart';

part 'pincode_check_model.g.dart';

@JsonSerializable(createToJson: false)
class PincodeCheckModel {
  const PincodeCheckModel({
    this.action,
    this.message,
    this.skus = const [],
    this.isServiceable,
    this.eddInfo,
    this.visualCues = const [],
    this.serviceGuarantee = const [],
    this.noPinCodeMessage,
  });

  @JsonKey(defaultValue: null) final String? action;
  @JsonKey(defaultValue: null) final String? message;
  @JsonKey(defaultValue: []) final List<SkuModel> skus;
  @JsonKey(defaultValue: null) final bool? isServiceable;
  @JsonKey(defaultValue: null, fromJson: _eddInfoFromJson)
  final EddInfoModel? eddInfo;
  @JsonKey(defaultValue: []) final List<VisualCueModel> visualCues;
  @JsonKey(defaultValue: []) final List<ServiceGuaranteeModel> serviceGuarantee;
  @JsonKey(defaultValue: null) final String? noPinCodeMessage;

  factory PincodeCheckModel.fromJson(Map<String, dynamic> json) =>
      _$PincodeCheckModelFromJson(json);
}

EddInfoModel? _eddInfoFromJson(Object? json) =>
    json is Map<String, dynamic> ? EddInfoModel.fromJson(json) : null;

extension PincodeCheckModelX on PincodeCheckModel {
  PincodeCheckEntity toEntity() => PincodeCheckEntity(
    action: action,
    message: message,
    skus: skus.map((s) => s.toEntity()).toList(),
    isServiceable: isServiceable,
    eddInfo: eddInfo?.toEntity(),
    visualCues: visualCues.map((v) => v.toEntity()).toList(),
    serviceGuarantee: serviceGuarantee.map((s) => s.toEntity()).toList(),
    noPinCodeMessage: noPinCodeMessage,
  );
}
