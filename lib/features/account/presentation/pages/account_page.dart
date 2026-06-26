import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/app_bottom_sheet.dart';
import 'package:hs_app_flutter/components/appbar/hs_appbar.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/login_redirects.dart';
import 'package:hs_app_flutter/core/entities/message_bar_entity.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/utils/snackbar_utils.dart';
import 'package:hs_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hs_app_flutter/features/discover/presentation/bloc/home_bloc.dart';
import 'package:hs_app_flutter/features/wishlist/presentation/cubit/wishlist_cubit.dart';

import '../../../../core/theme/colors.dart';
import '../../domain/entities/account_entity.dart';
import '../bloc/account_bloc.dart';
import '../widgets/account_footer_widget.dart';
import '../widgets/account_header_widget.dart';
import '../widgets/account_help_section_widget.dart';
import '../widgets/account_menu_item_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar.titleOnly(title: AccountStrings.accounts),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AccountBloc, AccountState>(
            listenWhen: (p, c) =>
                p.forgetError != c.forgetError || p.forgetCompleted != c.forgetCompleted,
            listener: (context, state) {
              if (state.forgetError != null) {
                context.showSnack(state.forgetError!, status: SnackStatus.error);
                context.read<AccountBloc>().add(const AccountEvent.clearForgetSignal());
              }
              if (state.forgetCompleted) {
                AppNavigator.goToHome(context);
                context.read<AccountBloc>().add(const AccountEvent.clearForgetSignal());
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.isSignedOut) {
                context.read<AccountBloc>().add(const AccountEvent.refreshFromLocal());
                AppNavigator.goToHome(context);
              } else if (state.isError) {
                context.showSnack(state.errorMessage, status: SnackStatus.error);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            BlocSelector<AccountBloc, AccountState, AccountEntity>(
              selector: (s) => s.account,
              builder: (_, account) => _AccountContent(account: account),
            ),
            BlocBuilder<AccountBloc, AccountState>(
              buildWhen: (p, c) => p.isForgetting != c.isForgetting,
              builder: (_, accountState) {
                return BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) => p.isLoading != c.isLoading,
                  builder: (_, authState) {
                    final showOverlay = accountState.isForgetting || authState.isLoading;
                    return showOverlay
                        ? const ColoredBox(
                            color: Colors.black38,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountContent extends StatelessWidget {
  final AccountEntity account;

  const _AccountContent({required this.account});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = account.isLoggedIn;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.verticalGapSm,
                  AccountHeaderWidget(
                    account: account,
                    onForgetMe: () => _showForgetDialog(context),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: AppSpacing.md),
                    child: Divider(height: 1, color: AppColors.dividerLight),
                  ),
                  !isLoggedIn ? AppSpacing.verticalGapXl : AppSpacing.verticalGapMd,

                  AccountMenuItemWidget(
                    svgAsset: ImageConstants.ordersItemIcon,
                    title: AccountStrings.orders,
                    subtitle: isLoggedIn ? null : AccountStrings.ordersSubtitle,
                    onTap: () => isLoggedIn
                        ? AppNavigator.goToOrders(context)
                        : AppNavigator.goToLogin(
                            context,
                            redirectType: LoginRedirects.typeOrders,
                            initialMessageBars: [
                              const MessageBarEntity(
                                text: LoginRedirects.redirectOrders,
                                type: 'info',
                                hasIcon: true,
                              ),
                            ],
                          ),
                  ),
                  AccountMenuItemWidget(
                    svgAsset: ImageConstants.wishlistItemIcon,
                    title: AccountStrings.wishlist,
                    subtitle: isLoggedIn ? null : AccountStrings.wishlistSubtitle,
                    onTap: () => isLoggedIn
                        ? AppNavigator.goToHome(context)
                        : AppNavigator.goToLogin(
                            context,
                            redirectType: LoginRedirects.typeWishlistScreenFromAccount,
                            initialMessageBars: [
                              const MessageBarEntity(
                                text: LoginRedirects.redirectWishlistScreenFromAccount,
                                type: 'info',
                                hasIcon: true,
                              ),
                            ],
                          ),
                  ),
                  AccountMenuItemWidget(
                    svgAsset: ImageConstants.profileDetailsItemIcon,
                    title: AccountStrings.profileDetails,
                    subtitle: isLoggedIn ? null : AccountStrings.profileDetailsSubtitle,
                    onTap: () => isLoggedIn
                        ? AppNavigator.goToHome(context)
                        : AppNavigator.goToLogin(
                            context,
                            redirectType: LoginRedirects.typeAccountSettings,
                            initialMessageBars: [
                              const MessageBarEntity(
                                text: LoginRedirects.redirectProfileDetails,
                                type: 'info',
                                hasIcon: true,
                              ),
                            ],
                          ),
                  ),
                  AccountMenuItemWidget(
                    svgAsset: ImageConstants.addressItemIcon,
                    title: AccountStrings.savedAddresses,
                    subtitle: isLoggedIn ? null : AccountStrings.savedAddressesSubtitle,
                    onTap: () => isLoggedIn
                        ? AppNavigator.goToAddresses(context)
                        : AppNavigator.goToLogin(
                            context,
                            redirectType: LoginRedirects.typeAddresses,
                            initialMessageBars: [
                              const MessageBarEntity(
                                text: LoginRedirects.redirectAddresses,
                                type: 'info',
                                hasIcon: true,
                              ),
                            ],
                          ),
                  ),
                  AccountMenuItemWidget(
                    svgAsset: ImageConstants.cardsItemIcon,
                    title: AccountStrings.manageCards,
                    subtitle: isLoggedIn ? null : AccountStrings.manageCardsSubtitle,
                    onTap: () => isLoggedIn
                        ? AppNavigator.goToHome(context)
                        : AppNavigator.goToLogin(
                            context,
                            redirectType: LoginRedirects.typeCards,
                            initialMessageBars: [
                              const MessageBarEntity(
                                text: LoginRedirects.redirectCards,
                                type: 'info',
                                hasIcon: true,
                              ),
                            ],
                          ),
                  ),
                  AccountMenuItemWidget(
                    svgAsset: ImageConstants.creditsItemIcon,
                    title: AccountStrings.creditsMenu,
                    subtitle: isLoggedIn ? null : AccountStrings.checkCreditBalance,
                    subtitleColor: isLoggedIn ? AppColors.success : AppColors.textPrimary,
                    trailingText: isLoggedIn && account.credit != null
                        ? '₹ ${account.credit!.toStringAsFixed(0)}'
                        : null,
                    onTap: () => isLoggedIn
                        ? AppNavigator.goToHome(context)
                        : AppNavigator.goToLogin(
                            context,
                            redirectType: LoginRedirects.typeCredits,
                            initialMessageBars: [
                              const MessageBarEntity(
                                text: LoginRedirects.redirectCredits,
                                type: 'info',
                                hasIcon: true,
                              ),
                            ],
                          ),
                  ),
                  AccountMenuItemWidget(
                    svgAsset: ImageConstants.kidsItemIcon,
                    title: AccountStrings.myKids,
                    subtitle: isLoggedIn ? null : AccountStrings.myKidsSubtitle,
                    onTap: () => isLoggedIn
                        ? AppNavigator.goToHome(context)
                        : AppNavigator.goToLogin(
                            context,
                            redirectType: LoginRedirects.typeKids,
                            initialMessageBars: [
                              const MessageBarEntity(
                                text: LoginRedirects.redirectKids,
                                type: 'info',
                                hasIcon: true,
                              ),
                            ],
                          ),
                  ),
                  AppSpacing.verticalGapXs,
                  const Divider(
                    height: 1,
                    color: AppColors.dividerLight,
                    indent: AppSpacing.md,
                    endIndent: AppSpacing.md,
                  ),
                  const AccountHelpSectionWidget(),
                  AccountFooterWidget(
                    isLoggedIn: isLoggedIn,
                    onLegal: () => AppNavigator.goToLegal(context),
                    onSignIn: () => AppNavigator.goToLogin(context),
                    onSignOut: () {
                      final homeBloc = context.read<HomeBloc>();
                      final wishlistCubit = context.read<WishlistCubit>();
                      context.read<AuthBloc>().add(
                        AuthEvent.signOut(
                          onSuccess: () {
                            // Drop the previous user's wishlist/cart so the
                            // refreshed responses re-seed with the now
                            // logged-out (false) statuses.
                            wishlistCubit.invalidateOnAuthChange();
                            homeBloc.add(const RefreshHomePage());
                          },
                        ),
                      );
                    },
                  ),
                  // Fills leftover viewport below the footer with the footer's
                  // grey so no white gap shows when content is short (logged in).
                  const Expanded(child: ColoredBox(color: AppColors.neutralGrey6)),
                  // White gap kept at the very bottom above the nav bar.
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showForgetDialog(BuildContext context) async {
    final bloc = context.read<AccountBloc>();
    final confirmed = await AppBottomSheet.show<bool>(
      context,
      title: AccountStrings.confirmDeleteTitle,
      description: AccountStrings.confirmDeleteGuest,
      secondaryAction: AppBottomSheetAction(
        label: CommonStrings.cancel,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
      primaryAction: AppBottomSheetAction(
        label: CommonStrings.remove,
        style: AppBottomSheetButtonStyle.filled,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
      ),
    );
    if (confirmed == true) {
      bloc.add(const AccountEvent.forgetGuestUser());
    }
  }
}
