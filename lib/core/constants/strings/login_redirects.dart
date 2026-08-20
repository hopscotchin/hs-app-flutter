abstract final class LoginRedirects {
  // ── Redirect type keys (mirrors Android's LoginActivity.RedirectTypes) ───
  static const typeCart = 'REDIRECT_CART';
  static const typeAddToCart = 'REDIRECT_ADD_TO_CART';
  static const typeOrders = 'REDIRECT_ORDERS';
  static const typeWishlistScreen = 'REDIRECT_WISHLIST_SCREEN';
  static const typeAddToWishlist = 'REDIRECT_ADD_TO_WISHLIST';
  static const typeReminder = 'REDIRECT_REMINDER';
  static const typeFav = 'REDIRECT_FAV';
  static const typeFavBrands = 'REDIRECT_FAV_BRANDS';
  static const typeCards = 'REDIRECT_CARDS';
  static const typeKids = 'REDIRECT_KIDS';
  static const typeWishlistItem = 'REDIRECT_WISHLIST_ITEM';
  static const typeWishlist = 'REDIRECT_WISHLIST';
  static const typeMomentLike = 'REDIRECT_MOMENT_LIKE';
  static const typeMomentUpload = 'REDIRECT_MOMENT_UPLOAD';
  static const typeRecent = 'REDIRECT_RECENT';
  static const typeVerifyMobile = 'REDIRECT_VERIFY_MOBILE';
  static const typeMomentDislike = 'REDIRECT_MOMENT_DISLIKE';
  static const typeAccountSettings = 'REDIRECT_ACCOUNT_SETTINGS';
  static const typeProfileImage = 'REDIRECT_PROFILE_IMAGE';
  static const typeAddresses = 'REDIRECT_ADDRESSES';
  static const typeProductReminder = 'REDIRECT_PRODUCT_REMINDER';
  static const typeCredits = 'REDIRECT_CREDITS';
  static const typePromo = 'REDIRECT_PROMO';
  static const typeOrderCancel = 'REDIRECT_ORDER_CANCEL';
  static const typeOrderReturn = 'REDIRECT_ORDER_RETURN';
  static const typeOrderCancelSignIn = 'REDIRECT_ORDER_CANCEL_SIGN_IN';
  static const typeOrderReturnSignIn = 'REDIRECT_ORDER_RETURN_SIGN_IN';
  static const typeExchangeReturnSignIn = 'REDIRECT_EXCHANGE_RETURN_SIGN_IN';
  static const typeProductRatings = 'REDIRECT_PRODUCT_RATINGS';
  static const typeWishlistScreenFromAccount =
      'REDIRECT_WISHLIST_SCREEN_FROM_ACCOUNT';
  static const typeAddToWishlistFromPlp = 'REDIRECT_ADD_TO_WISHLIST_FROM_PLP';
  static const typeGoToWishlist = 'REDIRECT_GO_TO_WISHLIST';
  static const typeProfileDetails = 'REDIRECT_PROFILE_DETAILS';

  // ── Display messages ─────────────────────────────────────────────────────
  static const redirectCart = 'Sign in to view your cart';
  static const redirectAddToCart = 'Sign in to add this product to your cart';
  static const redirectOrders = 'Sign in to see all your orders';
  static const redirectWishlistScreen =
      'Sign in to view and manage your Wishlist';
  static const redirectAddToWishlist =
      'Sign in to add this item to your wishlist';
  static const redirectReminder = 'Sign in to set a reminder for this boutique';
  static const redirectFav = 'Sign in to ❤️ your favourite brand';
  static const redirectFavBrands = 'Sign in to see your favourite brands';
  static const redirectCards = 'Sign in to see your saved cards';
  static const redirectKids = "Sign in to add or edit your kids' details";
  static const redirectWishlistItem =
      'Sign in to add this product to your wishlist';
  static const redirectWishlist =
      'Sign in to add this product to your wishlist';
  static const redirectMomentLike = 'Sign in to like this Moment';
  static const redirectMomentUpload = 'Sign in to upload your favourite Moment';
  static const redirectRecent = 'Sign in to see your recently viewed items';
  static const redirectVerifyMobile = 'Sign in to verify your mobile';
  static const redirectMomentDislike = 'Sign in to dislike this moment';
  static const redirectAccountSettings =
      'Sign in to update your Account Settings';
  static const redirectProfileImage = 'Sign in to upload your Profile Image';
  static const redirectAddresses = 'Sign in to see your saved addresses';
  static const redirectProductReminder =
      'Sign in to add this product to your reminder';
  static const redirectCredits = 'Sign in to see your account credits';
  static const redirectPromo = 'Sign in to apply promotion code in your cart';
  static const redirectOrderCancel = 'Sign in to cancel an order';
  static const redirectOrderReturn = 'Sign in to return an order';
  static const redirectOrderCancelSignIn =
      'Cancelling items from your order? Just verify your number';
  static const redirectOrderReturnSignIn =
      'Returning items from your order? Just verify your number';
  static const redirectExchangeReturnSignIn =
      'Exchange items from your order? Just verify your number';
  static const redirectProductRatings = 'Sign in to rate the product';
  static const redirectWishlistScreenFromAccount =
      'Sign in to view and manage your Wishlist';
  static const redirectAddToWishlistFromPlp =
      'Sign in to add this item to your Wishlist';
  static const redirectGoToWishlist =
      'Sign in to view and manage your Wishlist';
  static const redirectProfileDetails =
      'Sign in to update your Account Settings';

  static String? lookup(String? key) {
    if (key == null || key.isEmpty) return null;
    return _map[key];
  }

  static const Map<String, String> _map = {
    typeCart: redirectCart,
    typeAddToCart: redirectAddToCart,
    typeOrders: redirectOrders,
    typeWishlistScreen: redirectWishlistScreen,
    typeAddToWishlist: redirectAddToWishlist,
    typeReminder: redirectReminder,
    typeFav: redirectFav,
    typeFavBrands: redirectFavBrands,
    typeCards: redirectCards,
    typeKids: redirectKids,
    typeWishlistItem: redirectWishlistItem,
    typeWishlist: redirectWishlist,
    typeMomentLike: redirectMomentLike,
    typeMomentUpload: redirectMomentUpload,
    typeRecent: redirectRecent,
    typeVerifyMobile: redirectVerifyMobile,
    typeMomentDislike: redirectMomentDislike,
    typeAccountSettings: redirectAccountSettings,
    typeProfileImage: redirectProfileImage,
    typeAddresses: redirectAddresses,
    typeProductReminder: redirectProductReminder,
    typeCredits: redirectCredits,
    typePromo: redirectPromo,
    typeOrderCancel: redirectOrderCancel,
    typeOrderReturn: redirectOrderReturn,
    typeOrderCancelSignIn: redirectOrderCancelSignIn,
    typeOrderReturnSignIn: redirectOrderReturnSignIn,
    typeExchangeReturnSignIn: redirectExchangeReturnSignIn,
    typeProductRatings: redirectProductRatings,
    typeWishlistScreenFromAccount: redirectWishlistScreenFromAccount,
    typeAddToWishlistFromPlp: redirectAddToWishlistFromPlp,
    typeGoToWishlist: redirectGoToWishlist,
    typeProfileDetails: redirectProfileDetails,
  };
}
