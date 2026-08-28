import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/network/connectivity/connectivity_listener.dart';
import 'package:hs_app_flutter/core/services/connectivity_service.dart';
import 'package:hs_app_flutter/features/talker_floating_button.dart';

import 'components/atoms/auto_semantics.dart';
import 'core/analytics/events/analytics_helper.dart';
import 'core/constants/route_names.dart';
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
              // Keeps the nav-bar badge in step with the cart without CartBloc
              // having to know the cubit exists (it used to be constructor-
              // injected, which made the bloc untestable and let the count
              // desync whenever a handler forgot its `set()` call).
              //
              // `items.length` is distinct lines, matching what the cart
              // screen itself shows. The add-to-cart paths instead report the
              // server's `cartItemQty` (total units) — reconciling those two
              // is tracked separately.
              BlocListener<CartBloc, CartState>(
                listenWhen: (a, b) => a.cart?.items.length != b.cart?.items.length,
                listener: (context, state) {
                  // Buy-now mode is the exception: that cart response is scoped
                  // to the single item being bought, so `items.length` is 1 no
                  // matter how full the bag is. The badge already carries the
                  // server's true `cartItemQty` from the buy-now call itself
                  // (PdpBloc._onBuyNow), and leaving the mode refetches the full
                  // bag, which lands here and corrects the count.
                  if (context.read<CartBloc>().instantCheckout) return;
                  context.read<CartCountCubit>().set(state.cart?.items.length ?? 0);
                },
              ),
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
        },
      ),
    );
  }
}
