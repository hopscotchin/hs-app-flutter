import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../components/loading_shimmer.dart';
import '../../../../core/theme/spacing.dart';
import '../bloc/moments_bloc.dart';
import '../widgets/moment_card_widget.dart';

class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MomentsBloc>().add(LoadMoments());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<MomentsBloc>().state;
      if (state is MomentsLoaded && !state.hasReachedMax) {
        context.read<MomentsBloc>().add(LoadMoreMoments());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<MomentsBloc, MomentsState>(
        builder: (context, state) {
          if (state is MomentsLoading) {
            return LoadingShimmer.gridShimmer();
          }

          if (state is MomentsLoaded) {
            if (state.moments.isEmpty) {
              return const Center(child: Text('No moments yet'));
            }

            return Padding(
              padding: AppSpacing.paddingHorizontalMd,
              child: MasonryGridView.count(
                controller: _scrollController,
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.xs,
                crossAxisSpacing: AppSpacing.xs,
                itemCount: state.moments.length,
                itemBuilder: (context, index) {
                  final moment = state.moments[index];
                  return MomentCardWidget(
                    moment: moment,
                    onLike: () => context.read<MomentsBloc>().add(
                      LikeMoment(momentId: moment.id),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
