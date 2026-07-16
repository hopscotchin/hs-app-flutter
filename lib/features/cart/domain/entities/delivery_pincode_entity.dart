import 'package:equatable/equatable.dart';

class DeliveryPincodeEntity extends Equatable {
  final String? pincode;
  final String? pincodeMessage;
  final String? city;

  const DeliveryPincodeEntity({this.pincode, this.pincodeMessage, this.city});

  @override
  List<Object?> get props => [pincode, pincodeMessage, city];
}
