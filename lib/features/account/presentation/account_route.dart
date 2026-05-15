import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';

import 'pages/account_page.dart';

class AccountRoute {
  static StatefulShellBranch getBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteNames.account,
        name: 'account',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const AccountPage(),
        ),
      ),
    ],
  );
}
