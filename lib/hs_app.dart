import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/features/talker_floating_button.dart';

import 'core/analytics/events/analytics_helper.dart';
import 'core/constants/route_names.dart';
import 'core/cubits/cart_count_cubit.dart';
import 'core/di/injection.dart';
import 'core/network/connectivity/connectivity_listener.dart';
import 'core/router/app_router.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/snackbar_utils.dart';
import 'features/account/presentation/bloc/account_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/cubit/cart_actions_cubit.dart';
import 'features/categories/presentation/bloc/categories_bloc.dart';
import 'features/discover/presentation/bloc/home_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';

class HSApp extends StatefulWidget {
  const HSApp({super.key});

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  State<HSApp> createState() => _HSAppState();
}

class _HSAppState extends State<HSApp> with WidgetsBindingObserver {
  // Mirrors Android `Foreground.TIMEOUT_DURATION`: > 30 min background
  // → force-navigate to splash instead of firing app_launched.
  static const Duration _backgroundTimeout = Duration(minutes: 30);

  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final bgAt = _backgroundedAt;
      if (bgAt == null) return;
      _backgroundedAt = null;
      final analytics = sl<AnalyticsHelper>();
      // identifyFromBackground fires on every fg-return regardless of
      // duration (Android `Foreground.java:154-157`).
      analytics.identifyFromBackground();
      if (DateTime.now().difference(bgAt) > _backgroundTimeout) {
        AppRouter.router.go(RouteNames.splash);
        return;
      }
      analytics.logAppLaunchedFromBackground();
    }
  }

  static void _showActionSnack(BuildContext context, String? message, bool isError) {
    if (message == null || message.isEmpty) return;
    context.showSnack(message, status: isError ? SnackStatus.error : SnackStatus.success);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCountCubit>.value(value: sl<CartCountCubit>()),
        BlocProvider<WishlistCubit>.value(value: sl<WishlistCubit>()),
        BlocProvider<CartActionsCubit>.value(value: sl<CartActionsCubit>()),
        BlocProvider<SplashBloc>(create: (_) => sl<SplashBloc>()),
        BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
        BlocProvider<CategoriesBloc>(create: (_) => sl<CategoriesBloc>()),
        BlocProvider<AccountBloc>(create: (_) => sl<AccountBloc>()),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Hopscotch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        scaffoldMessengerKey: HSApp.scaffoldMessengerKey,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<WishlistCubit, WishlistState>(
                listenWhen: (a, b) => a.feedbackTick != b.feedbackTick,
                listener: (context, state) =>
                    _showActionSnack(context, state.feedbackMessage, state.feedbackIsError),
              ),
              BlocListener<CartActionsCubit, CartActionsState>(
                listenWhen: (a, b) => a.feedbackTick != b.feedbackTick,
                listener: (context, state) =>
                    _showActionSnack(context, state.feedbackMessage, state.feedbackIsError),
              ),
            ],
            child: TalkerFloatingButton(
              child: ConnectivityListener(
                connectivityService: sl<ConnectivityService>(),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          );
        },
      ),
    );
  }
}
