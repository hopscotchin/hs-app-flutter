import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import '../../../core/di/injection.dart';
import '../domain/entities/manage_address_args.dart';
import 'bloc/address_bloc.dart';
import 'bloc/manage_address_bloc.dart';
import 'pages/add_address_page.dart';
import 'pages/addresses_page.dart';
import 'widgets/address_item_card.dart';

class AddressRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.addresses,
    name: 'addresses',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final mode =
          extra?['mode'] as AddressListMode? ?? AddressListMode.normal;
      return BlocProvider(
        create: (_) => sl<AddressBloc>()..add(const LoadAddresses()),
        child: AddressesPage(mode: mode),
      );
    },
    routes: [
      GoRoute(
        path: RouteNames.addAddress,
        name: 'addAddress',
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final args = (extra?['args'] as ManageAddressArgs?) ??
              const ManageAddressArgs();
          return BlocProvider(
            create: (_) => sl<ManageAddressBloc>(),
            child: AddAddressPage(args: args),
          );
        },
      ),
    ],
  );
}
