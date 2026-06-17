import '../../../../core/network/models/action_response.dart';
import 'banner_entity.dart';
import 'product_entity.dart';

class ProductDetailEntity extends ActionResponse {
  final List<BannerEntity> banners;
  final ProductEntity? product;

  const ProductDetailEntity({
    super.action,
    super.message,
    this.banners = const [],
    this.product,
  });

  ProductDetailEntity.fromJson(
    super.json, {
    this.banners = const [],
    this.product,
  }) : super.fromJson();

  ProductDetailEntity copyWith({ProductEntity? product}) {
    return ProductDetailEntity(
      action: action,
      message: message,
      banners: banners,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [action, banners, product];
}
