import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pdp_bloc.dart';
import '../widgets/pdp_shimmer_loading.dart';
import '../widgets/pdp_snackbar.dart';
import 'pdp_content.dart';
import 'pdp_error_view.dart';

class PdpPage extends StatelessWidget {
  const PdpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<PdpBloc, PdpState>(
        listenWhen: (prev, curr) =>
            prev.snackBarTick != curr.snackBarTick &&
            curr.snackBarMessage != null,
        listener: (context, state) {
          PdpSnackbar.show(context, state.snackBarMessage!);
        },
        child: BlocBuilder<PdpBloc, PdpState>(
          builder: (context, state) => switch (state.status) {
            PdpStatus.loading => const PdpShimmerLoading(),
            PdpStatus.error => const PdpErrorView(),
            PdpStatus.success => PdpContent(state: state),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
