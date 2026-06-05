import 'package:equatable/equatable.dart';

import 'address_entity.dart';

enum ManageAddressFlow {
  account,
  cart,
  cartLogin,
  exchange,
  returnFlow,
}

enum ManageAddressMode { create, update }

typedef ManageAddressResult = ({AddressEntity? address, String? popUpMessage});

class ManageAddressArgs extends Equatable {
  const ManageAddressArgs({
    this.flow = ManageAddressFlow.account,
    this.fromScreen,
    this.address,
    this.popUpStyle = false,
  });

  final ManageAddressFlow flow;
  final String? fromScreen;
  final AddressEntity? address;
  final bool popUpStyle;

  ManageAddressMode get mode =>
      address == null ? ManageAddressMode.create : ManageAddressMode.update;

  bool get isCartFlow =>
      flow == ManageAddressFlow.cart || flow == ManageAddressFlow.cartLogin;

  @override
  List<Object?> get props => [
    flow,
    fromScreen,
    address,
    popUpStyle,
  ];
}
