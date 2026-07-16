import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/pincode_check_model.dart';
import '../../models/product_detail_model.dart';
import '../../models/recommendations_model.dart';
import '../../models/size_chart_model.dart';

part 'pdp_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class PdpRemoteDatasource {
  @factoryMethod
  factory PdpRemoteDatasource(Dio dio) = _PdpRemoteDatasource;

  @GET('${ApiConstants.productDetails}/{productId}')
  Future<ProductDetailModel> getProductDetails({
    @Path('productId') required int productId,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('${ApiConstants.recommendations}/{productId}')
  Future<RecommendationsModel> getRecommendations({
    @Path('productId') required int productId,
    @Query('pageNo') required int pageNo,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('${ApiConstants.productDetails}/{productId}/edd')
  Future<PincodeCheckModel> verifyPincode({
    @Path('productId') required int productId,
    @Query('pincode') required String pincode,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('${ApiConstants.sizeChart}/{productId}')
  Future<SizeChartModel> getSizeChart({
    @Path('productId') required int productId,
    @CancelRequest() CancelToken? cancelToken,
  });
}
