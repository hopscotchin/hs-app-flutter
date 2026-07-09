import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:hs_app_flutter/core/services/pref_manager.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const InitializeApp());
  }

  @override
  Widget build(BuildContext context) {
    final hasSeenEnterStore = sl<PrefManager>().isStoreButtonClicked ?? false;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: BlocConsumer<SplashBloc, SplashState>(
          listener: _onStateChange,
          builder: (context, state) {
            return Column(
              children: [
                Expanded(child: Center(child: Image.asset(ImageConstants.splashAnimation))),
                if (state.isLoaded && !hasSeenEnterStore) _buildEnterStoreButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onStateChange(BuildContext context, SplashState state) {
    if (state.isEnvironmentSelection) {
      _showEnvironmentSelector(context, state.pendingEnvironment!);
      return;
    }
    if (state.isError) {
      AppNavigator.goToHome(context);
    }

    if (!state.isLoaded) return;

    final prefs = sl<PrefManager>();
    context.read<CartCountCubit>().set(state.customerInfo?.cartItemCount ?? 0);

    final isLoggedIn = state.customerInfo?.isLoggedIn ?? prefs.isLoggedIn;
    final hasSeenEnterStore = prefs.isStoreButtonClicked ?? false;
    if (isLoggedIn || hasSeenEnterStore) {
      AppNavigator.goToHome(context);
    }
  }

  Widget _buildEnterStoreButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            await sl<PrefManager>().setHasStoreButtonClicked(true);
            if (!mounted) return;
            AppNavigator.goToHome(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.baseDefault,
            foregroundColor: AppColors.brandDefault,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ENTER THE STORE',
                style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontSize: 16),
              ),
              const SizedBox(width: 8),
              const SizedBox(width: 24, height: 24, child: Icon(Icons.arrow_circle_right_outlined)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(SplashState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.errorMessage, style: AppTypography.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.read<SplashBloc>().add(const InitializeApp()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEnvironmentSelector(
    BuildContext context,
    Environment currentEnvironment,
  ) async {
    final bloc = context.read<SplashBloc>();
    final selected = await showDialog<Environment>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Environment', style: AppTypography.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Environment.values.map((env) {
            final isSelected = currentEnvironment == env;
            return ListTile(
              key: ValueKey(_environmentKey(env)),
              title: Text(_environmentLabel(env)),
              trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () => Navigator.of(dialogContext).pop(env),
            );
          }).toList(),
        ),
      ),
    );

    if (selected != null && mounted) {
      bloc.add(SelectEnvironment(selected));
    }
  }

  String _environmentLabel(Environment env) {
    return switch (env) {
      Environment.debug => 'Debug',
      Environment.debugVPN => 'Debug VPN',
      Environment.release => 'Release',
    };
  }

  String _environmentKey(Environment env) {
    return switch (env) {
      Environment.debug => SplashTestStrings.envDebugButton,
      Environment.debugVPN => SplashTestStrings.envDebugVpnButton,
      Environment.release => SplashTestStrings.envProdButton,
    };
  }
}
