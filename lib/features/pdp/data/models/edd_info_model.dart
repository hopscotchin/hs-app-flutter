import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/edd_info_entity.dart';

part 'edd_info_model.g.dart';

@JsonSerializable(createToJson: false)
class EddInfoModel {
  const EddInfoModel({this.destination, this.edd, this.orderSla});

  @JsonKey(defaultValue: null) final String? destination;
  @JsonKey(defaultValue: null) final String? edd;
  @JsonKey(defaultValue: null) final String? orderSla;

  factory EddInfoModel.fromJson(Map<String, dynamic> json) =>
      _$EddInfoModelFromJson(json);
}

extension EddInfoModelX on EddInfoModel {
  EddInfoEntity toEntity() =>
      EddInfoEntity(destination: destination, edd: edd, orderSla: orderSla);
}
