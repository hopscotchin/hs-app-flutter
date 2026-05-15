import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/page_type.dart';
import '../bloc/plp_bloc.dart';
import '../widgets/plp_applied_filters.dart';
import '../widgets/plp_empty_state.dart';
import '../widgets/plp_filter_header.dart';
import '../widgets/plp_product_sliver.dart';
import '../widgets/plp_scroll_indicator.dart';
import '../widgets/plp_shimmer_loading.dart';
import '../widgets/plp_sliver_app_bar.dart';

class PlpPage extends StatelessWidget {
  final PageType pageType;
  final int plpId;
  final String? categoryName;
  final String? searchQuery;

  const PlpPage({
    super.key,
    required this.pageType,
    required this.plpId,
    this.categoryName,
    this.searchQuery,
  });

  Map<String, dynamic> get _baseQueryParams {
    final params = <String, dynamic>{};
    switch (pageType) {
      case PageType.plp:
        params['id'] = plpId;
        break;
      case PageType.boutique:
        params['salePlanId'] = plpId;
        params['filterQuery'] = 'salePlanId=$plpId';
        break;
      case PageType.search:
        if (searchQuery != null) {
          params['keyword'] = searchQuery;
        }
        break;
    }
    return params;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlpBloc>()
        ..add(
          LoadPlpData(
            pageType: pageType,
            plpId: plpId,
            searchQuery: searchQuery,
            categoryName: categoryName,
          ),
        ),
      child: _PlpView(
        categoryName: categoryName,
        searchQuery: searchQuery,
        pageType: pageType,
        plpId: plpId,
        baseQueryParams: _baseQueryParams,
      ),
    );
  }
}

class _PlpView extends StatefulWidget {
  final String? categoryName;
  final String? searchQuery;
  final PageType pageType;
  final int plpId;
  final Map<String, dynamic> baseQueryParams;

  const _PlpView({
    this.categoryName,
    this.searchQuery,
    required this.pageType,
    required this.plpId,
    required this.baseQueryParams,
  });

  @override
  State<_PlpView> createState() => _PlpViewState();
}

class _PlpViewState extends State<_PlpView> {
  final ScrollController _scrollController = ScrollController();

  String get _title => widget.categoryName ?? widget.searchQuery ?? '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: BlocBuilder<PlpBloc, PlpState>(
        // Rebuild the outer shell only when the status changes (initial→loading→loaded etc.).
        // Data updates within PlpStatus.loaded are handled by inner BlocSelectors.
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, state) {
          return switch (state.status) {
            PlpStatus.initial || PlpStatus.loading => _buildLoadingState(),
            PlpStatus.error => _buildErrorState(context, state),
            PlpStatus.empty => _buildEmptyState(context, state),
            PlpStatus.loaded => _buildLoadedState(context),
          };
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const CustomScrollView(
      slivers: [SliverFillRemaining(child: PlpShimmerLoading())],
    );
  }

  Widget _buildErrorState(BuildContext context, PlpState state) {
    return CustomScrollView(
      slivers: [
        PlpSliverAppBar(pageType: widget.pageType, title: _title),
        SliverFillRemaining(
          child: ErrorRetryWidget(
            message: state.errorMessage ?? 'Something went wrong',
            onRetry: () => _retry(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, PlpState state) {
    final hasFilters = state.appliedFilters.isNotEmpty;
    return CustomScrollView(
      slivers: [
        PlpSliverAppBar(pageType: widget.pageType, title: _title),
        SliverFillRemaining(
          child: PlpEmptyState(
            hasFilters: hasFilters,
            onClearFilters: hasFilters
                ? () => context.read<PlpBloc>().add(const ClearAllFilters())
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _handleScroll,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              PlpSliverAppBar(pageType: widget.pageType, title: _title),
              PlpFilterHeader(baseQueryParams: widget.baseQueryParams),
              const PlpAppliedFilters(),
              const PlpProductSliver(),
              // Loading-more indicator — only rebuilds when isLoadingMore toggles
              BlocSelector<PlpBloc, PlpState, bool>(
                selector: (state) => state.isLoadingMore,
                builder: (context, isLoading) => isLoading
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
            ],
          ),
        ),
        PlpScrollIndicator(scrollController: _scrollController),
      ],
    );
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.axis == Axis.vertical &&
        notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
      final state = context.read<PlpBloc>().state;
      if (state.status == PlpStatus.loaded &&
          state.hasMore &&
          !state.isLoadingMore) {
        context.read<PlpBloc>().add(const LoadMorePlpData());
      }
    }
    return false;
  }

  void _retry(BuildContext context) {
    context.read<PlpBloc>().add(
      LoadPlpData(
        pageType: widget.pageType,
        plpId: widget.plpId,
        categoryName: widget.categoryName,
        searchQuery: widget.searchQuery,
      ),
    );
  }
}
