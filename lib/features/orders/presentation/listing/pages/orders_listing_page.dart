import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../../core/analytics/events/analytics_helper.dart';
import '../../../../../core/analytics/events/modules/lifecycle_events.dart';

import '../../../../../components/atoms/custom_image.dart';
import '../../../../../core/constants/image_constants.dart';
import '../../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../../core/constants/strings/orders_strings.dart';
import '../../../../../core/entities/backend_action_entity.dart';
import '../../../../../core/navigation/action_url_handler.dart';
import '../../../../../core/navigation/help_center_launcher.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../../core/theme/typography/typography_v1.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../domain/entities/orders_tab.dart';
import '../bloc/orders_listing_bloc.dart';
import '../widgets/orders_tab_view.dart';

/// The Orders screen: two tabs over one bloc.
///
/// Holds no `BlocProvider` — the route owns it, which is what forces the
/// one-bloc-two-tabs shape. The page's job is the chrome (app bar, tab bar),
/// routing user intent into events, and running the side effects a bloc must
/// not: navigation, the dialer, the pagination snackbar.
class OrdersListingPage extends StatefulWidget {
  const OrdersListingPage({
    super.key,
    required this.analytics,
    this.customerCareNumber,
  });

  /// Resolved by the route. Passed in rather than looked up here, because
  /// widgets do not reach into the service locator.
  final AnalyticsHelper analytics;

  /// The dialer number from app config — the support footer's `callUs` button
  /// is app-level, not a property of any order.
  final String? customerCareNumber;

  @override
  State<OrdersListingPage> createState() => _OrdersListingPageState();
}

class _OrdersListingPageState extends State<OrdersListingPage>
    with SingleTickerProviderStateMixin {
  static const List<OrdersTab> _tabs = [OrdersTab.orders, OrdersTab.giftCards];

  /// The design's arrow is a 2.4px lucide stroke, which Material's
  /// `arrow_back` glyph does not match at any size — hence the shared asset.
  ///
  /// Two different numbers, both from the spec. The CSS gives the icon a 32×32
  /// box with the vector inset 20.83%, so the drawn glyph is 18.7. The asset is
  /// a 22×22 viewBox whose glyph spans 1.2→19.87 — also 18.7, same 2.4 stroke.
  /// It is the same lucide arrow with a tighter box, so it renders at its
  /// natural 22 inside the design's 32 slot. Drawing it at 32 would scale the
  /// glyph to 27.
  static const double _backArrowBox = 32;

  /// The tab strip's own height, and the hairline above it. Both feed the
  /// PreferredSize the two share.
  static const double _tabBarHeight = 48;
  static const double _hairline = 1;
  static const double _backArrowGlyph = 22;

  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tabs.length, vsync: this)
      ..addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  /// Fires once per settled change, not on every frame of the swipe.
  ///
  /// The bloc loads the tab on its first visit and re-fires the view event on
  /// later ones, so a tab the user never opens never costs a request.
  void _onTabChanged() {
    if (_controller.indexIsChanging) return;
    context.read<OrdersListingBloc>().add(
      OrdersListingEvent.switchTab(_tabs[_controller.index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          key: const ValueKey(OrdersTestStrings.appBarBackButton),
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).maybePop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SizedBox(
              width: _backArrowBox,
              height: _backArrowBox,
              child: Center(
                child: CustomImage(
                  path: ImageConstants.arrowBack,
                  width: _backArrowGlyph,
                  height: _backArrowGlyph,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        // 16 padding + 32 arrow + 16 padding. With titleSpacing 0 the title
        // then begins exactly 16 after the arrow — the spec's gap.
        leadingWidth: AppSpacing.md + _backArrowBox + AppSpacing.md,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          OrdersStrings.screenTitle,
          key: const ValueKey(OrdersTestStrings.appBarTitle),
          style: AppTypographyV1.titleMedium.bold.copyWith(
            color: AppColors.neutralBlack,
            height: 27 / 20,
          ),
        ),
        // A hairline under the title row, the same treatment cart's app bar
        // uses. It cannot be its own `bottom:` — the TabBar already occupies
        // that slot — so the two share one PreferredSize, divider first.
        //
        // Distinct from the TabBar's own divider below it: this one separates
        // the header from the tabs, matching the design's
        // `border-bottom: 1px rgba(0,0,0,0.05)` on the header frame.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(_tabBarHeight + _hairline),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                height: _hairline,
                thickness: _hairline,
                color: AppColors.neutralGrey1,
              ),
              _tabBar(),
            ],
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          for (final tab in _tabs) _paginationErrorListener(tab),
          _nudgeShownListener(),
        ],
        child: TabBarView(
          controller: _controller,
          children: [
            for (final tab in _tabs)
              OrdersTabView(
                tab: tab,
                onRecordTap: (uri) => ActionUrlHandler.navigate(context, uri),
                onNudgeAccept: _onNudgeAccept,
                onNudgeDecline: _onNudgeDecline,
                onSupportAction: _onSupportAction,
                onEmptyStateCta: (url) =>
                    ActionUrlHandler.navigate(context, url),
              ),
          ],
        ),
      ),
    );
  }

  /// Selected tab: 14/700 in brand purple over a 2px indicator. Unselected:
  /// 14/400 grey over the 1px hairline the divider draws across both.
  Widget _tabBar() {
    return TabBar(
      controller: _controller,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.neutralGrey6,
      indicatorColor: AppColors.primary,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
      // The unselected tab keeps a 1px hairline under it; the selected one
      // is overdrawn by the 2px indicator.
      dividerColor: const Color(0x33000000),
      dividerHeight: 1,
      labelStyle: AppTypographyV1.bodyRegular.bold.copyWith(height: 19 / 14),
      unselectedLabelStyle: AppTypographyV1.bodyRegular.regular.copyWith(
        height: 19 / 14,
      ),
      tabs: const [
        Tab(
          key: ValueKey(OrdersTestStrings.tabOrders),
          text: OrdersStrings.tabOrders,
        ),
        Tab(
          key: ValueKey(OrdersTestStrings.tabGiftCards),
          text: OrdersStrings.tabGiftCards,
        ),
      ],
    );
  }

  /// Surfaces a failed page-append without disturbing the list.
  ///
  /// `listenWhen` compares against the previous state rather than testing for
  /// non-null: the clear event is queued and lands an event-loop turn later, so
  /// until then any unrelated emission still carries the message and a plain
  /// non-null test would show the snackbar twice.
  BlocListener<OrdersListingBloc, OrdersListingState> _paginationErrorListener(
    OrdersTab tab,
  ) {
    return BlocListener<OrdersListingBloc, OrdersListingState>(
      listenWhen: (prev, curr) {
        final before = prev.forTab(tab).paginationError;
        final now = curr.forTab(tab).paginationError;
        return now != null && now != before;
      },
      listener: (context, state) {
        final prefix = tab == OrdersTab.orders
            ? OrdersTestStrings.ordersTab
            : OrdersTestStrings.giftCardsTab;
        context.showSnack(
          state.forTab(tab).paginationError!,
          status: SnackStatus.error,
          key: ValueKey(
            '${prefix}_${OrdersTestStrings.paginationErrorSnackBarSuffix}',
          ),
        );
        context.read<OrdersListingBloc>().add(
          OrdersListingEvent.clearPaginationError(tab),
        );
      },
    );
  }

  /// Fires `notification_permission_intent_shown` the first time the nudge
  /// appears, and only then.
  ///
  /// Driven off the state transition rather than the card's `build`, which
  /// would re-fire on every rebuild — a scroll would inflate the count.
  BlocListener<OrdersListingBloc, OrdersListingState> _nudgeShownListener() {
    return BlocListener<OrdersListingBloc, OrdersListingState>(
      listenWhen: (prev, curr) =>
          prev.orders.page?.notificationNudge == null &&
          curr.orders.page?.notificationNudge != null,
      listener: (_, _) => _onNudgeShown(),
    );
  }

  // ── Nudge ───────────────────────────────────────────────────────────────
  //
  // The three notification-permission events were already defined in
  // lifecycle_events.dart but fired from nowhere; Orders is their first site.
  // All three report `from_screen: 'Order listing'`.

  /// The card was rendered, so the user has been asked.
  ///
  /// Fired from `initState` of the tab that shows it rather than from the
  /// card's `build`, which would re-fire on every rebuild.
  void _onNudgeShown() => widget.analytics.logNotificationPermissionIntentShown(
    fromScreen: FromScreens.orderListing,
  );

  /// "Yes, Please" — hand off to the OS prompt and report what it returned.
  ///
  /// The accepted/rejected pair reflects the **system** dialog's outcome, not
  /// the tap: a user can accept here and then decline the OS prompt, and the
  /// dashboard should see the decline.
  Future<void> _onNudgeAccept() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (granted) {
      await widget.analytics.logNotificationPermissionAccepted(
        fromScreen: FromScreens.orderListing,
      );
    } else {
      await widget.analytics.logNotificationPermissionRejected(
        fromScreen: FromScreens.orderListing,
      );
    }
  }

  /// "No" — declined without the OS ever being asked.
  void _onNudgeDecline() => widget.analytics.logNotificationPermissionRejected(
    fromScreen: FromScreens.orderListing,
  );

  // ── Support footer ──────────────────────────────────────────────────────

  /// The buttons name a behaviour, not a destination — the dialer number and
  /// the help-centre URL are app-level, not properties of any order.
  void _onSupportAction(BackendActionType type) {
    switch (type) {
      case BackendActionType.callUs:
        final number = widget.customerCareNumber;
        if (number == null || number.isEmpty) return;
        // `tel:` is not a scheme ActionUrlHandler routes, so it goes straight
        // out to the platform.
        ExternalDestination(url: 'tel:$number').navigate(context);
      case BackendActionType.helpCenter:
        HelpCenterLauncher.openHelpCenter(context);
      default:
        // The footer filters unknown types out before this can be reached; a
        // behaviour it knows but this switch does not is a no-op rather than a
        // crash.
        break;
    }
  }
}
