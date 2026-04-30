import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../components/error_retry_widget.dart';
import '../../../../components/loading_shimmer.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

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
        centerTitle: false,
        title: const Text('Studio', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ErrorRetryWidget(
        message: "Your Studio is curating with styles.!! Stay Tuned..!!",
        onRetry: VoidCallbackAction.new,
      ),
    );
  }
}
