import 'package:freezed_annotation/freezed_annotation.dart';

part 'plp_entry_args.freezed.dart';

/// How the user arrived at the PLP. The Flutter equivalent of the Intent
/// extras Android reads in `PLPAnalytics.setIntentData`
/// (`PLPAnalytics.kt:108-123`) — `IntentHelper.FROM_SCREEN`,
/// `FROM_LOCATION`, `FROM_SECTION`, `POSITION`, `ROW`, `FROM_FEED_SIZE`,
/// `ADD_FROM_DETAILS`.
///
/// Every field here is **client-owned**: it describes the hop that opened this
/// screen, which the backend's `trackingMeta` blob cannot know. Attribution
/// does not cover it either — attribution is persisted funnel state with no
/// notion of "this navigation", so a PLP opened from a Discover tile and the
/// same PLP opened from Categories are indistinguishable without these.
///
/// Android sets the pair from the tile that was tapped
/// (`TileAction.parseAction`, `CollectionsAdapter.kt:681`):
/// `from_screen` = the page the tile lived on (`"Discover"`, a landing-page
/// name), `from_location` = the control type (`"Custom tile"`,
/// `"Custom product tile"`, `"Search box"`, …).
///
/// Consumed by `logListingViewed` (and, through the shared builder,
/// `xl_product_card_scrolled`). Values reach the wire through
/// `putAnalyticsKey`, so a null or empty field is simply absent — there is no
/// placeholder to send.
@freezed
abstract class PlpEntryArgs with _$PlpEntryArgs {
  const factory PlpEntryArgs({
    /// The screen the user came from — e.g. `FromScreens.discover`,
    /// `FromScreens.categories`, or a landing-page name.
    String? fromScreen,

    /// The control that was tapped — e.g. `FromLocations.customTile`,
    /// `FromLocations.categoryTile`, `FromLocations.searchBox`.
    String? fromLocation,

    /// Tile position in the originating list. Null when there was no tile.
    ///
    /// Nullable rather than defaulting to 0, and that matters more than it
    /// looks: this codebase keeps zeros on the wire (see `AnalyticsMap`), so a
    /// 0 default would not be quietly swallowed — it would ship, claiming the
    /// tile sat at position zero. Null is dropped; 0 is a claim.
    int? position,

    /// Row index of the originating component.
    int? row,

    /// Size of the feed the user came from. Null means unknown; 0 would be a
    /// claim that the feed was empty.
    int? fromFeedSize,

    /// Free-form navigation detail Android threads through as
    /// `ADD_FROM_DETAILS` (tile action metadata).
    String? addFromDetails,

    /// 1-indexed rank of the tapped autocomplete suggestion. Android sets it
    /// as `IntentHelper.SUGGESTION_INDEX = position + 1`
    /// (`SearchAutocompleteActivity.kt:256`) and PLPAnalytics emits it in the
    /// search branch only.
    int? suggestionIndex,

    /// The query the search was executed with. Android's search branch emits
    /// it as `keyword`, plus its character count as `length`
    /// (`PLPAnalytics.kt:876-877`) — both client-owned, because the backend
    /// blob reports the *resolved* search parameters rather than what the user
    /// actually typed.
    String? keyword,

    /// The autocomplete suggestion's own `trackingData`, merged wholesale into
    /// the search payload (`PLPAnalytics.kt:838-840`). Server-shaped, so it is
    /// spread untouched and loses to any explicit client value on collision.
    Map<String, dynamic>? suggestionTrackingData,
  }) = _PlpEntryArgs;
}
