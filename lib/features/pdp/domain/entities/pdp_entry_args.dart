import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';

part 'pdp_entry_args.freezed.dart';

/// How the user arrived at the PDP. Mirrors the Intent-bundle fields Android
/// reads in `PDPAnalytics.setIntentData` (`PDPAnalytics.kt:51-62`).
///
/// Set once when the route is pushed and **preserved across colour-variant
/// switches** — the funnel that brought the user in still applies to the new
/// PID.
///
/// Two of Android's bundle fields are deliberately absent: `doorwayData` and
/// `redirectedFromShopTheLook`. Neither feature exists in the Flutter PDP
/// so their wire keys are emitted as constants
/// (`redirected_from_doorway: false`, `redirected_from_shop_the_look: "No"`)
/// rather than being carried in.
@freezed
abstract class PdpEntryArgs with _$PdpEntryArgs {
  const factory PdpEntryArgs({
    /// e.g. `FromScreens.plp`, `FromScreens.discover`.
    String? fromScreen,

    /// e.g. `FromPage.recommendation`, `FromPage.recentlyViewed`.
    String? fromPage,

    /// Size of the feed the user came from, or null when the PDP was not opened
    /// from a feed.
    ///
    /// Nullable rather than defaulting to 0: a default of 0 used to be invisible
    /// because the `num <= 0` rule discarded it, and with that rule gone it would
    /// assert "the feed had no items" on every PDP opened outside a feed. Null means
    /// unknown and is dropped; 0 would be a claim.
    int? fromFeedSize,
  }) = _PdpEntryArgs;
}