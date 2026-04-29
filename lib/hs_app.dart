import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/connectivity/connectivity_listener.dart';
import 'core/router/app_router.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/categories/presentation/bloc/categories_bloc.dart';
import 'features/discover/presentation/bloc/home_bloc.dart';
import 'features/main/di/injection_container.dart';
import 'features/moments/presentation/bloc/moments_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';

class HSApp extends StatelessWidget {
  const HSApp({super.key});

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (_) => sl<SplashBloc>()),
        BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
        BlocProvider<CategoriesBloc>(create: (_) => sl<CategoriesBloc>()),
        BlocProvider<MomentsBloc>(create: (_) => sl<MomentsBloc>()),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Hopscotch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return ConnectivityListener(
            connectivityService: sl<ConnectivityService>(),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
