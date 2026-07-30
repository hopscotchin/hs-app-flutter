import 'package:flutter/material.dart';

import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../widgets/pdp_appbar.dart';

class PdpErrorView extends StatelessWidget {
  const PdpErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep the PDP app bar visible (back / wishlist / bag) so the user can
    // still navigate away, with the "product moved" empty state filling the
    // remaining space. Reuses the shared EmptyStateWidget (same component PLP
    // uses) with the notFound (404) illustration.
    return Column(
      children: [
        const PdpAppBarContent(),
        Expanded(
          child: EmptyStateWidget(
            key: const ValueKey(PdpTestStrings.errorView),
            type: EmptyStateType.notFound,
            title: PdpStrings.productMovedTitle,
            subtitle: PdpStrings.productMovedSubtitle,
            buttonLabel: PdpStrings.exploreNow,
            buttonKey: const ValueKey(PdpTestStrings.errorExploreButton),
            onButtonTap: () => AppNavigator.goToHome(context),
          ),
        ),
      ],
    );
  }
}
