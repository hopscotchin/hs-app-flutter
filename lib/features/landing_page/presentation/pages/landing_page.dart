import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../../../discover/presentation/widgets/page_component_renderer.dart';
import '../bloc/landing_page_bloc.dart';

class LandingPage extends StatefulWidget {
  final String pageName;
  final String? title;

  const LandingPage({super.key, required this.pageName, this.title});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Tight threshold: only fire after the user has scrolled through the
  // current batch of components (pageSize=20). The bloc's hasNextPage guard
  // makes this a no-op once the server signals there's nothing more.
  static const double _kPaginationThreshold = 200.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<LandingPageBloc>().add(
      LoadLandingPage(pageName: widget.pageName),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _kPaginationThreshold) {
      final bloc = context.read<LandingPageBloc>();
      final state = bloc.state;
      if (state.isSuccess && state.hasNextPage && !state.isLoadingMore) {
        bloc.add(const LoadNextLandingPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.neutralBlack,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BlocSelector<LandingPageBloc, LandingPageState, String>(
          selector: (state) =>
              state.homePage?.pageName ??
              widget.title ??
              _formatPageName(widget.pageName),
          builder: (context, title) =>
              Text(title, style: AppTypographyV1.bodyLarge.semiBold),
        ),
      ),
      body: BlocBuilder<LandingPageBloc, LandingPageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return LoadingShimmer.listShimmer(itemCount: 6, itemHeight: 120);
          }

          if (state.isFailure) {
            return ErrorRetryWidget(
              message: state.errorMessage,
              onRetry: () => context.read<LandingPageBloc>().add(
                LoadLandingPage(pageName: widget.pageName),
              ),
            );
          }

          if (state.isSuccess) {
            final components = state.homePage?.pageComponents ?? [];
            if (components.isEmpty) {
              return const Center(
                child: Text(DiscoverStrings.noContentAvailable),
              );
            }

            final showLoader = state.isLoadingMore;
            return ListView.builder(
              controller: _scrollController,
              cacheExtent: MediaQuery.sizeOf(context).height * 2,
              itemCount: components.length + (showLoader ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= components.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return _KeepAliveItem(
                  child: PageComponentRenderer(component: components[index]),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  static String _formatPageName(String pageName) {
    return pageName
        .replaceAllMapped(RegExp(r'[_-]'), (_) => ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m[1]} ${m[2]}',
        )
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

class _KeepAliveItem extends StatefulWidget {
  final Widget child;
  const _KeepAliveItem({required this.child});

  @override
  State<_KeepAliveItem> createState() => _KeepAliveItemState();
}

class _KeepAliveItemState extends State<_KeepAliveItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
