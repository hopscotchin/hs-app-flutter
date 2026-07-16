import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/strings/login_redirects.dart';
import '../../../core/entities/message_bar_entity.dart';
import '../../../core/router/app_navigator.dart';
import '../../account/presentation/bloc/account_bloc.dart';
import 'cubit/cart_actions_cubit.dart';

/// The single entry point every screen uses to add a SKU to the cart.
///
/// Gates on login (deferring via [CartActionsCubit.setPending] when logged out)
/// and otherwise dispatches to the global [CartActionsCubit].
abstract final class CartActions {
  static void add(
    BuildContext context, {
    required String skuId,
    int quantity = 1,
    List<MessageBarEntity> loggedOutMessageBars = const [],
  }) {
    final loggedIn = context.read<AccountBloc>().state.account.isLoggedIn;
    final cubit = context.read<CartActionsCubit>();

    if (!loggedIn) {
      cubit.setPending(skuId: skuId, quantity: quantity);
      AppNavigator.goToLogin(
        context,
        redirectType: LoginRedirects.typeAddToCart,
        initialMessageBars: loggedOutMessageBars,
      );
      return;
    }
    cubit.add(skuId: skuId, quantity: quantity);
  }
}
