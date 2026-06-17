import '../../domain/entities/edd_info_entity.dart';

class EddInfoModel extends EddInfoEntity {
  const EddInfoModel({super.destination, super.edd, super.orderSla});

  factory EddInfoModel.fromJson(Map<String, dynamic> json) {
    return EddInfoModel(
      destination: json['destination'] as String?,
      edd: json['edd'] as String?,
      orderSla: json['orderSla'] as String?,
    );
  }
}
