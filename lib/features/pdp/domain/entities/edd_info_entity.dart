import 'package:equatable/equatable.dart';

class EddInfoEntity extends Equatable {
  final String? destination;
  final String? edd;
  final String? orderSla;

  const EddInfoEntity({this.destination, this.edd, this.orderSla});

  @override
  List<Object?> get props => [destination, edd, orderSla];
}
