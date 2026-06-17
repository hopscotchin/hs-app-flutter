import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/atoms/empty_state_widget.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_applied_filters.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_filter_header.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_product_sliver.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_query_correction.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/helpers/plp_query_builder.dart';
import '../bloc/plp_bloc.dart';
import '../widgets/plp_shimmer_loading.dart';
import '../widgets/plp_sliver_app_bar.dart';

class PlpPage extends StatelessWidget {
  final PageType pageType;
  final int plpId;
  final String? categoryName;
  final String? searchQuery;
  final String? rawSearchParams;

  const PlpPage({
    super.key,
    required this.pageType,
    required this.plpId,
    this.categoryName,
    this.searchQuery,
    this.rawSearchParams,
  });

  Map<String, dynamic> get _baseQueryParams {
    final params = <String, dynamic>{'pageNo': 1, 'pageSize': PlpQueryBuilder.pageSize};
    switch (pageType) {
      case PageType.plp:
        params['id'] = plpId;
        break;
      case PageType.boutique:
        params['salePlanId'] = plpId;
        params['filterQuery'] = 'salePlanId=$plpId';
        break;
      case PageType.search:
        if (rawSearchParams != null) {
          params['searchParams'] = base64Encode(utf8.encode(rawSearchParams!));
        } else if (searchQuery != null) {
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
            rawSearchParams: rawSearchParams,
          ),
        ),
      child: _PlpView(
        categoryName: categoryName,
        searchQuery: searchQuery,
        rawSearchParams: rawSearchParams,
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
  final String? rawSearchParams;
  final PageType pageType;
  final int plpId;
  final Map<String, dynamic> baseQueryParams;

  const _PlpView({
    this.categoryName,
    this.searchQuery,
    this.rawSearchParams,
    required this.pageType,
    required this.plpId,
    required this.baseQueryParams,
  });

  @override
  State<_PlpView> createState() => _PlpViewState();
}

class _PlpViewState extends State<_PlpView> {
  static const double _showAfterOffset = 300;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  String get _title => widget.categoryName ?? widget.searchQuery ?? '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _showScrollToTop.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final shouldShow = _scrollController.position.pixels > _showAfterOffset;
    if (_showScrollToTop.value != shouldShow) {
      _showScrollToTop.value = shouldShow;
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _resetScroll() {
    _showScrollToTop.value = false;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTop,
        builder: (context, show, _) => show
            ? AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: show ? 1.0 : 0.0,
                child: GestureDetector(
                  onTap: _scrollToTop,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: AppColors.brandPrimary, width: 1.5),
                    ),
                    child: Transform.rotate(
                      angle: 90 * math.pi / 180,
                      child: const CustomImage(
                        path: ImageConstants.arrowBack,
                        color: AppColors.brandPrimary,
                        height: 14,
                        width: 14,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PlpBloc, PlpState>(
            listenWhen: (prev, curr) => prev.wishlistFeedbackTick != curr.wishlistFeedbackTick,
            listener: (context, state) {
              // removed snackbar for whishlist if needed we can add it later

              // final msg = state.wishlistFeedbackMessage;
              // if (msg == null || msg.isEmpty) return;
              // context.showSnack(
              //   msg,
              //   status: state.wishlistFeedbackIsError ? SnackStatus.error : SnackStatus.success,
              // );
            },
          ),
          BlocListener<PlpBloc, PlpState>(
            listenWhen: (prev, curr) => curr.status == PlpStatus.loading,
            listener: (context, state) => _resetScroll(),
          ),
        ],
        child: BlocBuilder<PlpBloc, PlpState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            final hasFilters = state.appliedFilters.isNotEmpty;
            return SafeArea(
              top: widget.pageType != PageType.boutique || state.banners.isEmpty,
              bottom: false,
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScroll,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    PlpSliverAppBar(pageType: widget.pageType, title: _title),
                    ...switch (state.status) {
                      PlpStatus.initial ||
                      PlpStatus.loading => const [SliverFillRemaining(child: PlpShimmerLoading())],
                      PlpStatus.error => [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: EmptyStateWidget(
                              type: EmptyStateType.serverError,
                              onButtonTap: () => _retry(context),
                            ),
                          ),
                        ),
                      ],
                      PlpStatus.empty => [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: EmptyStateWidget(
                              type: EmptyStateType.plp,
                              subtitle: hasFilters
                                  ? PlpStrings.noProductsFiltered
                                  : PlpStrings.tryAgainAndKeepExploring,
                              onButtonTap: hasFilters
                                  ? () => context.read<PlpBloc>().add(const ClearAllFilters())
                                  : () => _retry(context),
                            ),
                          ),
                        ),
                      ],
                      PlpStatus.loaded => [
                        // SliverToBoxAdapter(
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 16),
                        //     child: MessageBarsWidget(
                        //       messageBars: state.messageBars,
                        //       cardStyle: true,
                        //       onAction: (v, MessageBarEntity s) {},
                        //     ),
                        //   ),
                        // ),
                        PlpFilterHeader(baseQueryParams: widget.baseQueryParams),
                        const PlpAppliedFilters(),
                        PlpQueryCorrectionSliver(pageType: widget.pageType, plpId: widget.plpId),
                        const PlpProductSliver(),
                        BlocSelector<PlpBloc, PlpState, bool>(
                          selector: (s) => s.isLoadingMore,
                          builder: (context, isLoading) => isLoading
                              ? const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(AppSpacing.md),
                                    child: Center(
                                      child: SizedBox(
                                        width: AppSpacing.lg,
                                        height: AppSpacing.lg,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                )
                              : const SliverToBoxAdapter(child: SizedBox.shrink()),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                      ],
                    },
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.axis == Axis.vertical &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
      final state = context.read<PlpBloc>().state;
      if (state.status == PlpStatus.loaded && state.hasMore && !state.isLoadingMore) {
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
        rawSearchParams: widget.rawSearchParams,
      ),
    );
  }
}
