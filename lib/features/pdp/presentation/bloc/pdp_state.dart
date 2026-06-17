part of 'pdp_bloc.dart';

abstract class PdpState extends Equatable {
  const PdpState();

  @override
  List<Object?> get props => [];
}

class PdpInitial extends PdpState {
  const PdpInitial();
}

class PdpLoading extends PdpState {
  const PdpLoading();
}

class PdpLoaded extends PdpState {
  final ProductDetailEntity productDetail;
  final SkuEntity? selectedSku;
  final int expandedDetailTab;
  final bool isAddingToBag;
  final bool isBuyingNow;
  final String? addToBagMessage;

  const PdpLoaded({
    required this.productDetail,
    this.selectedSku,
    this.expandedDetailTab = -1,
    this.isAddingToBag = false,
    this.isBuyingNow = false,
    this.addToBagMessage,
  });

  PdpLoaded copyWith({
    ProductDetailEntity? productDetail,
    SkuEntity? selectedSku,
    bool clearSelectedSku = false,
    int? expandedDetailTab,
    bool? isAddingToBag,
    bool? isBuyingNow,
    String? addToBagMessage,
    bool clearAddToBagMessage = false,
  }) {
    return PdpLoaded(
      productDetail: productDetail ?? this.productDetail,
      selectedSku: clearSelectedSku ? null : (selectedSku ?? this.selectedSku),
      expandedDetailTab: expandedDetailTab ?? this.expandedDetailTab,
      isAddingToBag: isAddingToBag ?? this.isAddingToBag,
      isBuyingNow: isBuyingNow ?? this.isBuyingNow,
      addToBagMessage: clearAddToBagMessage
          ? null
          : (addToBagMessage ?? this.addToBagMessage),
    );
  }

  @override
  List<Object?> get props => [
    productDetail,
    selectedSku,
    expandedDetailTab,
    isAddingToBag,
    isBuyingNow,
    addToBagMessage,
  ];
}

class PdpError extends PdpState {
  final String message;

  const PdpError({required this.message});

  @override
  List<Object?> get props => [message];
}
