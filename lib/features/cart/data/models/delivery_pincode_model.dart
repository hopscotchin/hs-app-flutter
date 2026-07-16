import '../../domain/entities/delivery_pincode_entity.dart';

class DeliveryPincodeModel extends DeliveryPincodeEntity {
  const DeliveryPincodeModel({super.pincode, super.pincodeMessage, super.city});

  factory DeliveryPincodeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPincodeModel(
      pincode: json['pincode'] as String?,
      pincodeMessage: json['pincodeMessage'] as String?,
      city: json['city'] as String?,
    );
  }
}
