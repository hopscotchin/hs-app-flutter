import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../../../core/config/environment.dart';
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
    context.read<SplashBloc>().add(InitializeApp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: BlocConsumer<SplashBloc, SplashState>(
          listener: _onStateChange,
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(ImageConstants.splashAnimation),
                  ),
                ),
                if (state is SplashLoaded) _buildEnterStoreButton(),
                if (state is SplashError) _buildErrorView(state),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onStateChange(BuildContext context, SplashState state) {
    if (state is SplashEnvironmentSelection) {
      _showEnvironmentSelector(context, state.currentEnvironment);
    }
  }

  Widget _buildEnterStoreButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => context.go(RouteNames.home),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.baseDefault,
            foregroundColor: AppColors.brandDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ENTER THE STORE',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                width: 24,
                height: 24,
                child: Icon(Icons.arrow_circle_right_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(SplashError state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            state.message,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.read<SplashBloc>().add(InitializeApp());
            },
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
        title: const Text(
          'Select Environment',
          style: AppTypography.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Environment.values.map((env) {
            final isSelected = currentEnvironment == env;
            return ListTile(
              title: Text(_environmentLabel(env)),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => Navigator.of(dialogContext).pop(env),
            );
          }).toList(),
        ),
      ),
    );

    if (selected != null && mounted) {
      bloc.add(SelectEnvironment(environment: selected));
    }
  }

  String _environmentLabel(Environment env) {
    switch (env) {
      case Environment.debug:
        return 'Debug';
      case Environment.debugVPN:
        return 'Debug VPN';
      case Environment.release:
        return 'Release';
    }
  }
}
