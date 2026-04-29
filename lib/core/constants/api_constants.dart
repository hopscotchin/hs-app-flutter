import '../config/env_config.dart';
import '../config/environment.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => EnvironmentConfig.baseUrl;
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Credentials (from .env)
  static String get authMethod => EnvConfig.authMethod;
  static String get secretKey => EnvConfig.secretKeyAndroid;
  static String get apiVersion => EnvConfig.apiVersion;
  static String get versionName => EnvConfig.versionName;
  static String get versionCode => EnvConfig.versionCode;
  static String get httpScheme => EnvConfig.httpScheme;
  static String get httpsScheme => EnvConfig.httpsScheme;
  static const String acceptType = 'application/json';

  // Segment
  static String get segmentDebugUrl => EnvConfig.segmentDebugUrl;
  static String get segmentReleaseUrl => EnvConfig.segmentReleaseUrl;

  // API Endpoints - Core
  static const String customerInfo = '/customer/v2/info';
  static const String appConfig = '/v1/app-config';

  // Home/Discover
  static const String homePage = '/page/v12';
  static const String pageCarousel = '/v4/pagecarousel';
  static const String boutiques = '/boutiques/action';
  static const String customTiles = '/customTiles/v2';
  static const String collections = '/collections/v2';

  // Categories/Departments
  static const String loadDepartments = '/loadDepartments';

  // Moments
  static const String momentsFeed = '/moments/photo';
  static const String momentsMyFeed = '/moments/photo/customer';
  static const String momentsLike = '/moments/photo';
  static const String momentsUpload = '/moments/photo';

  // Cart
  static const String shoppingCart = '/shopping-cart/v5';
  static const String addToCart = '/shopping-cart/add-product/v2';
  static const String removeFromCart = '/shopping-cart/v2';
  static const String updateCartItem = '/shopping-cart/v2';
  static const String mergeCart = '/shopping-cart/merge';

}
