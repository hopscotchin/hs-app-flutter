import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/strings/discover_strings.dart';

/// Wraps a shell-branch root page so the Android hardware back button on
/// that branch shows a "press back again to exit" snackbar, and a second
/// press within the window exits the app.
///
/// Why per-branch instead of one PopScope on the Dashboard: with
/// `StatefulShellRoute`, each branch Navigator consumes the pop first —
/// a PopScope on the outer Dashboard route only fires reliably for the
/// primary branch. Registering PopScope inside each branch's route builder
/// attaches it to the BRANCH's route, so it fires uniformly across all
/// tabs (Discover, Categories, Account) as soon as the branch Navigator's
/// `maybePop` reaches its (single) root route.
///
/// State is deliberately static so pressing back on one tab, quickly
/// switching to another, and pressing back again still counts as the
/// second press — matches Android's behavior of an app-scoped exit
/// counter rather than a per-screen one.
class BackToExitScope extends StatelessWidget {
  const BackToExitScope({super.key, required this.child});

  final Widget child;

  static const Duration _kBackPressInterval = Duration(milliseconds: 6000);
  static const Duration _kBackSnackDuration = Duration(seconds: 2);

  static int _backPressCount = 2;
  static DateTime? _lastBackPressedAt;

  static void _handle(BuildContext context) {
    final now = DateTime.now();
    if (_lastBackPressedAt != null &&
        now.difference(_lastBackPressedAt!) > _kBackPressInterval) {
      _backPressCount = 2;
    }

    if (_backPressCount >= 2) {
      _lastBackPressedAt = now;
      _backPressCount--;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(DiscoverStrings.backButtonHit),
            duration: _kBackSnackDuration,
          ),
        );
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handle(context);
      },
      child: child,
    );
  }
}
