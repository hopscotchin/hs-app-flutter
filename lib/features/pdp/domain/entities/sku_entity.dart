import 'package:equatable/equatable.dart';

import 'edd_info_entity.dart';
import 'price_entity.dart';
import 'warning_entity.dart';

class SkuEntity extends Equatable {
  final String? skuId;
  final String? size;
  final PriceEntity? price;
  final bool? enable;
  final int? availableQuantity;
  final EddInfoEntity? eddInfo;
  final WarningEntity? warning;
  final bool isSelected;
  final bool isAddedToBag;

  const SkuEntity({
    this.skuId,
    this.size,
    this.price,
    this.enable,
    this.availableQuantity,
    this.eddInfo,
    this.warning,
    this.isSelected = false,
    this.isAddedToBag = false,
  });

  SkuEntity copyWith({
    EddInfoEntity? eddInfo,
    bool? isSelected,
    bool? isAddedToBag,
  }) {
    return SkuEntity(
      skuId: skuId,
      size: size,
      price: price,
      enable: enable,
      availableQuantity: availableQuantity,
      eddInfo: eddInfo ?? this.eddInfo,
      warning: warning,
      isSelected: isSelected ?? this.isSelected,
      isAddedToBag: isAddedToBag ?? this.isAddedToBag,
    );
  }

  @override
  List<Object?> get props => [
    skuId,
    size,
    price,
    enable,
    availableQuantity,
    eddInfo,
    warning,
    isSelected,
    isAddedToBag,
  ];
}
