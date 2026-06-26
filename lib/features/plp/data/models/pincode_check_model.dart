import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
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

  @JsonKey(fromJson: parseToBool)
  final bool serviceable;
  @JsonKey(fromJson: parseToBool)
  final bool codAvailable;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? edd;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? eddPrefix;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? eddSuffix;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? eddSecondaryMsg;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? eddColor;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? eddTextColor;
  @JsonKey(fromJson: parseToStringOrNull)
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
