import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';

/// Pagination spinner kept in its own selector so flipping `isLoadingMore`
/// never rebuilds the surrounding scroll view.
class LoadingMoreSliver extends StatelessWidget {
  const LoadingMoreSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, bool>(
      selector: (s) => s.isLoadingMore,
      builder: (_, loading) {
        if (!loading) return const SliverToBoxAdapter(child: SizedBox.shrink());
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}
