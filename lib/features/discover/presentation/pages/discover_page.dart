import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';

import '../../../../components/loading_shimmer.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../bloc/home_bloc.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        title: RepaintBoundary(
          child: SvgPicture.asset(
            ImageConstants.hsLogo,
            height: 54,
            width: 127,
            placeholderBuilder: (_) => const SizedBox(height: 54, width: 127),
          ),
        ),
        actions: [
          Text(
            'Hi HS !',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: RepaintBoundary(
              child: SvgPicture.asset(
                ImageConstants.heart,
                height: 24,
                width: 24,
                placeholderBuilder: (_) =>
                    const SizedBox(height: 24, width: 24),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return LoadingShimmer.listShimmer(itemCount: 6, itemHeight: 120);
          }

          if (state is HomeLoaded) {
            final components = state.homePage.pageComponents;
            if (components.isEmpty) {
              return const Center(child: Text('No content available'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshHomePage());
              },
              child: const Center(child: Text("Hello from Discover Page")),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Prevents [ListView.builder] from disposing children when scrolled off-screen,
/// so images and widget state are retained.
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
