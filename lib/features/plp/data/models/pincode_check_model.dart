import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/pincode_check_entity.dart';

part 'pincode_check_model.g.dart';

@JsonSerializable(createToJson: false)
class PincodeCheckModel {
  const PincodeCheckModel({
    this.serviceable = false,
    this.codAvailable = false,
    this.edd,
    this.eddPrefix,
    this.eddSuffix,
    this.eddSecondaryMsg,
    this.eddColor,
    this.eddTextColor,
    this.noPinCodeMessage,
  });

  @JsonKey(defaultValue: false)
  final bool serviceable;
  @JsonKey(defaultValue: false)
  final bool codAvailable;
  final String? edd;
  final String? eddPrefix;
  final String? eddSuffix;
  final String? eddSecondaryMsg;
  final String? eddColor;
  final String? eddTextColor;
  final String? noPinCodeMessage;

  factory PincodeCheckModel.fromJson(Map<String, dynamic> json) =>
      _$PincodeCheckModelFromJson(json);
}

extension PincodeCheckModelX on PincodeCheckModel {
  PincodeCheckEntity toEntity() => PincodeCheckEntity(
        serviceable: serviceable,
        codAvailable: codAvailable,
        edd: edd,
        eddPrefix: eddPrefix,
        eddSuffix: eddSuffix,
        eddSecondaryMsg: eddSecondaryMsg,
        eddColor: eddColor,
        eddTextColor: eddTextColor,
        noPinCodeMessage: noPinCodeMessage,
      );
}
