abstract final class LoginRedirects {
  static const redirectCart = 'Sign in to view your cart';
  static const redirectAddToCart = 'Sign in to add this product to your cart';
  static const redirectOrders = 'Sign in to see all your orders';
  static const redirectWishlistScreen = 'Sign in to view and manage your Wishlist';
  static const redirectAddToWishlist = 'Sign in to add this item to your wishlist';
  static const redirectReminder = 'Sign in to set a reminder for this boutique';
  static const redirectFav = 'Sign in to ❤️ your favourite brand';
  static const redirectFavBrands = 'Sign in to see your favourite brands';
  static const redirectCards = 'Sign in to see your saved cards';
  static const redirectKids = "Sign in to add or edit your kids' details";
  static const redirectWishlistItem = 'Sign in to add this product to your wishlist';
  static const redirectWishlist = 'Sign in to add this product to your wishlist';
  static const redirectMomentLike = 'Sign in to like this Moment';
  static const redirectMomentUpload = 'Sign in to upload your favourite Moment';
  static const redirectRecent = 'Sign in to see your recently viewed items';
  static const redirectVerifyMobile = 'Sign in to verify your mobile';
  static const redirectMomentDislike = 'Sign in to dislike this moment';
  static const redirectAccountSettings = 'Sign in to update your Account Settings';
  static const redirectProfileImage = 'Sign in to upload your Profile Image';
  static const redirectAddresses = 'Sign in to see your saved addresses';
  static const redirectProductReminder = 'Sign in to add this product to your reminder';
  static const redirectCredits = 'Sign in to see your account credits';
  static const redirectPromo = 'Sign in to apply promotion code in your cart';
  static const redirectOrderCancel = 'Sign in to cancel an order';
  static const redirectOrderReturn = 'Sign in to return an order';
  static const redirectOrderCancelSignIn = 'Cancelling items from your order? Just verify your number';
  static const redirectOrderReturnSignIn = 'Returning items from your order? Just verify your number';
  static const redirectExchangeReturnSignIn = 'Exchange items from your order? Just verify your number';
  static const redirectProductRatings = 'Sign in to rate the product';
  static const redirectWishlistScreenFromAccount = 'Sign in to view and manage your Wishlist';
  static const redirectAddToWishlistFromPlp = 'Sign in to add this item to your Wishlist';
  static const redirectGoToWishlist = 'Sign in to view and manage your Wishlist';
  static const redirectProfileDetails = 'Sign in to update your Account Settings';

  static String? lookup(String? key) {
    if (key == null || key.isEmpty) return null;
    return _map[key];
  }

  static const Map<String, String> _map = {
    'REDIRECT_CART': redirectCart,
    'REDIRECT_ADD_TO_CART': redirectAddToCart,
    'REDIRECT_ORDERS': redirectOrders,
    'REDIRECT_WISHLIST_SCREEN': redirectWishlistScreen,
    'REDIRECT_ADD_TO_WISHLIST': redirectAddToWishlist,
    'REDIRECT_REMINDER': redirectReminder,
    'REDIRECT_FAV': redirectFav,
    'REDIRECT_FAV_BRANDS': redirectFavBrands,
    'REDIRECT_CARDS': redirectCards,
    'REDIRECT_KIDS': redirectKids,
    'REDIRECT_WISHLIST_ITEM': redirectWishlistItem,
    'REDIRECT_WISHLIST': redirectWishlist,
    'REDIRECT_MOMENT_LIKE': redirectMomentLike,
    'REDIRECT_MOMENT_UPLOAD': redirectMomentUpload,
    'REDIRECT_RECENT': redirectRecent,
    'REDIRECT_VERIFY_MOBILE': redirectVerifyMobile,
    'REDIRECT_MOMENT_DISLIKE': redirectMomentDislike,
    'REDIRECT_ACCOUNT_SETTINGS': redirectAccountSettings,
    'REDIRECT_PROFILE_IMAGE': redirectProfileImage,
    'REDIRECT_ADDRESSES': redirectAddresses,
    'REDIRECT_PRODUCT_REMINDER': redirectProductReminder,
    'REDIRECT_CREDITS': redirectCredits,
    'REDIRECT_PROMO': redirectPromo,
    'REDIRECT_ORDER_CANCEL': redirectOrderCancel,
    'REDIRECT_ORDER_RETURN': redirectOrderReturn,
    'REDIRECT_ORDER_CANCEL_SIGN_IN': redirectOrderCancelSignIn,
    'REDIRECT_ORDER_RETURN_SIGN_IN': redirectOrderReturnSignIn,
    'REDIRECT_EXCHANGE_RETURN_SIGN_IN': redirectExchangeReturnSignIn,
    'REDIRECT_PRODUCT_RATINGS': redirectProductRatings,
    'REDIRECT_WISHLIST_SCREEN_FROM_ACCOUNT': redirectWishlistScreenFromAccount,
    'REDIRECT_ADD_TO_WISHLIST_FROM_PLP': redirectAddToWishlistFromPlp,
    'REDIRECT_GO_TO_WISHLIST': redirectGoToWishlist,
    'REDIRECT_PROFILE_DETAILS': redirectProfileDetails,
  };
}
