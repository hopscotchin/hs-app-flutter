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
  static const String pageSize = '20';

  // Segment
  static String get segmentDebugUrl => EnvConfig.segmentDebugUrl;
  static String get segmentReleaseUrl => EnvConfig.segmentReleaseUrl;

  // API Endpoints - Core
  static const String customerInfo = '/customer/v3/info';
  static const String appConfig = '/v1/app-config';

  // Home/Discover
  static const String homePage = '/page/v13';
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
  static const String promoCode = '/promotion/v2';
  static const String buyNow = '/shopping-cart/instant-checkout';
  static const String orderNow = '/checkout/buy-now/v4';

  // Wishlist
  static const String wishlist = '/wishlist';
  static const String moveToWishlistFromCart = '/wishlist/move-to-wishlist';

  // Auth — proposed v3 endpoints (swap in when backend ships; delete transformer files)
  static const String sendOtp = '/customer/v3/auth/send-otp';
  static const String verifyOtp = '/customer/v3/auth/verify-otp';
  static const String singUpSendOtp = '/customer/v3/auth/signup/send-otp';
  static const String checkMobile = '/customer/v3/auth/check-mobile';

  // Device
  static const String registerDevice = '/my/register';

  // Auto login
  static const String autoLogin = '/customer/login/auto';

  // Web SSO — generates a short-lived ticket appended to web URLs so an
  // already-authenticated app session is carried into the in-app WebView.
  static const String generateLoginTicket = '/customer/login/generate-ticket';

  // Account
  static const String myAccount = '/myaccount';
  static const String logout = '/customer/logout';
  static const String forgetGuestUser = '/customer/flush-data/guestuser';

  // Address Management
  static const String addresses = '/delivery/addresses/v3';
  static const String customerAddresses = '/customer/v2/addresses';
  static const String createAddress = '/customer/v3/saveAddress';
  static const String createAddressCart = '/delivery/v3/saveAddress';
  static const String updateAddress = '/customer/v3/updateAddress/{addressId}';
  static const String deleteAddress = '/customer/deleteAddress/{addressId}';
  static const String checkPincode = '/delivery/pincode/v3/serviceability/{pincode}';
  static const String checkPincodeExchange = '/delivery/pincode/v3/availability/{pincode}';
  static const String selectAddress = '/delivery/selectAddress/{addressId}';

  // Pincode (delivery serviceability bottom sheet)
  static const String deliveryPincode = '/delivery/pincode/{pincode}';

  // PDP (Product Detail)
  static const String productDetails = '/v2/product';

  // PLP (Product Listing)
  static const String boutiqueProducts = '/search/product/v6';
  static const String plpProducts = '/products/v8';
  static const String plpFilter = '/v2/filter';
  static const String pincodeCheck = '/products/pincode';

  // Search
  static const String searchAutoSuggest = '/search/autoSuggest';

  // Checkout / Payment
  static const String placeOrder = '/checkout/v4/place-order';
  static const String retryPlaceOrder = '/recovery/place-order';
  static const String initPayment = '/v2/init-payment';
  static const String paymentStatus = '/v1'; // append /{orderId}/payment-status
  static const String paymentRetryDetail = '/re-attempt/detail'; // append /{orderId}
  static const String markOrderFail = '/checkout/order-fail';
  static const String orderConfirmation = '/v2/checkout'; // append /{orderId}/confirmation
}
