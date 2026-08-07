import '../../theme/spacing.dart';

class PdpStrings {
  PdpStrings._();

  // Image carousel — matches Android's default ImageConfig.productAspectRatio (5:7 portrait).
  static const double imageAspectRatio = 5 / 7;

  // App bar — vertical padding around the back button, which is the tallest
  // item in the row and therefore what sets the bar's height.
  static const double appBarVerticalPadding = AppSpacing.lgMd;

  // The app bar's content height within its SafeArea: the back button's
  // padding ×2 plus its icon. Derived from the two values it actually depends
  // on, and shared with PdpContent (which uses it as the scroll offset at
  // which the bar turns white) so the two can't drift apart.
  static const double appBarHeight = appBarVerticalPadding * 2 + AppSpacing.lmd;

  // How far the content sheet overlaps the bottom of the carousel — shared
  // between PdpContent's sheet-lip position and PdpImageCarousel's visual cue
  // badge so both agree where the content's top edge sits. Mirrors Android's
  // SheetAnimationHandler IMAGE_OFFSET.
  static const double sheetCarouselOverlap = 16.0;

  // Visual cue badge — vertical gap kept above the content sheet's top edge.
  static const double visualCueBottomGap = 24.0;

  static const String addToCart = 'ADD TO CART';
  static const String addToWishlist = 'Add to Wishlist';
  static const String selectSize = 'Select Size';
  static const String checkDelivery = 'Check Delivery';
  static const String soldOut = 'SOLD OUT';
  static const String outOfStock = 'Out of Stock';

  // Add to bag bar — fixed height of the floating Buy Now / Go to Bag bar.
  // Shared so overlays (snackbars, scroll-to-top pill) can offset above it
  // without drifting out of sync with the bar's actual rendered height.
  static const double addToBagBarHeight = 60.0;

  static const String buyNow = 'Buy Now';
  static const String addToBag = 'Add To Bag';
  static const String goToBag = 'Go To Bag';
  // Shown on the fly-to-cart animation overlay while the product image holds.
  static const String addedToBag = 'Added to bag';

  // Delivery info
  static const String deliveryAvailability = 'Delivery Availability';
  static const String enterPincode = 'Enter Pincode';
  static const String check = 'Check';
  static const String change = 'Change';
  // Contextual delivery-date prompts (mirror Android EddInfoView.getMessage3).
  static const String selectPincodeAndSize =
      'Select pincode and size to get the exact delivery date';
  static const String enterPincodeForDelivery =
      'Enter pincode to get accurate delivery date';
  static const String selectSizeForDelivery =
      'Select size to get the exact delivery date';

  // Offers
  static const String offersAndDiscounts = 'Offers & Discounts';
  static const String copy = 'Copy';
  // Prefix of the coupon copy confirmation; the copied code is appended after a
  // colon, per the couponCode-Snackbars design ("Coupon Code Copied: OFF90").
  static const String couponCodeCopied = 'Coupon Code Copied';

  // Product details
  static const String productDetails = 'Product Details';

  // Size selector
  static const String sizeChart = 'Size Chart';

  // Scroll to top
  static const String goToTop = 'Go to top';

  // Recommended products
  static const String productsYouMayLike = 'Products You May Like';

  // Error / page
  static const String exploreOurCollection = 'EXPLORE OUR COLLECTION';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String productMovedTitle = 'Looks Like This Product Moved';
  static const String productMovedSubtitle =
      "But there's plenty more to discover.";
  static const String exploreNow = 'Explore Now';

  // Share
  static const String shareProductTitle = 'Share with…';

  /// Subject line surfaced by share targets that support one (e.g. email).
  static const String shareProductSubject = "You'll love this!";

  /// Body of the product share, matching the native Android PDP share text.
  ///
  ///   Check out this `<name>` I found on Hopscotch.
  ///   `<url>`
  static String shareProductMessage(String productName, String url) =>
      'Check out this $productName I found on Hopscotch.\n$url';
}
