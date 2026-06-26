import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/strings/login_redirects.dart';
import '../../../core/entities/message_bar_entity.dart';
import '../../../core/router/app_navigator.dart';
import '../../account/presentation/bloc/account_bloc.dart';
import 'cubit/wishlist_cubit.dart';

/// The single entry point every screen uses to toggle wishlist membership.
///
/// Screens never talk to [WishlistCubit] or the auth flow directly — they call
/// this, which gates on login (deferring the action via [WishlistCubit.setPending]
/// when logged out) and otherwise toggles the global store.
abstract final class WishlistActions {
  static void toggle(
    BuildContext context, {
    required String productId,
    required int price,
    String? sku,
    List<MessageBarEntity> loggedOutMessageBars = const [],
  }) {
    final loggedIn = context.read<AccountBloc>().state.account.isLoggedIn;
    final cubit = context.read<WishlistCubit>();

    if (!loggedIn) {
      cubit.setPending(productId: productId, price: price, sku: sku);
      AppNavigator.goToLogin(
        context,
        redirectType: LoginRedirects.typeAddToWishlist,
        initialMessageBars: loggedOutMessageBars,
      );
      return;
    }
    cubit.toggle(productId: productId, price: price, sku: sku);
  }

  /// Parses a display price like `"₹2,665"` / `"Rs. 1299"` into an int.
  static int priceToInt(String? raw) {
    if (raw == null || raw.isEmpty) return 0;
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }
}
