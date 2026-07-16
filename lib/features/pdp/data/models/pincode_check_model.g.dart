// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pincode_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PincodeCheckModel _$PincodeCheckModelFromJson(Map<String, dynamic> json) =>
    PincodeCheckModel(
      action: json['action'] as String?,
      message: json['message'] as String?,
      skus:
          (json['skus'] as List<dynamic>?)
              ?.map((e) => SkuModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isServiceable: json['isServiceable'] as bool?,
      eddInfo: _eddInfoFromJson(json['eddInfo']),
      visualCues:
          (json['visualCues'] as List<dynamic>?)
              ?.map((e) => VisualCueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      serviceGuarantee:
          (json['serviceGuarantee'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ServiceGuaranteeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      noPinCodeMessage: json['noPinCodeMessage'] as String?,
    );
