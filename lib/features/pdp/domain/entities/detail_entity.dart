import 'package:equatable/equatable.dart';

class DetailEntity extends Equatable {
  final String? description;
  final TabDataEntity? tabData;
  final String? tabName;

  const DetailEntity({this.description, this.tabData, this.tabName});

  @override
  List<Object?> get props => [description, tabData, tabName];
}

class TabDataEntity extends Equatable {
  final List<ProductInfoEntity> data;
  final String? layout;
  final bool? showBullets;
  final bool? showDividers;

  const TabDataEntity({
    this.data = const [],
    this.layout,
    this.showBullets,
    this.showDividers,
  });

  @override
  List<Object?> get props => [data, layout, showBullets, showDividers];
}

class ProductInfoEntity extends Equatable {
  final String? key;
  final List<String> values;

  const ProductInfoEntity({this.key, this.values = const []});

  @override
  List<Object?> get props => [key, values];
}
