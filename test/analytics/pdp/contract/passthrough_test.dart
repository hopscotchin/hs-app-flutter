import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/color_variants_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/offer_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/sku_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/tile_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';

import '../../support/analytics_test_harness.dart';
import '../support/node_fixtures.dart';

/// Wire-payload assertions for every in-scope PDP event.
///
/// Driven off the captured staging fixtures, so the expected values are what
/// Android would actually emit for those PIDs. Where a behaviour is a
/// deliberately-reproduced Android bug, the test says so —
/// those assertions are load-bearing: if someone "fixes" the bug, these fail.
ProductDetailEntity _fixture(String name) {
  final raw = File('test/analytics/fixtures/$name').readAsStringSync();
  return ProductDetailModel.fromJson(jsonDecode(raw) as Map<String, dynamic>).toEntity();
}

void main() {
  late AnalyticsTestHarness h;
  late ProductDetailEntity flat; // PID 945499
  late ProductDetailEntity range; // PID 924925

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    flat = _fixture('pdp_product_945499.json');
    range = _fixture('pdp_product_924925_range_price.json');
  });
  tearDown(() => h.tearDown());

  group('product_viewed — base properties', () {
    setUp(() async {
      await h.analytics.logProductViewed(
        product: flat.product!,
        entry: const PdpEntryArgs(),
        offersTrackingMeta: flat.offersTrackingMeta,
      );
    });

    test('fires exactly once', () {
      expect(h.eventsNamed(AnalyticsEvents.productViewed), hasLength(1));
    });

    test('product_id is a STRING, not the numeric id', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.productId], '945499');
      expect(e[AnalyticsProperties.productId], isA<String>());
    });

    test('trackingMeta fields are renamed to their wire keys', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.category], 'Apparel - Children');
      expect(e[AnalyticsProperties.subCategory], 'Sets');
      expect(e[AnalyticsProperties.productType], 'Formal Sets');
      expect(e[AnalyticsProperties.subProductType], 'TestTop');
      expect(e[AnalyticsProperties.brand], 'Whaou');
      expect(e[AnalyticsProperties.gender], "Girl's");
      expect(e[AnalyticsProperties.fromAge], 36);
      expect(e[AnalyticsProperties.toAge], 96);
      expect(e[AnalyticsProperties.deliveryDays], 4);
    });

    test('camelCase source keys never reach the wire', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      for (final leaked in [
        'categoryName',
        'subcategoryName',
        'productTypeName',
        'subProductTypeName',
        'brandName',
        'maxDeliveryDays',
        'isPidAplus',
        'styleCodePidCount',
        'slug',
      ]) {
        expect(e.containsKey(leaked), isFalse, reason: '$leaked leaked');
      }
    });

    test('price is an int, not a double', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.price], 349);
      expect(e[AnalyticsProperties.price], isA<int>());
    });

    test('mrp and discount_percentage arrive as doubles', () {
      // Both now ship in §1. `price` is an Int beside them, which is exactly how the
      // wrong type gets copied — Android's `Price` does not type the three alike.
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.mrp], 449.0);
      expect(e[AnalyticsProperties.mrp], isA<double>());
      expect(e[AnalyticsProperties.discountPercentage], 22.0);
      expect(e[AnalyticsProperties.discountPercentage], isA<double>());
      expect(e[AnalyticsProperties.price], isA<int>());
    });

    test('country_of_origin absent — API gap', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e.containsKey(AnalyticsProperties.countryOfOrigin), isFalse);
    });

    test('sale survives as "No" on v3', () {
      // The old shape was `onSale: 0`, a number the `num <= 0` rule then discarded, so
      // the property vanished for every non-sale product. v3 sends the agreed
      // "Yes"/"No" STRING, which the rule does not touch — so "No" now reaches the
      // wire and "not on sale" is finally distinguishable from "unknown".
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.sale], 'No');
    });

    test('sku is the array trackingMeta sent, forwarded as-is', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      // `List<dynamic>`, not `List<String>`: it is the decoded JSON array, forwarded
      // without a cast. The app no longer rebuilds it from the entity's SKUs.
      expect(e[AnalyticsProperties.sku], isA<List<Object?>>());
      expect(e[AnalyticsProperties.sku], hasLength(5));
      expect((e[AnalyticsProperties.sku] as List).first, 'WHA-3049919');
    });

    test('counts come from the response arrays', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.sizes], 5);
      expect(e[AnalyticsProperties.imageCount], 3);
      expect(e[AnalyticsProperties.name], 'Pink All Over Sleeveless Top');
    });

    test('coupon_applicable comes from the offers block', () {
      // Forwarded by the offers passthrough — nothing reads it by name, so there is
      // no default to invent when it is missing.
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.couponApplicable], 2);
    });

    test('productAttrs become mixed-case wire keys verbatim', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e['HBT'], 'T2');
      expect(e['Season'], 'Autumn Winter');
    });

    test('from_pincode defaults to "standard" when none verified', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.fromPincode], AnalyticsDefaults.standard);
    });

    test('removed features emit NOTHING — no A+ keys', () {
      // The doorway and shop-the-look keys are no longer listed: their
      // constants have been deleted from `AnalyticsProperties`, so there is
      // nothing left that could emit them. The A+ constants still exist, so
      // asserting they stay off the payload still guards something.
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      for (final removed in [
        AnalyticsProperties.isPidAplus,
        AnalyticsProperties.aPlusUspList,
        AnalyticsProperties.aPlusVirtualGroupName,
        AnalyticsProperties.aPlusContentType,
      ]) {
        expect(e.containsKey(removed), isFalse, reason: '$removed should be gone');
      }
    });

    test('tab-page keys are no longer emitted — the block was retired', () {
      // Tab-page attribution used to be app-owned entry context. It is not sent
      // from any surface today; the corresponding fields are gone from
      // `PdpEntryArgs` and the wire keys reach Segment only if the backend node
      // ships them.
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e.containsKey(AnalyticsProperties.tabbedPageContainerId), isFalse);
      expect(e.containsKey(AnalyticsProperties.tabbedPageContainerName), isFalse);
      expect(e.containsKey(AnalyticsProperties.tabName), isFalse);
      expect(e.containsKey(AnalyticsProperties.tabPosition), isFalse);
    });
  });

  group('product_viewed — entry context', () {
    test('entry args map onto their wire keys', () async {
      await h.analytics.logProductViewed(
        product: flat.product!,
        entry: const PdpEntryArgs(
          fromScreen: FromScreens.plp,
          fromPage: FromPage.recommendation,
          fromFeedSize: 40,
        ),
      );
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.fromScreen], FromScreens.plp);
      expect(e[AnalyticsProperties.fromPage], FromPage.recommendation);
      expect(e[AnalyticsProperties.fromFeedSize], 40);
      expect(
        e[AnalyticsProperties.fromPincode],
        'standard',
        reason:
            'from_pincode arrives on product.trackingMeta now — the endpoint '
            'echoes back the pincode the request was made with, so the client '
            'no longer passes it in',
      );
    });

    test('position / source_tile_type / tab_* are node-owned now', () async {
      // These used to be entry-arg fields. They were removed from
      // `PdpEntryArgs`; any value on the wire has to arrive on
      // `product.trackingMeta` (or a chained node) rather than the client.
      await h.analytics.logProductViewed(product: flat.product!, entry: const PdpEntryArgs());
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      for (final clientOwnedInPrev in const [
        AnalyticsProperties.tabbedPageContainerName,
        AnalyticsProperties.tabbedPageContainerId,
        AnalyticsProperties.tabName,
        AnalyticsProperties.tabPosition,
      ]) {
        expect(
          e.containsKey(clientOwnedInPrev),
          isFalse,
          reason: '$clientOwnedInPrev must not appear from the client any more',
        );
      }
    });

    test('an absent from_feed_size is omitted, not sent as 0', () async {
      // Nullable rather than defaulted so absence stays distinguishable from
      // "the feed had 0 items". Under the retired `<=0` rule the two collapsed.
      await h.analytics.logProductViewed(product: flat.product!, entry: const PdpEntryArgs());
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e.containsKey(AnalyticsProperties.fromFeedSize), isFalse);
    });

    test('coupon_applicable 0 is reported, not dropped', () async {
      // The drop rules discard null and empties, never a zero — so "no coupons
      // apply" stays distinguishable from "the block did not carry it".
      await h.analytics.logProductViewed(
        product: flat.product!,
        entry: const PdpEntryArgs(),
        offersTrackingMeta: const {'coupon_applicable': 0},
      );
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.couponApplicable], 0);
    });
  });

  group('colour / style block', () {
    test('count_of_pids_in_style_code is a STRING', () async {
      await h.analytics.logBuyNowClicked(product: flat.product!, selectedSku: null);
      final e = h.singleEvent(AnalyticsEvents.buyNowClickedAlt);
      expect(e[AnalyticsProperties.styleCode], 'udf1');
      expect(e[AnalyticsProperties.styleCodePidCount], '9');
      expect(e[AnalyticsProperties.styleCodePidCount], isA<String>());
    });

    test('count "0" IS sent while style_code is absent', () async {
      // PID 924925: styleCodePidCount 0, no styleCode. The stringify happens
      // before the drop check, so "0" survives where numeric 0 would not.
      await h.analytics.logBuyNowClicked(product: range.product!, selectedSku: null);
      final e = h.singleEvent(AnalyticsEvents.buyNowClickedAlt);
      expect(e[AnalyticsProperties.styleCodePidCount], '0');
      expect(e.containsKey(AnalyticsProperties.styleCode), isFalse);
    });

    test('redirected_from_colour_widget comes from the journey node', () async {
      // BE owns both the answer and the vocabulary: the response says "Yes" or
      // "No" in product.orderAttribution, so the client neither decides nor
      // formats it. Absent node means the key is absent, not "false".
      final withJourney = flat.product!.copyWith(
        orderAttribution: const {'redirected_from_colour_widget': 'Yes'},
      );
      await h.analytics.logBuyNowClicked(product: withJourney, selectedSku: null);
      final e = h.singleEvent(AnalyticsEvents.buyNowClickedAlt);
      expect(e[AnalyticsProperties.redirectedFromColorWidget], 'Yes');
      expect(e[AnalyticsProperties.redirectedFromColorWidget], isA<String>());
    });
  });

  group('interaction events', () {
    test('size_selected carries sku + sku_size + from_location', () async {
      final sku = flat.product!.skus[1];
      await h.analytics.logSizeSelected(
        product: flat.product!,
        fromLocation: FromLocations.sizeListUpfront,
        sku: sku,
      );
      final e = h.singleEvent(AnalyticsEvents.sizeSelected);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.sizeListUpfront);
      expect(e[AnalyticsProperties.sku], 'WHA-3049920');
      expect(e[AnalyticsProperties.skuSize], '4-5 Y');
    });

    test('pincode_change maps serviceable → success / failure', () async {
      await h.analytics.logPincodeChange(product: flat.product!, serviceable: true);
      expect(
        h.singleEvent(AnalyticsEvents.pincodeChange)[AnalyticsProperties.pincodeCheckStatus],
        AnalyticsDefaults.success,
      );

      h.clear();
      await h.analytics.logPincodeChange(product: flat.product!, serviceable: false);
      expect(
        h.singleEvent(AnalyticsEvents.pincodeChange)[AnalyticsProperties.pincodeCheckStatus],
        AnalyticsDefaults.failure,
      );
    });

    test('coupon_code_clicked carries cta + code', () async {
      await h.analytics.logCouponCodeClicked(
        product: flat.product!,
        callToAction: AnalyticsDefaults.couponCodeCopied,
        offer: const OfferEntity(couponCode: 'TEST450', trackingMeta: {'coupon_code': 'TEST450'}),
      );
      final e = h.singleEvent(AnalyticsEvents.couponCodeClicked);
      expect(e[AnalyticsProperties.callToAction], AnalyticsDefaults.couponCodeCopied);
      expect(e[AnalyticsProperties.couponCode], 'TEST450');
    });

    test('product_details_tab_clicked carries the tab name', () async {
      await h.analytics.logProductDetailsTabClicked(
        product: flat.product!,
        tab: const DetailEntity(
          tabName: 'Specification',
          trackingMeta: {'tab_name': 'Specification'},
        ),
      );
      expect(
        h.singleEvent(AnalyticsEvents.productDetailsTabClicked)[AnalyticsProperties.tabName],
        'Specification',
      );
    });

    test('pdp_images_scrolled adds the initial image back via +1', () async {
      await h.analytics.logPdpImagesScrolled(product: flat.product!, uniqueImagesScrolled: 2);
      final e = h.singleEvent(AnalyticsEvents.pdpImagesScrolled);
      // The carousel reports settled pages only, which excludes the initial
      // one. Settling on 2 further images means 3 distinct images were seen.
      expect(e[AnalyticsProperties.uniqueImagesScrolled], 3);
    });

    test('recently_viewed_products_scrolled sends scroll_depth even at 0', () async {
      await h.analytics.logRecentlyViewedProductsScrolled(
        product: flat.product!,
        scrollDepth: 0,
        railTrackingMeta: const {'feed_size': 10},
      );
      final e = h.singleEvent(AnalyticsEvents.recentlyViewedProductsScrolled);
      expect(e[AnalyticsProperties.feedSize], 10);
      // Raw put — unlike other numerics, 0 survives.
      expect(e[AnalyticsProperties.scrollDepth], 0);
    });

    test('product_added_to_cart carries pdt_size', () async {
      await h.analytics.logProductAddedToCart(
        product: flat.product!,
        entry: const PdpEntryArgs(),
        selectedSku: flat.product!.skus.first,
      );
      final e = h.singleEvent(AnalyticsEvents.productAddedToCart);
      expect(e[AnalyticsProperties.productSize], '3-4 Y');
    });

    test('buy_now_clicked uses the components-module event name', () async {
      await h.analytics.logBuyNowClicked(product: flat.product!, selectedSku: null);
      expect(h.hasEvent('buy_now_clicked'), isTrue);
      expect(h.hasEvent('buynow_clicked'), isFalse);
    });

    test('new_color_selected carries the incoming pid as a String', () async {
      await h.analytics.logNewColorSelected(
        product: flat.product!,
        variant: const ColorVariantEntity(
          productId: 906575,
          trackingMeta: {'new_product_id_selected': '906575'},
        ),
      );
      final e = h.singleEvent(AnalyticsEvents.newColorSelected);
      expect(e[AnalyticsProperties.newProductIdSelected], '906575');
      expect(e['HBT'], 'T2');
    });
  });

  group('clicked-product properties', () {
    const clicked = ListingProductEntity(
      id: 943726,
      name: 'Multi D-Stripes lace Top And Short Set',
      trackingMeta: {
        'widgetPosition': 0,
        'category_name': 'Apparel - Children',
        'subcategory_name': 'Sets',
        'product_type_name': 'Pant set',
      },
    );

    test('reco_product_clicked renames the tapped tile meta', () async {
      await h.analytics.logRecoProductClicked(
        product: flat.product!,
        tile: TileEntity(product: clicked, trackingMeta: tileClickMeta(clicked)),
      );
      final e = h.singleEvent(AnalyticsEvents.recoProductClicked);
      expect(e[AnalyticsProperties.clickedProductPid], '943726');
      expect(e[AnalyticsProperties.clickedCategory], 'Apparel - Children');
      expect(e[AnalyticsProperties.clickedSubcategory], 'Sets');
      expect(e[AnalyticsProperties.clickedProductType], 'Pant set');
    });

    test('the tapped tile meta is renamed, never spread', () async {
      await h.analytics.logRecoProductClicked(
        product: flat.product!,
        tile: TileEntity(product: clicked, trackingMeta: tileClickMeta(clicked)),
      );
      final e = h.singleEvent(AnalyticsEvents.recoProductClicked);
      // Spreading would put camelCase keys on the wire and clobber the page
      // product's own `category`.
      expect(e.containsKey('categoryName'), isFalse);
      expect(e.containsKey('widgetPosition'), isFalse);
      expect(e[AnalyticsProperties.category], 'Apparel - Children');
    });

    test('a tile with no trackingMeta contributes nothing (B5)', () async {
      // Under passthrough the whole click block lives on the tile node, so a
      // tile without one drops all four keys rather than three — there is no
      // per-key fallback left to salvage the pid.
      await h.analytics.logRecentlyViewedProductsClicked(
        product: flat.product!,
        tile: const TileEntity(product: ListingProductEntity(id: 1, name: 'x')),
      );
      final e = h.singleEvent(AnalyticsEvents.recentlyViewedProductsClicked);
      expect(e.containsKey(AnalyticsProperties.clickedProductPid), isFalse);
      expect(e.containsKey(AnalyticsProperties.clickedCategory), isFalse);
      expect(e.containsKey(AnalyticsProperties.clickedSubcategory), isFalse);
      expect(e.containsKey(AnalyticsProperties.clickedProductType), isFalse);
    });
  });

  group('the fixture\'s keys all reach the wire', () {
    // Every value below comes from `trackingMeta` under its own name — there is no
    // rename table left to break. What these still catch is a key silently dropping
    // out of the payload, or falling into an event-scoping set it does not belong in.
    setUp(() async {
      await h.analytics.logProductViewed(
        product: flat.product!,
        entry: const PdpEntryArgs(),
        offersTrackingMeta: flat.offersTrackingMeta,
      );
    });

    test('the 9 taxonomy and age keys are emitted', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.category], 'Apparel - Children');
      expect(e[AnalyticsProperties.subCategory], 'Sets');
      expect(e[AnalyticsProperties.productType], 'Formal Sets');
      expect(e[AnalyticsProperties.subProductType], 'TestTop');
      expect(e[AnalyticsProperties.brand], 'Whaou');
      expect(e[AnalyticsProperties.gender], "Girl's");
      expect(e[AnalyticsProperties.fromAge], 36);
      expect(e[AnalyticsProperties.toAge], 96);
      // countryOfOrigin is the 9th — absent from the API, so absent for
      // Android too. Not a Flutter gap.
      expect(e.containsKey(AnalyticsProperties.countryOfOrigin), isFalse);
    });

    test('event-scoped keys reach product_viewed', () {
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e[AnalyticsProperties.deliveryDays], 4);
      expect(e[AnalyticsProperties.styleCode], 'udf1');
      expect(e[AnalyticsProperties.styleCodePidCount], '9');
      expect(e[AnalyticsProperties.productId], '945499');
      expect(e[AnalyticsProperties.price], 349);
      expect(e[AnalyticsProperties.sizes], 5);
      expect(e[AnalyticsProperties.couponApplicable], 2);
      expect(e['HBT'], 'T2');
      expect(e['Season'], 'Autumn Winter');
    });

    test('the only absent product key is one the API never sends', () {
      // `country_of_origin` is per-product data that is genuinely unknown for many
      // products, so §1 omits it — and Android reads the same field, so both
      // platforms omit it identically. Absence here is meaningful, not a gap.
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      expect(e.containsKey(AnalyticsProperties.countryOfOrigin), isFalse);
    });
  });

  group('the base map cannot override an event-specific key', () {
    // Merge order still differs per event — `product_viewed` merges the base map
    // AFTER its own keys, `product_added_to_cart` merges it FIRST — and the
    // module documents each one. But the order is no longer *observable* for any
    // key an event writes, because the only channel the backend has into the base
    // map is passthrough, and passthrough skips every key in `_appOwnedWireKeys`.
    //
    // That is the guarantee worth pinning: a backend key can add a dimension but
    // never silently replace a computed one. Without the `_appOwnedWireKeys`
    // filter it could, in whichever direction the event happened to merge.
    // `sale` is deliberately absent from this list: it IS a server value, read by
    // name at the `product_viewed` call site so that it reaches that event alone —
    // see the test below.
    //
    // `name`, `price`, `product_id`, `image_url`, `image_count`, `sizes` and `sku`
    // are absent for the same reason, and that reason grew: every analytics value
    // now comes FROM `trackingMeta`, so a server value for them is not an override
    // to defend against — it is the source. They stay in `_appOwnedWireKeys` only so
    // passthrough does not write them a second time.
    // The old guard held `pdt_size` and `sku_size` back from the server block so a
    // backend value could not overwrite a computed one. Nothing computes them any
    // more — both come from the sku node — so the rule that matters is precedence:
    // a deeper node wins over the product node, and nothing else can.
    test('the sku node wins over the same key on the product node', () async {
      final product = flat.product!.copyWith(
        trackingMeta: {
          ...flat.product!.trackingMeta!,
          'pdt_size': 'FROM PRODUCT NODE',
          'sku_size': 'FROM PRODUCT NODE',
        },
      );
      await h.analytics.logSizeSelected(
        product: product,
        sku: flat.product!.skus.first,
        fromLocation: 'Size list upfront',
      );
      final e = h.singleEvent(AnalyticsEvents.sizeSelected);
      expect(e['pdt_size'], isNot('FROM PRODUCT NODE'));
      expect(e['sku_size'], isNot('FROM PRODUCT NODE'));
    });

    test('with no sku node, the product node value is forwarded', () async {
      // Not a defect: passthrough forwards what BE sends. The spec asks BE to put
      // size keys on the sku node, and this is what happens if it does not.
      final product = flat.product!.copyWith(
        trackingMeta: {...flat.product!.trackingMeta!, 'pdt_size': 'FROM BE'},
      );
      await h.analytics.logProductShareClicked(product);
      expect(h.singleEvent(AnalyticsEvents.productShareClicked)['pdt_size'], 'FROM BE');
    });
  });

  group('passthrough channel', () {
    test('a new product-node key reaches every event, not just product_viewed', () async {
      // The zero-release channel widened. It used to be scoped to product_viewed,
      // so a backend dimension could only ever describe the page view; the product
      // node now rides all 23 events, which is what makes a tap event describable
      // by a key nobody has declared.
      final product = flat.product!.copyWith(
        trackingMeta: {...flat.product!.trackingMeta!, 'a_new_key': 'value'},
      );
      await h.analytics.logProductViewed(product: product, entry: const PdpEntryArgs());
      expect(h.singleEvent(AnalyticsEvents.productViewed)['a_new_key'], 'value');
      h.clear();
      await h.analytics.logProductShareClicked(product);
      expect(h.singleEvent(AnalyticsEvents.productShareClicked)['a_new_key'], 'value');
    });
  });

  group('every event carries the base block', () {
    test('base keys present on a representative sample', () async {
      final product = flat.product!;
      const entry = PdpEntryArgs();
      await h.analytics.logProductShareClicked(product);
      await h.analytics.logSizeChartClicked(product);
      await h.analytics.logProductDetailsExpanded(product);
      await h.analytics.logProductDetailsCollapsed(product);
      await h.analytics.logPincodeFormOpened(product);
      await h.analytics.logCouponCodeScrolled(product: product);
      await h.analytics.logRecoViewed(product: product, railTrackingMeta: const {'feed_size': 10});
      await h.analytics.logRecentlyViewedProductsLoaded(
        product: product,
        railTrackingMeta: const {'feed_size': 4},
      );
      await h.analytics.logProductAddedToCart(
        product: product,
        entry: entry,
        selectedSku: product.skus.first,
      );

      expect(h.captured, hasLength(9));
      for (final captured in h.captured) {
        expect(
          captured.props[AnalyticsProperties.productId],
          '945499',
          reason: '${captured.name} is missing product_id',
        );
        expect(
          captured.props[AnalyticsProperties.category],
          'Apparel - Children',
          reason: '${captured.name} is missing category',
        );
      }
    });

    test('no event ships a null-valued property', () async {
      await h.analytics.logProductViewed(product: range.product!, entry: const PdpEntryArgs());
      final e = h.singleEvent(AnalyticsEvents.productViewed);
      final nulls = e.entries.where((x) => x.value == null).map((x) => x.key);
      expect(nulls, isEmpty, reason: 'null-valued keys poison dashboards');
    });
  });

  group('price numerics match Android type-for-type', () {
    /// The three price keys come from **differently typed** Android fields, so
    /// they must not share a numeric treatment
    /// (`common/.../model/carousel/Price.kt:9-13`):
    ///
    /// | Wire key | Android source | Android type |
    /// |---|---|---|
    /// | `price` | `Price.absoluteValue` — `Int?` | `Int` → `349` |
    /// | `mrp` | `Price.mrp` — `String?` via `toNumericDouble()` | `Double` → `449.0` |
    /// | `discount_percentage` | `Price.discount` — same | `Double` → `22.0` |
    ///
    /// Collapsing all three with `analyticsNumber` is the obvious tidy-up and is
    /// wrong: it emits `449` where Android emits `449.0`. Invisible today because
    /// the API sends neither key — this pins it before it ships.
    /// Injects price keys into `trackingMeta`, which is the only source the app
    /// reads. `priceInfo` is left alone deliberately — a value there must NOT
    /// reach the wire, which the last test in this group pins.
    Future<Map<String, Object?>> emitWithPrice(Map<String, dynamic> priceKeys) async {
      final harness = await AnalyticsTestHarness.build();
      final raw =
          jsonDecode(File('test/analytics/fixtures/pdp_product_945499.json').readAsStringSync())
              as Map<String, dynamic>;
      final product = raw['product'] as Map<String, dynamic>;
      product['trackingMeta'] = {...product['trackingMeta'] as Map<String, dynamic>, ...priceKeys};
      final detail = ProductDetailModel.fromJson(raw).toEntity();
      await harness.analytics.logProductViewed(
        product: detail.product!,
        entry: const PdpEntryArgs(),
      );
      final props = harness.captured.single.props;
      harness.tearDown();
      return props;
    }

    test('price is int; mrp and discount_percentage are double', () async {
      final props = await emitWithPrice({'price': 349, 'mrp': 449.0, 'discount_percentage': 22.0});
      expect(props['price'], 349);
      expect(props['price'], isA<int>(), reason: 'Price.absoluteValue is Int?');
      expect(props['mrp'], 449.0);
      expect(
        props['mrp'],
        isA<double>(),
        reason:
            'Android parses Price.mrp with toNumericDouble() → Double. '
            'Emitting int 449 here would not match 449.0 on the wire.',
      );
      expect(props['discount_percentage'], 22.0);
      expect(props['discount_percentage'], isA<double>());
    });

    test('a non-integral mrp keeps its fraction', () async {
      final props = await emitWithPrice({'price': 349, 'mrp': 449.5});
      expect(props['mrp'], 449.5);
    });

    test('whatever trackingMeta sends is what reaches the wire', () async {
      // The app applies no coercion and no parsing: the value goes out as sent. The
      // spec asks BE for JSON numbers, so a decorated string here is a WIRE
      // regression that will show up in the dashboard as a string-typed property —
      // visible, rather than silently repaired by the client.
      final props = await emitWithPrice({'price': 349, 'mrp': '₹449'});
      expect(props['mrp'], '₹449');
      expect(props['mrp'], isA<String>());
      expect(props['price'], 349);
    });

    test('priceInfo is no longer a source', () async {
      // trackingMeta is the only source. A price that exists ONLY on `priceInfo`
      // must not reach the wire — otherwise the two could disagree silently, with
      // the entity winning for products whose block 1 is incomplete.
      final harness = await AnalyticsTestHarness.build();
      final raw =
          jsonDecode(File('test/analytics/fixtures/pdp_product_945499.json').readAsStringSync())
              as Map<String, dynamic>;
      final product = raw['product'] as Map<String, dynamic>;
      final meta = Map<String, dynamic>.from(product['trackingMeta'] as Map<String, dynamic>)
        ..remove('price')
        ..remove('mrp')
        ..remove('discount_percentage');
      product['trackingMeta'] = meta;
      product['priceInfo'] = {'sellingPrice': '₹349', 'absoluteValue': 349.0, 'mrp': '₹449'};
      final detail = ProductDetailModel.fromJson(raw).toEntity();
      await harness.analytics.logProductViewed(
        product: detail.product!,
        entry: const PdpEntryArgs(),
      );
      final props = harness.captured.single.props;
      harness.tearDown();

      expect(props.containsKey('price'), isFalse);
      expect(props.containsKey('mrp'), isFalse);
    });
  });

  group('sku_size comes from the per-SKU block, and only from there', () {
    Future<Object?> sizeFor(SkuEntity sku) async {
      h.clear();
      await h.analytics.logSizeSelected(
        product: flat.product!,
        fromLocation: FromLocations.addToCartButton,
        sku: sku,
      );
      return h.singleEvent(AnalyticsEvents.sizeSelected)[AnalyticsProperties.skuSize];
    }

    test('forwarded from trackingMeta', () async {
      expect(
        await sizeFor(const SkuEntity(skuId: 'X', trackingMeta: {'sku_size': '4-5 Y'})),
        '4-5 Y',
      );
    });

    test('no entity fallback — title and skuAttributes are not read', () async {
      // Both held the same value in practice, which is exactly why reading them was
      // easy to miss: two sources that agree until one day they do not. BE owns the
      // size label, so a block without the key drops the property rather than
      // substituting a rendering field.
      expect(
        await sizeFor(
          const SkuEntity(
            skuId: 'X',
            title: 'FallbackTitle',
            skuAttributes: {'skuSize': 'FromAttrs'},
          ),
        ),
        isNull,
      );
    });
  });
}
