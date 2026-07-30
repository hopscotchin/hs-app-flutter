abstract final class RouteNames {
  // ─── URL paths ────────────────────────────────────────────────────
  // Assigned to `GoRoute.path`. Leading slash form.
  static const String splash = '/';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String account = '/account';
  static const String cart = '/cart';
  static const String search = '/search';
  static const String plp = '/plp';
  static const String pdp = '/pdp/:productId';
  static const String pdpImageGallery = '/pdp-image-gallery';
  static const String login = '/login';
  static const String joinUs = '/join-us';
  static const String otpVerification = '/otp-verification';
  static const String checkoutLogin = '/checkout-login';
  static const String webView = '/webview';
  static const String paymentState = '/payment-state';
  static const String paymentRetry = '/payment-retry';
  static const String landingPage = '/landing-page';
  static const String orderConfirmation = '/order-confirmation';
  static const String orders = '/orders';
  static const String addresses = '/addresses';
  static const String addAddress = 'add';
  static const String legal = '/legal';
  static const String analyticsDebug = '/analytics-debug';

  // ─── GoRoute name identifiers ─────────────────────────────────────
  // Assigned to `GoRoute.name` and passed to `context.pushNamed(...)`.
  // Kept distinct from paths because they're independent GoRouter concepts
  // and existing route registrations use the bare-identifier form.
  // These values are also matched against `route.settings.name` inside
  // `AppNavigationObserver` — keeping them here as constants avoids
  // scattered string literals across observer maps.
  static const String splashName = 'splash';
  static const String homeName = 'home';
  static const String categoriesName = 'categories';
  static const String accountName = 'account';
  static const String cartName = 'cart';
  static const String searchName = 'search';
  static const String plpName = 'plp';
  static const String pdpName = 'pdp';
  static const String landingPageName = 'landingPage';
}
