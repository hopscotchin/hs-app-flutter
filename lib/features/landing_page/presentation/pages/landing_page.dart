import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<LandingPageBloc>().add(
      LoadLandingPage(pageName: widget.pageName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BlocSelector<LandingPageBloc, LandingPageState, String>(
          selector: (state) =>
              state.homePage?.pageName ??
              widget.title ??
              _formatPageName(widget.pageName),
          builder: (context, title) =>
              Text(title, style: AppTypography.titleMedium),
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

            return ListView.builder(
              cacheExtent: MediaQuery.sizeOf(context).height * 2,
              itemCount: components.length,
              itemBuilder: (context, index) {
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
