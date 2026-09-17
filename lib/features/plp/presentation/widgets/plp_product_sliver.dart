import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/product_tile.dart';
import 'package:hs_app_flutter/core/analytics/analytics_payload_builder.dart';

import '../../../../components/atoms/xl_tile_widget.dart';
import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/plp_events.dart';
import '../../../../core/analytics/events/modules/wishlist_events.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/login_redirects.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/spacing.dart';
import '../../../auth/domain/entities/auth_entry_args.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/wishlist_actions.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/plp_list_item.dart';
import '../bloc/plp_bloc.dart';
import 'floating_filter_row.dart';

class PlpProductSliver extends StatelessWidget {
  final Key? sliverKey;

  const PlpProductSliver({super.key, this.sliverKey});

  /// Main tap key for the product at flat index [i] → `plp_tile_<i>`.
  Key _tileKey(int i) => ValueKey('${PlpTestStrings.tile}_$i');

  /// Wishlist key nested under the tile → `plp_tile_<i>_wishlist`.
  Key _wishlistKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.wishlistSuffix}');

  /// Visual-cue key nested under the tile → `plp_tile_<i>_visual_cue_<j>`.
  Key _visualCueKey(int i, int j) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.visualCueSuffix}_$j');

  /// Info-section keys nested under the tile.
  Key _nameKey(int i) => ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.nameSuffix}');
  Key _priceKey(int i) => ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.priceSuffix}');
  Key _discountKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.discountSuffix}');
  Key _colorVariantsKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.colorVariantsSuffix}');

  Widget _buildProductRow(
    BuildContext context,
    ListingProductEntity left,
    ListingProductEntity? right,
    int startIndex,
  ) {
    final hasCPT = left.isCPT || right?.isCPT == true;
    final row = Row(
      crossAxisAlignment: hasCPT ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
      children: [
        Expanded(child: _tile(context, left, hasCPT, startIndex)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: right == null
              ? const SizedBox.shrink()
              : _tile(context, right, hasCPT, startIndex + 1),
        ),
      ],
    );
    return hasCPT ? IntrinsicHeight(child: row) : row;
  }

  Widget _tile(BuildContext context, ListingProductEntity product, bool hasCPT, int index) {
    final id = product.id.toString();
    return BlocSelector<WishlistCubit, WishlistState, bool>(
      selector: (s) => s.isWishlisted(id),
      builder: (context, wished) => ProductTile.fromProduct(
        product,
        hasCPT: hasCPT,
        isWishlisted: wished,
        tileKey: _tileKey(index),
        wishlistKey: _wishlistKey(index),
        visualCueKeyBuilder: (j) => _visualCueKey(index, j),
        nameKey: _nameKey(index),
        priceKey: _priceKey(index),
        discountKey: _discountKey(index),
        colorVariantsKey: _colorVariantsKey(index),
        onTap: () {
          // Attribution write must land before nav — the destination reads it
          // during its own build. Synchronous, never awaited.
          final plpState = context.read<PlpBloc>().state;
          sl<AnalyticsHelper>().logPlpTileClicked(
            trackingMeta: product.trackingMeta,
            pageMeta: plpState.orderAttribution,
          );
          if (product.isCPT) {
            ActionUrlHandler.navigate(
              context,
              product.actionUri,
              title: product.name,
              // A CPT can point at another listing; without this the
              // destination PLP reports no from_screen / from_location and
              // looks like a deeplink open.
              extra: navExtra(plpEntryArgs: plpState.plpEntryArgs(index)),
            );
          } else {
            // Entry context, or PDP loses from_screen / from_page /
            // from_feed_size / position on all 22 of its events. Read at tap
            // time so a listing that paged in since build reports the new size.
            AppNavigator.goToPdp(context, id, args: plpState.pdpEntryArgs);
          }
        },
        onWishlistTap: () => _toggleWishlist(context, product),
      ),
    );
  }

  /// The PLP heart. Android fires `product_added_to_wishlist` /
  /// `product_removed_from_wishlist` here with `from_location: "Wishlist
  /// button"` and `from_screen` = the listing's own name
  /// (`PLPAnalytics.logProductAddedToWishList:440`,
  /// `logProductRemovedFromWishlist:489`) — the PLP was passing neither
  /// callback, so `WishlistActions` emitted nothing and both events were
  /// missing from this surface entirely.
  ///
  /// The callbacks fire only on server confirmation, and survive the
  /// logged-out login detour, so the add that eventually happens is the one
  /// that reports.
  void _toggleWishlist(BuildContext context, ListingProductEntity product) {
    // Read now, not in the callback: after a login detour this widget may be
    // gone, and the bloc is what owns the page identity.
    final plp = context.read<PlpBloc>().state;

    WishlistActions.toggle(
      context,
      productId: product.id.toString(),
      price: WishlistActions.priceToInt(product.price?.sellingPrice),
      // The product's own blob carries every dimension the payload needs —
      // brand, category, subcategory, product_type, merch_type,
      // source_tile_type — so it is spread rather than enumerated here.
      onAdded: () => sl<AnalyticsHelper>().logProductAddedToWishlist(
        productId: product.id.toString(),
        fromScreen: plp.plpFromScreen,
        trackingMeta: buildAnalyticsPayload(nodes: [product.trackingMeta, plp.orderAttribution]),
        skuTrackingMeta: product.wishlistInfo.trackingMeta,
      ),
      onRemoved: () => sl<AnalyticsHelper>().logProductRemovedFromWishlist(
        productId: product.id.toString(),
        fromScreen: plp.plpFromScreen,
        trackingMeta: buildAnalyticsPayload(nodes: [product.trackingMeta, plp.orderAttribution]),
        skuTrackingMeta: product.wishlistInfo.trackingMeta,
      ),
      entry: const AuthEntryArgs(
        fromScreen: FromScreens.plp,
        fromLocation: FromLocations.wishlistButton,
      ),
      loggedOutMessageBars: const [
        MessageBarEntity(text: LoginRedirects.redirectAddToWishlist, type: 'info', hasIcon: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, (List<PlpListItem>, Map<String, String>)>(
      selector: (state) => (state.listItems, state.appliedFilters),
      builder: (context, plp) {
        final listItems = plp.$1;
        final appliedFilters = plp.$2;
        // Flat product index per list item — rows contribute 1-2 products, XL
        // one, floating filters none. Precomputed once so per-tile keys stay
        // stable (`plp_tile_<i>`) without an O(n²) scan in the item builder.
        final productStarts = <int>[];
        var running = 0;
        for (final it in listItems) {
          productStarts.add(running);
          running += switch (it) {
            ProductRowItem(:final right) => right == null ? 1 : 2,
            ProductXLItem() => 1,
            _ => 0,
          };
        }
        return SliverList(
          key: sliverKey,
          delegate: SliverChildBuilderDelegate(addSemanticIndexes: false, (context, index) {
            final item = listItems[index];
            final productStart = productStarts[index];
            return Padding(
              padding: EdgeInsets.only(top: index == 0 && appliedFilters.isNotEmpty ? 0 : 8),
              child: switch (item) {
                ProductRowItem(:final left, :final right) => Padding(
                  key: ValueKey('row_${left.id}'),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    AppSpacing.xs,
                    AppSpacing.sm,
                    AppSpacing.xs,
                  ),

                  child: _buildProductRow(context, left, right, productStart),
                ),
                ProductXLItem(:final product) => Padding(
                  key: ValueKey('xl_${product.id}'),
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xs,
                    bottom: 0,
                    right: 12,
                    left: 12,
                  ),
                  child: BlocSelector<WishlistCubit, WishlistState, bool>(
                    selector: (s) => s.isWishlisted(product.id.toString()),
                    builder: (context, wished) => XLTileWidget.fromListingProduct(
                      product,
                      isWishlisted: wished,
                      tileKey: _tileKey(productStart),
                      wishlistKey: _wishlistKey(productStart),
                      visualCueKeyBuilder: (j) => _visualCueKey(productStart, j),
                      nameKey: _nameKey(productStart),
                      priceKey: _priceKey(productStart),
                      discountKey: _discountKey(productStart),
                      colorVariantsKey: _colorVariantsKey(productStart),
                      onTap: () {
                        final plp = context.read<PlpBloc>().state;
                        sl<AnalyticsHelper>().logPlpTileClicked(
                          trackingMeta: product.trackingMeta,
                          pageMeta: plp.orderAttribution,
                        );
                        AppNavigator.goToPdp(
                          context,
                          product.id.toString(),
                          args: plp.pdpEntryArgs,
                        );
                      },
                      onWishlistTap: () => _toggleWishlist(context, product),
                      onAddToCartTap: () {},
                      // Carries the full listing-viewed property set plus the
                      // swipe — Android reuses addCommonProductListProperties()
                      // wholesale here, so the page blob goes with it, not the
                      // product's.
                      onImageScrolled: (cardIndex, direction) =>
                          sl<AnalyticsHelper>().logXlProductCardScrolled(
                            trackingMeta: context.read<PlpBloc>().state.plpAnalyticsMeta,
                            cardIndex: cardIndex,
                            swipeDirection: direction,
                          ),
                    ),
                  ),
                ),
                FloatingFilterItem(:final section) => FloatingFilterRow(
                  key: ValueKey('floating_${section.position}_${section.title}'),
                  section: section,
                  onFiltersApplied: (key, value) =>
                      context.read<PlpBloc>().add(ApplyFloatingFilter(key: key, value: value)),
                ),
              },
            );
          }, childCount: listItems.length),
        );
      },
    );
  }
}
