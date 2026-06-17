import '../../domain/entities/product_detail_entity.dart';
import 'banner_model.dart';
import 'product_model.dart';

class ProductDetailModel extends ProductDetailEntity {
  const ProductDetailModel({super.banners, super.product});

  ProductDetailModel.fromJson(super.json)
    : super.fromJson(
        banners: _parseBanners(json),
        product: _parseProduct(json),
      );

  static List<BannerModel> _parseBanners(Map<String, dynamic> json) {
    final rawBanners = json['banners'] as List<dynamic>? ?? [];
    return rawBanners
        .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static ProductModel? _parseProduct(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>?;
    return productJson != null ? ProductModel.fromJson(productJson) : null;
  }
}
