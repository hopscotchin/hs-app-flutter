import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../components/atoms/empty_state_widget.dart';
import '../../../../../components/atoms/error_retry_widget.dart';
import '../../../../../core/entities/backend_action_entity.dart';
import '../../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../../core/constants/strings/orders_strings.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../domain/entities/common/empty_state_entity.dart';
import '../../../domain/entities/listing/order_listing_record_entity.dart';
import '../../../domain/entities/orders_tab.dart';
import '../../shared/widgets/orders_support_footer.dart';
import '../bloc/orders_listing_bloc.dart';
import 'notification_nudge_card.dart';
import 'order_listing_card.dart';
import 'orders_shimmer_loading.dart';

/// One tab's body. Both tabs use this; only the data differs.
///
/// Reads its own slice of the shared bloc with a [BlocSelector] keyed on [tab],
/// so a change on one tab does not rebuild the other.
class OrdersTabView extends StatelessWidget {
  const OrdersTabView({
    super.key,
    required this.tab,
    required this.onRecordTap,
    required this.onNudgeAccept,
    required this.onNudgeDecline,
    required this.onSupportAction,
    required this.onEmptyStateCta,
  });

  final OrdersTab tab;
  final void Function(String actionUri) onRecordTap;
  final VoidCallback onNudgeAccept;
  final VoidCallback onNudgeDecline;
  final ValueChanged<BackendActionType> onSupportAction;
  final void Function(String actionUrl) onEmptyStateCta;

  /// Fraction of the scroll extent at which the next page is requested. Early
  /// enough that the rows are usually there before the user reaches them.
  static const double _paginationTrigger = 0.8;

  String get _prefix => tab == OrdersTab.orders
      ? OrdersTestStrings.ordersTab
      : OrdersTestStrings.giftCardsTab;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrdersListingBloc, OrdersListingState, TabListingState>(
      selector: (state) => state.forTab(tab),
      builder: (context, tabState) {
        if (tabState.isLoading) {
          return OrdersShimmerLoading(
            key: ValueKey(
              '${_prefix}_${OrdersTestStrings.shimmerLoadingSuffix}',
            ),
          );
        }

        if (tabState.isError) {
          return ErrorRetryWidget(
            message: tabState.errorMessage ?? OrdersStrings.genericError,
            retryButtonKey: ValueKey(
              '${_prefix}_${OrdersTestStrings.errorRetryButtonSuffix}',
            ),
            onRetry: () => context.read<OrdersListingBloc>().add(
              OrdersListingEvent.load(tab),
            ),
          );
        }

        // Nothing has been requested yet — the Gift Cards tab before its first
        // visit. Blank rather than an empty state, which would claim the user
        // has no gift cards.
        if (tabState.isUntouched) return const SizedBox.shrink();

        return RefreshIndicator(
          key: ValueKey(
            '${_prefix}_${OrdersTestStrings.refreshIndicatorSuffix}',
          ),
          onRefresh: () => _refresh(context),
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) => _onScroll(context, n, tabState),
            child: CustomScrollView(
              // Always scrollable so the pull gesture registers even when the
              // content is shorter than the viewport — which the empty tab is.
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: tabState.isEmpty
                  ? [_emptySliver(tabState)]
                  : _contentSlivers(context, tabState),
            ),
          ),
        );
      },
    );
  }

  /// Completes when the refresh round-trip does.
  ///
  /// A silent refresh deliberately changes no status flag — the list stays put
  /// — so there is nothing to poll. `refreshTick` is bumped on success and on
  /// failure alike, which is what lets the spinner run for the real duration
  /// instead of vanishing on the next frame.
  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<OrdersListingBloc>();
    final before = bloc.state.forTab(tab).refreshTick;
    bloc.add(OrdersListingEvent.refresh(tab));
    await bloc.stream.firstWhere((s) => s.forTab(tab).refreshTick != before);
  }

  bool _onScroll(
    BuildContext context,
    ScrollNotification notification,
    TabListingState tabState,
  ) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical || metrics.maxScrollExtent <= 0) {
      return false;
    }
    if (metrics.pixels >= metrics.maxScrollExtent * _paginationTrigger) {
      if (tabState.hasNextPage && !tabState.isLoadingMore) {
        context.read<OrdersListingBloc>().add(
          OrdersListingEvent.loadNextPage(tab),
        );
      }
    }
    return false; // never swallow the notification
  }

  List<Widget> _contentSlivers(BuildContext context, TabListingState tabState) {
    final page = tabState.page;
    final nudge = page?.notificationNudge;
    final support = page?.support;
    final records = tabState.records;

    return [
      // Both tabs carry the nudge; only Orders carries the support footer. No
      // tab check either way — each renders if the response has the block.
      if (nudge != null) ...[
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        SliverToBoxAdapter(
          child: NotificationNudgeCard(
            nudge: nudge,
            onAccept: onNudgeAccept,
            onDecline: onNudgeDecline,
          ),
        ),
      ],

      SliverPadding(
        // Cards carry half the 12pt gap each, so 6 here puts the first card
        // 12 below the nudge (or the tabs) — the spec's page-column gap.
        padding: const EdgeInsets.only(top: AppSpacing.sm / 2),
        sliver: SliverList.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return OrderListingCard(
              key: ValueKey(record.stableKey),
              record: record,
              tabPrefix: _prefix,
              index: index,
              onTap: () => onRecordTap(record.actionUri!),
            );
          },
        ),
      ),

      if (tabState.isLoadingMore)
        SliverToBoxAdapter(
          child: Padding(
            key: ValueKey(
              '${_prefix}_${OrdersTestStrings.loadMoreIndicatorSuffix}',
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),

      if (support != null)
        SliverToBoxAdapter(
          child: OrdersSupportFooter(
            support: support,
            onAction: onSupportAction,
          ),
        ),
    ];
  }

  /// The server owns this copy. Android bundles it in the APK and the server
  /// sends it for Gift Cards only, which is why the Orders tab has always shown
  /// hard-coded text — nothing is bundled here, so an absent block renders
  /// nothing rather than silently substituting.
  Widget _emptySliver(TabListingState tabState) {
    final empty = tabState.page?.emptyState;
    if (empty == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final lines = empty.lines;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyStateWidget(
        title: lines.isNotEmpty ? lines.first : '',
        subtitle: lines.length > 1 ? lines.sublist(1).join('\n') : '',
        titleKey: ValueKey(
          '${_prefix}_${OrdersTestStrings.emptyStateTitleSuffix}',
        ),
        buttonKey: ValueKey(
          '${_prefix}_${OrdersTestStrings.emptyStateButtonSuffix}',
        ),
        // A CTA needs both halves to be usable. Android falls back to "go
        // home" when either is missing; without that fallback a partial CTA
        // would render a dead button, so it is better to render none.
        buttonLabel: empty.hasUsableCta ? empty.ctaAction!.label : '',
        onButtonTap: empty.hasUsableCta
            ? () => onEmptyStateCta(empty.ctaAction!.actionUri!)
            : null,
      ),
    );
  }
}
