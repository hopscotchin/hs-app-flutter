import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/app_bottom_sheet.dart';
import '../../../../components/buttons/app_button_named.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/cart_strings.dart';
import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../bloc/cart_bloc.dart';

/// Remove-item confirmation sheet.
///
/// Unlike the plain `AppBottomSheet.show` callers, this one stays open after
/// the user confirms: the Remove button goes into [ButtonState.loading] while
/// `RemoveCartItem` is in flight and the sheet closes itself once the API has
/// answered — success or failure. The outcome toast is not shown from here;
/// `CartBloc` puts it on `CartState.toastMessage` and the cart page's existing
/// listener renders it, which keeps the snack anchored to the page rather than
/// to a sheet that is being torn down.
///
/// The sheet holds no async of its own — it only reads `state.isRemoving(sku)`
/// and pops. That going back to false is the completion signal, so a cancelled
/// or failed call closes the sheet just as a successful one does.
Future<void> showRemoveCartItemSheet(BuildContext context, String sku) {
  final cartBloc = context.read<CartBloc>();
  return AppBottomSheet.showCustom<void>(
    context,
    builder: (_) => BlocProvider.value(
      value: cartBloc,
      child: _RemoveCartItemSheet(sku: sku),
    ),
  );
}

class _RemoveCartItemSheet extends StatelessWidget {
  const _RemoveCartItemSheet({required this.sku});

  final String sku;

  @override
  Widget build(BuildContext context) {
    // Mirrors AppBottomSheet's own padding so this sheet sits identically to
    // every other one, even though it builds its own buttons.
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final bottomPadding = Platform.isAndroid
        ? AppSpacing.md
        : (AppSpacing.md - safeBottom).clamp(0.0, AppSpacing.md);

    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (prev, curr) => prev.isRemoving(sku) && !curr.isRemoving(sku),
      listener: (context, _) => Navigator.of(context).maybePop(),
      buildWhen: (prev, curr) => prev.isRemoving(sku) != curr.isRemoving(sku),
      builder: (context, state) {
        final isRemoving = state.isRemoving(sku);
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: bottomPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  CartStrings.removeItemsTitle,
                  style: AppTypographyV1.titleSmall.bold.textPrimary(),
                ),
                AppSpacing.verticalGapMd,
                Text(
                  CartStrings.removeItemsDescription,
                  style: AppTypographyV1.bodyRegular.regular
                      .textPrimary()
                      .copyWith(height: 1.5),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TertiaryButton.defaultType(
                        key: const ValueKey(
                          CartTestStrings.removeItemBottomSheetRemoveButton,
                        ),
                        text: CommonStrings.remove,
                        state: isRemoving
                            ? ButtonState.loading
                            : ButtonState.enabled,
                        onTap: () => context.read<CartBloc>().add(
                          RemoveCartItem(sku: sku),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: PrimaryButton.defaultType(
                        key: const ValueKey(
                          CartTestStrings.removeItemBottomSheetNoButton,
                        ),
                        text: CartStrings.no,
                        state: ButtonState.enabled,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
