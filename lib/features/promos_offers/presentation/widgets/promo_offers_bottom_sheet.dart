import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/features/account/presentation/bloc/account_bloc.dart';
import 'package:hs_app_flutter/features/cart/presentation/bloc/cart_bloc.dart';

import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/constants/strings/promos_offers_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/entities/backend_action_entity.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../domain/entities/promo_offer_entity.dart';
import '../../domain/entities/promo_offers_entity.dart';
import '../bloc/promos_offers_bloc.dart';
import 'promo_action_sheet.dart';
import 'promo_offer_card.dart';

/// Bottom sheet listing promo/offer sections. UI is driven entirely by the
/// API response via [PromosOffersBloc], which also owns apply/remove: applying
/// closes the sheet, removing keeps it open and reloads the list so `isApplied`
/// flips in place.
class PromoOffersBottomSheet extends StatelessWidget {
  const PromoOffersBottomSheet({
    super.key,
    this.onCartChanged,
    this.onAction,
    this.onActionSheet,
  });

  /// Called the first time an apply/remove lands server-side, so [show] can
  /// tell its caller the cart is stale.
  final VoidCallback? onCartChanged;

  /// Called with a backend action sheet that has to outlive this route (a
  /// successful apply closes the sheet before it can be shown here).
  final ValueChanged<BackendActionContentEntity>? onActionSheet;

  /// Called with a card's backend deeplink when its CTA is tapped. The sheet
  /// closes itself; the actual navigation is left to [show] so it runs against
  /// the caller's context rather than this dying route's.
  final ValueChanged<String>? onAction;

  /// Returns true only if a promo was actually applied or removed — a plain
  /// dismiss returns false, so the caller can skip reloading the cart.
  ///
  /// A CTA deeplink tapped inside the sheet is followed here, after the sheet
  /// has closed, so the pushed route doesn't end up stacked under it.
  static Future<bool> show(
      BuildContext context, {
        bool isDismissible = true,
        bool enableDrag = true,
      }) async {
    // Tracked outside the route: a drag/barrier dismiss never runs our own pop,
    // so the result can't be carried by the route's pop value.
    final outcome = _SheetOutcome();

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // DI boundary: this static factory is the sheet's "route" — it is not a
      // widget build, so `sl<>` here is the same allowance route builders get.
      // The sheet has no GoRoute of its own (it is a modal shown over the
      // caller), so there is no route file to move this into.
      builder: (_) => BlocProvider(
        create: (_) =>
        sl<PromosOffersBloc>()..add(const PromosOffersEvent.load()),
        child: PromoOffersBottomSheet(
          onCartChanged: () => outcome.cartChanged = true,
          onAction: (actionUri) => outcome.deeplink = actionUri,
          onActionSheet: (sheet) => outcome.actionSheet = sheet,
        ),
      ),
    );

    // Both run against the caller's context, now that this route is gone.
    final actionSheet = outcome.actionSheet;
    if (actionSheet != null && context.mounted) {
      await showPromoActionSheet(context, actionSheet);
    }

    final deeplink = outcome.deeplink;
    if (deeplink != null && context.mounted) {
      ActionUrlHandler.navigate(context, deeplink);
    }

    return outcome.cartChanged;
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final bottomPadding = Platform.isAndroid
        ? AppSpacing.md
        : (AppSpacing.md - safeBottom).clamp(0.0, AppSpacing.md);

    return BlocListener<PromosOffersBloc, PromosOffersState>(
      listenWhen: (prev, curr) => prev.actionNonce != curr.actionNonce,
      listener: (context, state) {
        if (state.cartChanged) onCartChanged?.call();

        // Applying is terminal for this sheet — a backend sheet would be
        // stacked on a route that's about to pop, so [show] presents it after.
        final isClosing =
            state.lastAction == PromoActionKind.apply &&
                (state.actionError == null || state.actionError!.isEmpty);
        final actionSheet = state.actionBottomSheet;

        if (isClosing) {
          if (actionSheet != null) onActionSheet?.call(actionSheet);
        } else if (actionSheet != null) {
          // Failure, or a remove that leaves the list open: stack it on top.
          showPromoActionSheet(context, actionSheet);
          return;
        }

        final error = state.actionError;
        if (error != null && error.isNotEmpty) {
          context.showSnack(error, status: SnackStatus.error);
          return;
        }
        final message = state.actionMessage;
        if (message != null && message.isNotEmpty) {
          context.showSnack(message, status: SnackStatus.success);
        }
        // The snack sits on the app's ScaffoldMessenger, so it outlives the pop.
        if (isClosing) Navigator.of(context, rootNavigator: true).pop();
      },
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.72,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                child: _SheetHeading(),
              ),
              Flexible(
                child: _SheetBody(
                  bottomPadding: bottomPadding,
                  onAction: onAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mutable carrier for the sheet's outcome, read by [PromoOffersBottomSheet.show]
/// after the route is gone.
class _SheetOutcome {
  bool cartChanged = false;
  String? deeplink;
  BackendActionContentEntity? actionSheet;
}

class _SheetHeading extends StatelessWidget {
  const _SheetHeading();

  @override
  Widget build(BuildContext context) {
    return Text(
      PromosOffersStrings.offers,
      key: const ValueKey(PromoOffersTestStrings.sheetTitle),
      style: AppTypographyV1.titleMedium.bold.textPrimary(),
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.bottomPadding, this.onAction});

  final double bottomPadding;
  final ValueChanged<String>? onAction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromosOffersBloc, PromosOffersState>(
      builder: (context, state) {
        switch (state.status) {
          case PromosOffersStatus.initial:
          case PromosOffersStatus.loading:
          // Card-shaped placeholders rather than a spinner, matching the
          // home page. `listShimmer` already pads 16 horizontally, the same
          // inset the real cards use.
            return LoadingShimmer.listShimmer(
              itemCount: 4,
              itemHeight: PromoOfferCard.approxHeight,
            );
          case PromosOffersStatus.error:
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              child: Center(
                child: Text(
                  state.errorMessage ?? CommonStrings.somethingWentWrong,
                  textAlign: TextAlign.center,
                  style: AppTypographyV1.bodySmall.regular.textSecondary(),
                ),
              ),
            );
          case PromosOffersStatus.success:
            final sections = state.sections;
            if (sections.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: EmptyStateWidget(
                  key: const ValueKey(PromoOffersTestStrings.emptyStateButton),
                  type: EmptyStateType.promosOffers,
                  onButtonTap: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                ),
              );
            }
            // Automation keys index offers flat across sections, so each
            // section needs the running count of everything before it.
            final sectionStarts = <int>[];
            var offerCount = 0;
            for (final section in sections) {
              sectionStarts.add(offerCount);
              offerCount += section.offers.length;
            }

            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: bottomPadding),
              itemCount: sections.length,
              separatorBuilder: (_, _) => const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.md,
                ),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border,
                ),
              ),
              itemBuilder: (_, i) => _Section(
                section: sections[i],
                startIndex: sectionStarts[i],
                pendingActionCode: state.pendingActionCode,
                onAction: onAction,
              ),
            );
        }
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.section,
    required this.startIndex,
    required this.pendingActionCode,
    this.onAction,
  });

  final PromoOfferSectionEntity section;

  /// Flat index of this section's first offer, for automation keys.
  final int startIndex;
  final String pendingActionCode;
  final ValueChanged<String>? onAction;

  /// Hand the deeplink to [PromoOffersBottomSheet.show] and close the sheet — it
  /// navigates once the route is gone, matching how home-page components hand
  /// their `actionUri` to `ActionUrlHandler`.
  void _openAction(BuildContext context, String actionUri) {
    onAction?.call(actionUri);
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isActionInProgress = pendingActionCode.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, offer) in section.offers.indexed) ...[
          if (i > 0) AppSpacing.verticalGapSm,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: _card(
              context,
              offer: offer,
              index: startIndex + i,
              isActionInProgress: isActionInProgress,
            ),
          ),
        ],
      ],
    );
  }

  Widget _card(
      BuildContext context, {
        required PromoOfferEntity offer,
        required int index,
        required bool isActionInProgress,
      }) {
    final cardKey = '${PromoOffersTestStrings.card}_$index';

    return PromoOfferCard(
      key: ValueKey(cardKey),
      offer: offer,
      isBusy: pendingActionCode == offer.code,
      isLocked: isActionInProgress && pendingActionCode != offer.code,
      onApply: () {
        final cartBloc = context.read<CartBloc>();
        final loggedIn = context.read<AccountBloc>().state.account.isLoggedIn;
        if (!loggedIn) {
          //* this needs testing will add in next release
          return;
        }
        context.read<PromosOffersBloc>().add(
          PromosOffersEvent.apply(offer.code),
        );
      },
      onRemove: () => context.read<PromosOffersBloc>().add(
        PromosOffersEvent.remove(offer.code),
      ),
      onAction: offer.hasAction
          ? () => _openAction(context, offer.actionUri!)
          : null,
      // "See terms" is a deeplink to the promo details page, so it closes the
      // sheet on the way out exactly like the card's own CTA.
      onViewTerms: offer.showTerms
          ? () => _openAction(context, offer.termsUri!)
          : null,
      codeKey: ValueKey('${cardKey}_${PromoOffersTestStrings.codeSuffix}'),
      applyButtonKey: ValueKey(
        '${cardKey}_${PromoOffersTestStrings.applyButtonSuffix}',
      ),
      removeButtonKey: ValueKey(
        '${cardKey}_${PromoOffersTestStrings.removeButtonSuffix}',
      ),
      termsKey: ValueKey(
        '${cardKey}_${PromoOffersTestStrings.termsButtonSuffix}',
      ),
      ctaKey: ValueKey('${cardKey}_${PromoOffersTestStrings.ctaButtonSuffix}'),
    );
  }
}