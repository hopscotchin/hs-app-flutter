import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../domain/entities/child_entity.dart';
import '../bloc/kids_bloc.dart';
import '../widgets/kid_item_card.dart';
import '../widgets/kids_confirm_sheet.dart';

class KidsPage extends StatelessWidget {
  const KidsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(
        title: KidsStrings.title,
        titleKey: const ValueKey(KidsTestStrings.listAppBarTitle),
        backButtonKey: const ValueKey(KidsTestStrings.listBackButton),
      ),
      body: SafeArea(
        top: false,
        child: BlocListener<KidsBloc, KidsState>(
          listenWhen: (prev, curr) =>
              curr.deleteSuccessMessage != prev.deleteSuccessMessage ||
              curr.deleteError != prev.deleteError,
          listener: (context, state) {
            final msg = state.deleteSuccessMessage ?? state.deleteError;
            if (msg == null) return;
            context.showSnack(
              msg,
              status: state.deleteError != null
                  ? SnackStatus.error
                  : SnackStatus.success,
            );
            context.read<KidsBloc>().add(const ClearDeleteFeedback());
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<KidsBloc, KidsState>(
                  builder: (context, state) {
                    if (state.status == KidsStatus.loading ||
                        state.status == KidsStatus.initial) {
                      return LoadingShimmer.listShimmer(
                        itemCount: 5,
                        itemHeight: 88,
                      );
                    }

                    if (state.status == KidsStatus.error) {
                      return ErrorRetryWidget(
                        message:
                            state.errorMessage ??
                            CommonStrings.somethingWentWrong,
                        onRetry: () =>
                            context.read<KidsBloc>().add(const LoadChildren()),
                      );
                    }

                    final content = state.effectiveContent;

                    if (state.children.isEmpty) {
                      // Button is intentionally suppressed here (buttonLabel: '')
                      // — the persistent _AddChildFooter below is the single CTA
                      // for both empty and populated states, matching Figma
                      // (a two-avatar "Add child" row, not this widget's own
                      // generic button). Title/subtitle are backend-driven; the
                      // baby illustration icon stays the type's local default.
                      return EmptyStateWidget(
                        type: EmptyStateType.kidsProfile,
                        title: content.emptyStateTitle,
                        subtitle: content.emptyStateSubtitle,
                        buttonLabel: '',
                        titleKey: const ValueKey(
                          KidsTestStrings.listEmptyTitle,
                        ),
                        subtitleKey: const ValueKey(
                          KidsTestStrings.listEmptySubtitle,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                          child: _KidsBanner(
                            title: content.bannerTitle,
                            subtitle: content.bannerSubtitle,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              top: AppSpacing.sm,
                              bottom: AppSpacing.md,
                              left: AppSpacing.xxs,
                              right: AppSpacing.xxs,
                            ),
                            itemCount: state.children.length,
                            itemBuilder: (context, i) {
                              final child = state.children[i];
                              return KidItemCard(
                                key: ValueKey('${KidsTestStrings.listItem}_$i'),
                                nameKey: ValueKey(
                                  '${KidsTestStrings.listItem}_${i}_${KidsTestStrings.listItemNameSuffix}',
                                ),
                                editKey: ValueKey(
                                  '${KidsTestStrings.listItem}_${i}_${KidsTestStrings.listItemEditSuffix}',
                                ),
                                removeKey: ValueKey(
                                  '${KidsTestStrings.listItem}_${i}_${KidsTestStrings.listItemRemoveSuffix}',
                                ),
                                child: child,
                                isRemoving: state.deletingId == child.id,
                                onEdit: () => _onEditKid(context, child),
                                onRemove: () => _confirmRemove(context, child),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              BlocBuilder<KidsBloc, KidsState>(
                buildWhen: (prev, curr) =>
                    prev.children.length != curr.children.length ||
                    prev.content != curr.content,
                builder: (context, state) {
                  if (state.status != KidsStatus.success) {
                    return const SizedBox.shrink();
                  }
                  // No max-children limit — dropped per product decision
                  // (see PROFILE_KIDS_API_CONTRACT.md history); always enabled.
                  final content = state.effectiveContent;
                  return _AddChildFooter(
                    label: state.children.isEmpty
                        ? content.addChildLabel
                        : content.addAnotherChildLabel,
                    subtitle: content.addChildSubtitle,
                    avatars: content.footerAvatars,
                    enabled: true,
                    onTap: () => _onAddKid(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAddKid(BuildContext context) async {
    final bloc = context.read<KidsBloc>();
    final saved = await AppNavigator.goToAddKid(context);
    if (saved != null) bloc.add(const RefreshChildren());
  }

  Future<void> _onEditKid(BuildContext context, ChildEntity child) async {
    final bloc = context.read<KidsBloc>();
    final saved = await AppNavigator.goToAddKid(context, existing: child);
    if (saved != null) bloc.add(const RefreshChildren());
  }

  Future<void> _confirmRemove(BuildContext context, ChildEntity child) async {
    final bloc = context.read<KidsBloc>();
    final confirmed = await KidsConfirmSheet.show(
      context,
      title: KidsStrings.deleteConfirmTitle,
      description: KidsStrings.deleteConfirmDescription,
      cancelLabel: CommonStrings.cancel,
      confirmLabel: KidsStrings.deleteConfirmButton,
      titleKey: const ValueKey(KidsTestStrings.deleteBottomSheetTitle),
      descriptionKey: const ValueKey(
        KidsTestStrings.deleteBottomSheetDescription,
      ),
      cancelKey: const ValueKey(KidsTestStrings.deleteBottomSheetCancelButton),
      confirmKey: const ValueKey(
        KidsTestStrings.deleteBottomSheetConfirmButton,
      ),
    );

    if (confirmed == true) bloc.add(DeleteChild(child.id));
  }
}

/// "We'll remember their details" info banner — shown only above a
/// populated list, not on the empty state (matches Figma).
class _KidsBanner extends StatelessWidget {
  const _KidsBanner({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutralGrey2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: AppColors.baseDefault, width: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            key: const ValueKey(KidsTestStrings.listBannerTitle),
            style: AppTypographyV1.bodyRegular.bold.textPrimary(),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            key: const ValueKey(KidsTestStrings.listBannerSubtitle),
            style: AppTypographyV1.labelLarge.regular.neutralGrey6(),
          ),
        ],
      ),
    );
  }
}

/// Persistent "Add child" / "Add another child" row — the one CTA shared by
/// both the empty and populated My Kids states (Figma: two overlapping
/// preview avatars, title + subtitle, circular purple "+" button).
class _AddChildFooter extends StatelessWidget {
  const _AddChildFooter({
    required this.label,
    required this.subtitle,
    required this.avatars,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String subtitle;

  /// The two overlapping preview circles' image URLs (backend-driven);
  /// a null entry renders the local generic-person placeholder instead.
  final List<String?> avatars;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GestureDetector(
        key: const ValueKey(KidsTestStrings.listAddButton),
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.neutralGrey1,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 32,
                  child: Stack(
                    children: [
                      _previewAvatar(
                        left: 0,
                        imageUrl: avatars.elementAtOrNull(0),
                      ),
                      _previewAvatar(
                        left: 16,
                        imageUrl: avatars.elementAtOrNull(1),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontalGapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTypographyV1.bodyRegular.bold.textPrimary(),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypographyV1.labelLarge.medium.neutralGrey6(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _previewAvatar({required double left, String? imageUrl}) {
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    return Positioned(
      left: left,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.neutralGrey3,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.baseDefault, width: 1.5),
          image: hasImage
              ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: hasImage
            ? null
            : const Icon(Icons.person, size: 16, color: AppColors.neutralGrey5),
      ),
    );
  }
}
