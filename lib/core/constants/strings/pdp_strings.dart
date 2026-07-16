import '../../theme/spacing.dart';

class PdpStrings {
  PdpStrings._();

  // Image carousel — matches Android's default ImageConfig.productAspectRatio (5:7 portrait).
  static const double imageAspectRatio = 5 / 7;

  // App bar — vertical padding around its content. Shared between
  // PdpAppBar's own Padding and PdpContent's sheet-maxSize calculation so the
  // two never drift out of sync when this value changes.
  static const double appBarVerticalPadding = AppSpacing.lgMd;

  // Collapsed sheet's overlap into the bottom of the carousel — shared
  // between PdpContent's peek-height calculation and PdpImageCarousel's
  // visual cue badge position so both agree on the sheet's collapsed
  // geometry. Mirrors Android's SheetAnimationHandler IMAGE_OFFSET.
  static const double sheetCarouselOverlap = 16.0;

  // Visual cue badge — vertical gap kept above the collapsed bottom sheet's
  // top edge.
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

  // Delivery info
  static const String deliveryAvailability = 'Delivery Availability';
  static const String enterPincode = 'Enter Pincode';
  static const String check = 'Check';
  static const String change = 'Change';
  // Contextual delivery-date prompts (mirror Android EddInfoView.getMessage3).
  static const String selectPincodeAndSize =
      'Select pincode and size to get the exact delivery date';
  static const String enterPincodeForDelivery = 'Enter pincode to get accurate delivery date';
  static const String selectSizeForDelivery = 'Select size to get the exact delivery date';

  // Offers
  static const String offersAndDiscounts = 'Offers & Discounts';
  static const String copy = 'Copy';

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
  static const String productMovedSubtitle = "But there's plenty more to discover.";
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
