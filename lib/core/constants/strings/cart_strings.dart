class CartStrings {
  CartStrings._();

  static const String bag = 'Bag';
  static const String emptyCart = 'Your bag is empty';
  static const String emptyCartSubtitle =
      "Looks like you haven't added anything to your bag yet";
  static const String startShopping = 'START SHOPPING';
  static const String total = 'Total';
  static const String removeFromCart = 'Remove';
  static const String moveToWishlist = 'Move to Wishlist';
  static const String promoCode = 'Promo Code';
  static const String applyPromoCode = 'Apply promo code';
  static const String enterPromoCode = 'Enter promo code';

  // Item panel actions
  static const String changeQuantity = 'Change\nquantity';
  static const String moveToWishlistPanel = 'Move to\nWishlist';
  static const String removeFromBag = 'Remove from\nbag';
  static const String onlyOneItemLeft = 'Only 1 item left';

  // App bar
  static const String enterPincodeForEdd = 'Enter pincode for EDD';
  static const String deliverTo = 'Deliver to';

  // Move to wishlist — mirrors the wording WishlistCubit uses on PLP/PDP,
  // but says "moved" rather than "added": the cart action also drops the line
  // from the bag, which the PLP heart tap does not.
  static const String movedToWishlist = 'Moved to wishlist';
  static const String couldNotMoveToWishlist = "Couldn't move to wishlist";

  // Remove item confirmation sheet
  static const String removeItemsTitle = 'Remove Item(s)';
  static const String removeItemsDescription =
      'Are you sure you want to remove this item from bag?';
  static const String no = 'No';

  // Fallbacks for the server-returned `message` on remove / move-to-wishlist
  // (Android toasts the API message; these cover an empty one).
  static const String itemRemoved = 'Item removed from bag';
  static const String couldNotRemoveItem = "Couldn't remove this item";

  // Checkout bar
  static const String proceedToCheckout = 'Proceed To Checkout';
  static const String details = 'Details';
  static const String youSaved = 'You Saved';
  static const String onThisOrder = 'On This Order';
  static const String item = 'item';
  static const String items = 'items';

  // Cart item card
  static const String qty = 'Qty:';
  static const String size = 'Size:';
  static const String moveToWishlistLabel = 'Move To Wishlist';

  // Promo section
  static const String enterOfferCode = 'Enter An Offer Code';
  static const String applied = 'applied';
  static const String yourSavings = 'Your savings';
  static const String seeAllOffers = 'See All Offers';

  // Quantity selector
  static const String quantityLabel = 'Quantity:';
}
