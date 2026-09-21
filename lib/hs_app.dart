import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/network/connectivity/connectivity_listener.dart';
import 'package:hs_app_flutter/core/services/connectivity_service.dart';
import 'package:hs_app_flutter/features/talker_floating_button.dart';

import 'components/atoms/auto_semantics.dart';
import 'core/analytics/events/analytics_helper.dart';
import 'core/constants/route_names.dart';
import 'core/cubits/bottom_nav_visibility_cubit.dart';
import 'core/cubits/cart_count_cubit.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/snackbar_utils.dart';
import 'features/account/presentation/bloc/account_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/cubit/cart_actions_cubit.dart';
import 'features/categories/presentation/bloc/categories_bloc.dart';
import 'features/discover/presentation/bloc/home_bloc.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
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

  static void _showActionSnack(
    BuildContext context,
    String? message,
    bool isError,
  ) {
    if (message == null || message.isEmpty) return;
    context.showSnack(
      message,
      status: isError ? SnackStatus.error : SnackStatus.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCountCubit>.value(value: sl<CartCountCubit>()),
        BlocProvider<BottomNavVisibilityCubit>.value(
          value: sl<BottomNavVisibilityCubit>(),
        ),
        BlocProvider<WishlistCubit>.value(value: sl<WishlistCubit>()),
        BlocProvider<CartActionsCubit>.value(value: sl<CartActionsCubit>()),
        BlocProvider<SplashBloc>(create: (_) => sl<SplashBloc>()),
        BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
        BlocProvider<CategoriesBloc>(create: (_) => sl<CategoriesBloc>()),
        // Categories' inline search (see CategoriesPage) needs this alive for
        // the lifetime of the shell tab, same as CategoriesBloc above — not
        // route-scoped like the dedicated Search page's own instance.
        BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
        BlocProvider<AccountBloc>(create: (_) => sl<AccountBloc>()),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Hopscotch',
        debugShowCheckedModeBanner: false,
        // Both required by DevicePreview, and both inert when it is disabled:
        // `locale` returns null and `appBuilder` returns its child untouched, so
        // an AUTOMATION or release build behaves exactly as before.
        //
        // useInheritedMediaQuery is deprecated and ignored by Flutter — the View
        // widget owns MediaQuery now — but device_preview still reads it to warn
        // when it is false, so setting it only silences that check.
        // ignore: deprecated_member_use
        useInheritedMediaQuery: true,
        locale: kDebugMode ? DevicePreview.locale(context) : null,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        scaffoldMessengerKey: HSApp.scaffoldMessengerKey,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          final app = MultiBlocListener(
            listeners: [
              // Keeps the nav-bar badge in step with the cart without CartBloc
              // having to know the cubit exists (it used to be constructor-
              // injected, which made the bloc untestable and let the count
              // desync whenever a handler forgot its `set()` call).
              //
              BlocListener<CartBloc, CartState>(
                listenWhen: (a, b) => _cartItemCount(a) != _cartItemCount(b),
                listener: (context, state) {
                  // Buy-now mode is the exception: that cart response is scoped

                  if (context.read<CartBloc>().instantCheckout) return;
                  context.read<CartCountCubit>().set(_cartItemCount(state));
                },
              ),
              BlocListener<WishlistCubit, WishlistState>(
                listenWhen: (a, b) => a.feedbackTick != b.feedbackTick,
                listener: (context, state) => _showActionSnack(
                  context,
                  state.feedbackMessage,
                  state.feedbackIsError,
                ),
              ),
              BlocListener<CartActionsCubit, CartActionsState>(
                listenWhen: (a, b) => a.feedbackTick != b.feedbackTick,
                listener: (context, state) => _showActionSnack(
                  context,
                  state.feedbackMessage,
                  state.feedbackIsError,
                ),
              ),
            ],
            // `automation_build` is a marker, not a target: it proves to a
            // driver's preflight check that this binary was built with
            // --dart-define=AUTOMATION=true, on ANY screen. Without it the only
            // way to tell is to find a wrapped widget, and the home fold has
            // none — so a preflight on the wrong screen cannot distinguish "no
            // ids here" from "ids nowhere", which is the single most expensive
            // thing to get wrong. Inert in every other build.
            child: AutoSemantics(
              id: 'automation_build',
              child: TalkerFloatingButton(
                child: ConnectivityListener(
                  connectivityService: sl<ConnectivityService>(),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          );

          // Guarded on kDebugMode, a compile-time constant, so a release build
          // drops this call site entirely. Without the guard, appBuilder keeps
          // DevicePreview — and its Provider store and freezed state union —
          // reachable on the release path, even though the preview can never
          // turn on there. `enabled: false` alone does not achieve that: the
          // code still has to be compiled to be able to check the flag.
          return kDebugMode ? DevicePreview.appBuilder(context, app) : app;
        },
      ),
    );
  }
}

int _cartItemCount(CartState state) =>
    state.cart?.orderDetails?.itemCount ?? state.cart?.items.length ?? 0;
