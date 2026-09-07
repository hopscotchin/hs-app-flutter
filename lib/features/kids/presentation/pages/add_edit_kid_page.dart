import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../components/atoms/outlined_text_field.dart';
import '../../../../components/buttons/app_button_named.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../components/form/app_checkbox.dart';
import '../../../../components/form/app_radio.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../domain/entities/child_entity.dart';
import '../bloc/manage_kid_bloc.dart';
import '../widgets/kids_confirm_sheet.dart';

class AddEditKidPage extends StatefulWidget {
  const AddEditKidPage({super.key, this.existing});

  final ChildEntity? existing;

  @override
  State<AddEditKidPage> createState() => _AddEditKidPageState();
}

class _AddEditKidPageState extends State<AddEditKidPage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    context.read<ManageKidBloc>().add(ManageKidEvent.init(widget.existing));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.existing != null;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBack(context);
      },
      child: BlocListener<ManageKidBloc, ManageKidState>(
        listenWhen: (prev, curr) => prev.saved != curr.saved || prev.submitError != curr.submitError,
        listener: (context, state) {
          if (state.submitError != null) {
            context.showSnack(state.submitError!, status: SnackStatus.error);
            return;
          }
          if (state.saved != null) {
            context.showSnack(
              _isEdit ? KidsStrings.editSuccessMessage : KidsStrings.addSuccessMessage,
              status: SnackStatus.success,
            );
            Navigator.of(context).pop(state.saved);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.baseDefault,
          appBar: HsAppbar(
            title: _isEdit ? KidsStrings.editFormTitle : KidsStrings.addFormTitle,
            titleKey: const ValueKey(KidsTestStrings.formAppBarTitle),
            backButtonKey: const ValueKey(KidsTestStrings.formBackButton),
            onLeadingTap: () => _handleBack(context),
          ),
          body: SafeArea(
            top: false,
            child: BlocBuilder<ManageKidBloc, ManageKidState>(
              builder: (context, state) {
                if (state.config == null) {
                  return const _FormShimmer();
                }
                final config = state.config!;
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              config.heading,
                              style: AppTypographyV1.bodyLarge.bold.textPrimary(),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              config.subheading,
                              style: AppTypographyV1.bodyRegular.regular.neutralGrey6(),
                            ),
                            AppSpacing.verticalGapLg,
                            OutlinedTextField(
                              key: const ValueKey(KidsTestStrings.formNameInput),
                              hintTextKey: const ValueKey(KidsTestStrings.formNameInputHint),
                              controller: _nameController,
                              labelText: KidsStrings.nameLabel,
                              required: false,
                              onChanged: (v) =>
                                  context.read<ManageKidBloc>().add(ManageKidEvent.nameChanged(v)),
                            ),
                            AppSpacing.verticalGapMd,
                            _DobField(
                              key: const ValueKey(KidsTestStrings.formDobInput),
                              dob: state.dob,
                              // DOB looks read-only once a child exists per the
                              // current design (pending confirmation — see
                              // PROFILE_KIDS_API_CONTRACT.md §1 on DOB immutability).
                              enabled: !_isEdit,
                              onPicked: (date) =>
                                  context.read<ManageKidBloc>().add(ManageKidEvent.dobChanged(date)),
                            ),
                            AppSpacing.verticalGapMd,
                            Row(
                              children: [
                                Expanded(
                                  child: _GenderOption(
                                    radioKey: const ValueKey(KidsTestStrings.formGenderGirlRadio),
                                    isSelected: state.gender == ChildGender.girl,
                                    label: KidsStrings.genderGirl,
                                    onTap: () => context
                                        .read<ManageKidBloc>()
                                        .add(const ManageKidEvent.genderChanged(ChildGender.girl)),
                                  ),
                                ),
                                AppSpacing.horizontalGapSm,
                                Expanded(
                                  child: _GenderOption(
                                    radioKey: const ValueKey(KidsTestStrings.formGenderBoyRadio),
                                    isSelected: state.gender == ChildGender.boy,
                                    label: KidsStrings.genderBoy,
                                    onTap: () => context
                                        .read<ManageKidBloc>()
                                        .add(const ManageKidEvent.genderChanged(ChildGender.boy)),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.verticalGapLg,
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: config.bannerBackgroundColor,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                                border: Border.all(color: AppColors.neutralGrey2, width: 0.5),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CustomImage(
                                    path: ImageConstants.shieldIcon,
                                    width: 24,
                                    height: 24,
                                  ),
                                  AppSpacing.horizontalGapSm,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          config.bannerTitle,
                                          style: AppTypographyV1.labelLarge.bold.neutralGrey6(),
                                        ),
                                        Text(
                                          config.bannerSubtitle,
                                          style: AppTypographyV1.labelLarge.regular.neutralGrey6(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.verticalGapMd,
                          ],
                        ),
                      ),
                    ),
                    // Consent + Save are pinned to the bottom of the screen
                    // (not part of the scroll content) — matches the Figma
                    // layout, where these sit fixed at the bottom regardless
                    // of how much space the fields above take up.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.sm,
                        AppSpacing.md,
                        AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ConsentRow(
                            checked: state.consentGiven,
                            consentText: config.consentText,
                            privacyPolicyLabel: config.viewPrivacyPolicyLabel,
                            privacyPolicyUrl: config.viewPrivacyPolicyUrl,
                            onChanged: (v) =>
                                context.read<ManageKidBloc>().add(ManageKidEvent.consentChanged(v)),
                          ),
                          AppSpacing.verticalGapMd,
                          PrimaryButton.defaultType(
                            key: const ValueKey(KidsTestStrings.formSaveButton),
                            text: _isEdit ? KidsStrings.saveChangesButton : KidsStrings.saveButton,
                            state: state.isSubmitting ? ButtonState.loading : ButtonState.enabled,
                            onTap: () => context.read<ManageKidBloc>().add(const ManageKidEvent.submit()),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleBack(BuildContext context) async {
    final isDirty = context.read<ManageKidBloc>().state.isDirty;
    if (!isDirty) {
      Navigator.of(context).pop();
      return;
    }
    final discard = await KidsConfirmSheet.show(
      context,
      title: KidsStrings.discardChangesTitle,
      description: KidsStrings.discardChangesDescription,
      cancelLabel: KidsStrings.discardChangesCancel,
      confirmLabel: KidsStrings.discardChangesConfirm,
      titleKey: const ValueKey(KidsTestStrings.discardBottomSheetTitle),
      descriptionKey: const ValueKey(KidsTestStrings.discardBottomSheetDescription),
      cancelKey: const ValueKey(KidsTestStrings.discardBottomSheetCancelButton),
      confirmKey: const ValueKey(KidsTestStrings.discardBottomSheetConfirmButton),
    );
    if (discard == true && context.mounted) Navigator.of(context).pop();
  }
}

/// Skeleton shown while `state.config` is loading — shaped to roughly
/// mirror the real form below it, matching the shimmer convention used
/// elsewhere in the app (e.g. KidsPage's list loading state) instead of a
/// bare spinner.
class _FormShimmer extends StatelessWidget {
  const _FormShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingShimmer(height: 20, width: 220),
          const SizedBox(height: 10),
          const LoadingShimmer(height: 16, width: 280),
          AppSpacing.verticalGapLg,
          const LoadingShimmer(height: 52),
          AppSpacing.verticalGapMd,
          const LoadingShimmer(height: 52),
          AppSpacing.verticalGapMd,
          Row(
            children: [
              Expanded(child: LoadingShimmer(height: 48, borderRadius: BorderRadius.circular(8))),
              AppSpacing.horizontalGapSm,
              Expanded(child: LoadingShimmer(height: 48, borderRadius: BorderRadius.circular(8))),
            ],
          ),
          AppSpacing.verticalGapLg,
          const LoadingShimmer(height: 64),
        ],
      ),
    );
  }
}

/// Boy/Girl option — a bordered box around the radio (Figma shows each
/// gender choice inside its own outlined rectangle, not a bare inline radio;
/// the border highlights purple when selected).
class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.radioKey,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  final Key radioKey;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutralGrey3,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        // Built from the unlabeled AppRadio + a plain Text, rather than
        // AppRadio.labeled — that variant's label sits in an Expanded, which
        // stretches to fill the row and left-packs the content; centering
        // the box means the radio+label cluster itself needs to center,
        // not stretch.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppRadio(key: radioKey, isSelected: isSelected, onTap: onTap),
            AppSpacing.horizontalGapXs,
            Text(label, style: AppTypographyV1.bodyRegular.regular.textPrimary()),
          ],
        ),
      ),
    );
  }
}

class _DobField extends StatelessWidget {
  const _DobField({
    super.key,
    required this.dob,
    required this.enabled,
    required this.onPicked,
  });

  final DateTime? dob;
  final bool enabled;
  final ValueChanged<DateTime> onPicked;

  String get _display {
    if (dob == null) return '';
    final dd = dob!.day.toString().padLeft(2, '0');
    final mm = dob!.month.toString().padLeft(2, '0');
    return '$dd - $mm - ${dob!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      controller: TextEditingController(text: _display),
      labelText: KidsStrings.dobLabel,
      required: false,
      hintTextKey: const ValueKey(KidsTestStrings.formDobInputHint),
      readOnly: true,
      enabled: enabled,
      onTap: !enabled
          ? null
          : () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: dob ?? DateTime(now.year - 1, now.month, now.day),
                firstDate: DateTime(now.year - 25),
                lastDate: now,
              );
              if (picked != null) onPicked(picked);
            },
    );
  }
}

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.checked,
    required this.consentText,
    required this.privacyPolicyLabel,
    required this.privacyPolicyUrl,
    required this.onChanged,
  });

  final bool checked;
  final String consentText;
  final String privacyPolicyLabel;
  final String privacyPolicyUrl;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            AppCheckbox(
              key: const ValueKey(KidsTestStrings.formConsentCheckbox),
              isSelected: checked,
              onChanged: onChanged,
            ),
            AppSpacing.horizontalGapSm,
            Expanded(
              // Text.rich instead of Wrap: the privacy-policy link needs to
              // flow inline as part of the same paragraph (joining the last
              // line of the consent text when there's room), not sit as its
              // own atomic block that Wrap can drop to a separate line.
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$consentText ',
                      style: AppTypographyV1.bodyRegular.regular.textPrimary(),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: GestureDetector(
                        key: const ValueKey(KidsTestStrings.formConsentPrivacyLink),
                        onTap: () => AppNavigator.goToWebView(
                          context,
                          url: privacyPolicyUrl,
                          title: AuthStrings.privacyPolicy,
                        ),
                        child: Text(
                          privacyPolicyLabel,
                          style: AppTypographyV1.labelMedium.bold.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
