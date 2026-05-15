import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../services/connectivity_service.dart';

class ConnectivityListener extends StatefulWidget {
  final ConnectivityService connectivityService;
  final Widget child;

  const ConnectivityListener({
    super.key,
    required this.connectivityService,
    required this.child,
  });

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  late final StreamSubscription<bool> _subscription;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    _subscription = widget.connectivityService.onConnectivityChanged.listen(
      _onChanged,
    );
  }

  void _onChanged(bool isConnected) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    if (!isConnected) {
      _wasOffline = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.wifi_off, color: AppColors.onPrimary, size: 20),
              const SizedBox(width: 12),
              Text(
                'No internet connection',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else if (_wasOffline) {
      _wasOffline = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.wifi, color: AppColors.onPrimary, size: 20),
              const SizedBox(width: 12),
              Text(
                'Back online',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
