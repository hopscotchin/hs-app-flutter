import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/utils/snackbar_utils.dart';
import 'package:hs_app_flutter/core/widgets/app_dialog.dart';
import 'package:hs_app_flutter/core/constants/strings/login_redirects.dart';
import 'package:hs_app_flutter/core/entities/message_bar_entity.dart';
import 'package:hs_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.5,
        elevation: 0,
        titleSpacing: 16,
        centerTitle: false,
        title: Text(AccountStrings.accounts, style: AppTypographyV1.titleMedium.bold.textPrimary()),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.verticalGapMd,
          AccountHeaderWidget(account: account),
          const Divider(height: 1, color: AppColors.divider),
          AppSpacing.verticalGapMd,

          AccountMenuItemWidget(
            svgAsset: ImageConstants.ordersItemIcon,
            title: AccountStrings.orders,
            subtitle: isLoggedIn ? null : AccountStrings.ordersSubtitle,
            onTap: () => isLoggedIn
                ? AppNavigator.goToOrders(context)
                : AppNavigator.goToLogin(
                    context,
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
                ? AppNavigator.goToHome(context)
                : AppNavigator.goToLogin(
                    context,
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
                    initialMessageBars: [
                      const MessageBarEntity(
                        text: LoginRedirects.redirectKids,
                        type: 'info',
                        hasIcon: true,
                      ),
                    ],
                  ),
          ),

          const Divider(height: 1, color: AppColors.divider),
          const AccountHelpSectionWidget(),
          AccountFooterWidget(
            isLoggedIn: isLoggedIn,
            hasGuestData: account.hasGuestData,
            onSignIn: () => AppNavigator.goToLogin(context),
            onSignOut: () => context.read<AuthBloc>().add(const AuthEvent.signOut()),
            onForgetMe: () => _showForgetDialog(context),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _showForgetDialog(BuildContext context) async {
    final bloc = context.read<AccountBloc>();
    final confirmed = await AppDialog.show<bool>(
      context,
      title: AccountStrings.confirmDeleteTitle,
      description: AccountStrings.confirmDeleteGuest,
      secondaryAction: AppDialogAction(
        label: CommonStrings.cancel,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
      primaryAction: AppDialogAction(
        label: AccountStrings.forget,
        style: AppDialogButtonStyle.filled,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
      ),
    );
    if (confirmed == true) {
      bloc.add(const AccountEvent.forgetGuestUser());
    }
  }
}
