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
            prev.snackBarTick != curr.snackBarTick && curr.snackBarMessage != null,
        listener: (context, state) {
          PdpSnackbar.show(context, state.snackBarMessage!);
        },
        child: BlocBuilder<PdpBloc, PdpState>(
          // Only the fields PdpContent actually reads in build. Everything else
          // on PdpState is consumed by a narrower subscriber, so letting it
          // through here rebuilt the entire page — every fixed section, the
          // whole SliverChildListDelegate — for nothing.
          //
          // KEEP IN SYNC: a new PdpState field read by PdpContent.build must
          // be added here, otherwise the page silently won't rebuild for it.
          //   isAddingToBag / isBuyingNow  → the add-to-bag bar's own BlocBuilder
          //   *SuccessTick, snackBar*      → BlocListeners with listenWhen
          //   pincodeVerify*               → awaited off bloc.stream, not built
          //   sizeChart*, isLoadingSizeChart → the size-chart sheet's BlocBuilder
          //   recommendations*             → the recommendations sliver's BlocBuilder
          //   recommendationsPage, errorMessage → not read in build at all
          // status covers the error view, which takes no message.
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.productDetail != curr.productDetail ||
              prev.selectedSku != curr.selectedSku ||
              prev.verifiedPincode != curr.verifiedPincode ||
              prev.expandedDetailTab != curr.expandedDetailTab,
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
