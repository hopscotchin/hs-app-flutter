/// Legacy deep-link host constants from Android TileAction.java.
///
/// These arrive via `hopscotch://<host>?id=<value>` from push notifications,
/// API action URLs, and older app versions. Kept for backward compatibility.
abstract final class DeeplinkHost {
  // PLP / Listing
  static const productsListing = 'productsListing';
  static const customTiles = 'customTiles';
  static const boutiquesListing = 'boutiquesListing';
  static const specialPage = 'special';
  static const collections = 'collections';
  static const bestsellersPage = 'bestsellersPage';
  static const newPage = 'newPage';
  static const salePage = 'salePage';
  static const endingSoon = 'endingSoon';
  static const upcomingPage = 'upcomingPage';

  // PDP
  static const productPage = 'productPage';

  // Search
  static const searchPage = 'searchPage';

  // Home / Discover
  static const discoverPage = 'discoverPage';
  static const homePage = 'homePage';
  static const changeSortBar = 'changeSortBar';
  static const notificationPermission = 'notificationPermission';

  // Cart
  static const shoppingCart = 'shoppingCart';
  static const cartMerge = 'cartMerge';

  // Account / Me
  static const meTab = 'meTab';
  static const accountPage = 'accountPage';
  static const facebook = 'facebook';

  // Orders
  static const ordersListing = 'ordersListing';
  static const orderDetails = 'orderDetails';
  static const orderTracking = 'orderTracking';
  static const orderReturn = 'orderReturn';

  // Auth
  static const signInPage = 'signInPage';
  static const signInEmail = 'signInEmail';
  static const signInMobile = 'signInMobile';
  static const signUp = 'signUp';
  static const join = 'join';

  // Auth (message bar / new format)
  static const signupLink = 'signup';
  static const signinMobileLink = 'signin-mobile';

  // Profile
  static const address = 'address';
  static const name = 'name';
  static const email = 'email';
  static const password = 'password';
  static const setPassword = 'setPassword';
  static const mobile = 'mobile';
  static const mobileVerify = 'mobileVerify';
  static const addMobile = 'addMobile';

  // Kids
  static const addKids = 'addKids';
  static const aboutKids = 'aboutKids';

  // Credits / Wishlist / Offers
  static const credits = 'credits';
  static const wishlist = 'wishlist';
  static const offers = 'offers';
  static const offersFromPdp = 'offersFromPdp';

  // Ratings
  static const productRatings = 'productRatings';
  static const productRating = 'productRating';

  // Misc
  static const legal = 'legal';
  static const helpCenter = 'helpCenter';
  static const contactUs = 'contactUs';
  static const rateApp = 'rateApp';
  static const updateApp = 'updateApp';
  static const updateApp2 = 'updateApp2';
  static const sizeChart = 'sizeChart';
  static const tabbedLandingPage = 'tabbedLandingPage';
  static const bottomSheet = 'bottomSheet';
}
