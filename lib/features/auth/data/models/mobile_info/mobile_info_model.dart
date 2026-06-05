import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/mobile_info/mobile_info_entity.dart';

part 'mobile_info_model.g.dart';

@JsonSerializable(createToJson: false)
class MobileInfoModel {
  const MobileInfoModel({this.number = '', this.isVerified = false});

  @JsonKey(defaultValue: '')
  final String number;
  @JsonKey(defaultValue: false)
  final bool isVerified;

  factory MobileInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MobileInfoModelFromJson(json);
}

extension MobileInfoModelX on MobileInfoModel {
  MobileInfoEntity toEntity() =>
      MobileInfoEntity(number: number, isVerified: isVerified);
}
