part of 'pdp_bloc.dart';

abstract class PdpEvent extends Equatable {
  const PdpEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetails extends PdpEvent {
  final int productId;

  const LoadProductDetails({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class SelectSku extends PdpEvent {
  final String skuId;

  const SelectSku({required this.skuId});

  @override
  List<Object?> get props => [skuId];
}

class ToggleWishlist extends PdpEvent {
  const ToggleWishlist();
}

class AddToBag extends PdpEvent {
  final String skuId;

  const AddToBag({required this.skuId});

  @override
  List<Object?> get props => [skuId];
}

class BuyNow extends PdpEvent {
  final String skuId;

  const BuyNow({required this.skuId});

  @override
  List<Object?> get props => [skuId];
}

class VerifyPincode extends PdpEvent {
  final String pincode;

  const VerifyPincode({required this.pincode});

  @override
  List<Object?> get props => [pincode];
}

class SelectColorVariant extends PdpEvent {
  final int productId;

  const SelectColorVariant({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ExpandDetailTab extends PdpEvent {
  final int tabIndex;

  const ExpandDetailTab({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}
