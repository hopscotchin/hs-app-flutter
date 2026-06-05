import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/features/talker_floating_button.dart';

import 'core/cubits/cart_count_cubit.dart';
import 'core/di/injection.dart';
import 'core/network/connectivity/connectivity_listener.dart';
import 'core/router/app_router.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/app_theme.dart';
import 'features/account/presentation/bloc/account_bloc.dart';
import 'features/categories/presentation/bloc/categories_bloc.dart';
import 'features/discover/presentation/bloc/home_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';

class HSApp extends StatelessWidget {
  const HSApp({super.key});

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCountCubit>.value(value: sl<CartCountCubit>()),
        BlocProvider<SplashBloc>(create: (_) => sl<SplashBloc>()),
        BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
        BlocProvider<CategoriesBloc>(create: (_) => sl<CategoriesBloc>()),
        BlocProvider<AccountBloc>(create: (_) => sl<AccountBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Hopscotch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return TalkerFloatingButton(
            child: ConnectivityListener(
              connectivityService: sl<ConnectivityService>(),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
