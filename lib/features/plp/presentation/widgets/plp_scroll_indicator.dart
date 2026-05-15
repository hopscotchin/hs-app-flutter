import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/typography.dart';
import '../bloc/plp_bloc.dart';

class PlpScrollIndicator extends StatefulWidget {
  final ScrollController scrollController;

  const PlpScrollIndicator({super.key, required this.scrollController});

  @override
  State<PlpScrollIndicator> createState() => _PlpScrollIndicatorState();
}

class _PlpScrollIndicatorState extends State<PlpScrollIndicator> {
  int _visibleCount = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final state = context.read<PlpBloc>().state;
    if (state.products.isEmpty) return;

    final position = widget.scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    final fraction = position.pixels / position.maxScrollExtent;
    final count = (fraction * state.products.length).ceil().clamp(
      0,
      state.totalRecords ?? 0,
    );

    if (count != _visibleCount) {
      setState(() => _visibleCount = count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, (bool, int)>(
      selector: (state) => (state.hasProducts, state.totalRecords ?? 0),
      builder: (context, data) {
        final (hasProducts, totalRecords) = data;
        if (!hasProducts) return const SizedBox.shrink();

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: GestureDetector(
              onTap: () => widget.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.keyboard_arrow_up, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$_visibleCount of $totalRecords',
                      style: AppTypography.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
