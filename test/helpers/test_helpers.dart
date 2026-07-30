import 'package:mocktail/mocktail.dart';

import 'package:hs_app_flutter/core/analytics/events/analytics_helper.dart';
import 'package:hs_app_flutter/core/cubits/cart_count_cubit.dart';
import 'package:hs_app_flutter/core/network/api_client.dart';
import 'package:hs_app_flutter/core/network/connectivity/network_info.dart';
import 'package:hs_app_flutter/core/services/pref_manager.dart';
import 'package:hs_app_flutter/features/discover/domain/repositories/home_repository.dart';
import 'package:hs_app_flutter/features/discover/domain/usecases/get_home_page_usecase.dart';
import 'package:hs_app_flutter/features/pdp/domain/repositories/pdp_repository.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:hs_app_flutter/features/pdp/domain/usecases/get_product_details_usecase.dart';
import 'package:hs_app_flutter/features/pdp/domain/usecases/verify_pincode_usecase.dart';
import 'package:hs_app_flutter/features/plp/domain/repositories/plp_repository.dart';
import 'package:hs_app_flutter/features/plp/domain/usecases/get_listing_data_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';

// Core Mocks
class MockApiClient extends Mock implements ApiClient {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockPrefManager extends Mock implements PrefManager {}

class MockCartCountCubit extends Mock implements CartCountCubit {}

class MockAnalyticsHelper extends Mock implements AnalyticsHelper {}

// Repository Mocks
class MockHomeRepository extends Mock implements HomeRepository {}

class MockPlpRepository extends Mock implements PlpRepository {}

class MockProductDetailRepository extends Mock implements PdpRepository {}

// UseCase Mocks
class MockGetHomePageUseCase extends Mock implements GetHomePageUseCase {}

class MockGetListingDataUseCase extends Mock implements GetListingDataUseCase {}

class MockGetProductDetailsUseCase extends Mock implements GetProductDetailsUseCase {}

class MockAddToCartUseCase extends Mock implements AddToCartUseCase {}

class MockAddToWishlistUseCase extends Mock implements AddToWishlistUseCase {}

class MockRemoveFromWishlistUseCase extends Mock implements RemoveFromWishlistUseCase {}

class MockVerifyPincodeUseCase extends Mock implements VerifyPincodeUseCase {}
