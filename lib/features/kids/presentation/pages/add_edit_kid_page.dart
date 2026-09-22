import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../components/atoms/outlined_text_field.dart';
import '../../../../components/buttons/app_button_named.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../components/form/app_checkbox.dart';
import '../../../../components/form/app_radio.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/config/environment.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/entities/message_bar_entity.dart';
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
        listenWhen: (prev, curr) =>
            prev.saved != curr.saved ||
            prev.submitError != curr.submitError ||
            prev.apiError != curr.apiError,
        listener: (context, state) {
          if (state.submitError != null) {
            context.showSnack(state.submitError!, status: SnackStatus.error);
            return;
          }
          if (state.saved != null) {
            context.showSnack(
              _isEdit
                  ? KidsStrings.editSuccessMessage
                  : KidsStrings.addSuccessMessage,
              status: SnackStatus.success,
            );
            Navigator.of(context).pop(state.saved);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.baseDefault,
          appBar: HsAppbar(
            title: _isEdit
                ? KidsStrings.editFormTitle
                : KidsStrings.addFormTitle,
            titleKey: const ValueKey(KidsTestStrings.formAppBarTitle),
            backButtonKey: const ValueKey(KidsTestStrings.formBackButton),
            onLeadingTap: () => _handleBack(context),
          ),
          body: SafeArea(
            top: false,
            child: BlocBuilder<ManageKidBloc, ManageKidState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.md,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEdit
                                  ? KidsStrings.editFormHeading
                                  : KidsStrings.formHeading,
                              style: AppTypographyV1.bodyLarge.bold
                                  .textPrimary(),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isEdit
                                  ? KidsStrings.editFormSubheading
                                  : KidsStrings.formSubheading,
                              style: AppTypographyV1.bodyRegular.regular
                                  .neutralGrey6(),
                            ),
                            if (state.apiError != null) ...[
                              AppSpacing.verticalGapLg,
                              _ApiErrorBanner(
                                title: KidsStrings.apiErrorBannerTitle,
                                subtitle: state.apiError!,
                              ),
                            ],
                            AppSpacing.verticalGapLg,
                            OutlinedTextField(
                              key: const ValueKey(
                                KidsTestStrings.formNameInput,
                              ),
                              hintTextKey: const ValueKey(
                                KidsTestStrings.formNameInputHint,
                              ),
                              controller: _nameController,
                              labelText: KidsStrings.nameLabel,
                              required: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z ]'),
                                ),
                              ],
                              onChanged: (v) => context
                                  .read<ManageKidBloc>()
                                  .add(ManageKidEvent.nameChanged(v)),
                            ),
                            AppSpacing.verticalGapMd,
                            _DobField(
                              key: const ValueKey(KidsTestStrings.formDobInput),
                              dob: state.dob,
                              // Existing child: use the backend's own
                              // server-formatted display string rather
                              // than reformatting `dob` client-side —
                              // there's no live user edit to reflect
                              // since the field is locked below anyway.
                              displayDobOverride: state.original?.displayDob,
                              // DOB looks read-only once a child exists per the
                              // current design (pending confirmation — see
                              // PROFILE_KIDS_API_CONTRACT.md §1 on DOB immutability).
                              enabled: !_isEdit,
                              onPicked: (date) => context
                                  .read<ManageKidBloc>()
                                  .add(ManageKidEvent.dobChanged(date)),
                            ),
                            AppSpacing.verticalGapMd,
                            Row(
                              children: [
                                Expanded(
                                  child: _GenderOption(
                                    radioKey: const ValueKey(
                                      KidsTestStrings.formGenderGirlRadio,
                                    ),
                                    isSelected:
                                        state.gender == ChildGender.girl,
                                    label: KidsStrings.genderGirl,
                                    // Gender is fixed once a child exists, same as DOB above.
                                    enabled: !_isEdit,
                                    onTap: () =>
                                        context.read<ManageKidBloc>().add(
                                          const ManageKidEvent.genderChanged(
                                            ChildGender.girl,
                                          ),
                                        ),
                                  ),
                                ),
                                AppSpacing.horizontalGapSm,
                                Expanded(
                                  child: _GenderOption(
                                    radioKey: const ValueKey(
                                      KidsTestStrings.formGenderBoyRadio,
                                    ),
                                    isSelected: state.gender == ChildGender.boy,
                                    label: KidsStrings.genderBoy,
                                    enabled: !_isEdit,
                                    onTap: () =>
                                        context.read<ManageKidBloc>().add(
                                          const ManageKidEvent.genderChanged(
                                            ChildGender.boy,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.verticalGapLg,
                            MessageBarsWidget(
                              keyPrefix: KidsTestStrings.formScreen,
                              cardStyle: true,
                              iconSize: (24, 24),
                              // Sized to match the design's subtitle
                              // (labelLarge) — MessageBarsWidget's own
                              // default is labelMedium.
                              textStyle: AppTypographyV1.labelLarge.regular
                                  .copyWith(color: AppColors.neutralGrey6),
                              messageBars: const [
                                MessageBarEntity(
                                  messageType: 'custom',
                                  hasIcon: true,
                                  icon: ImageConstants.shieldIcon,
                                  bgColor: '#E5E5EA', // AppColors.neutralGrey2
                                  textColor:
                                      '#353535', // AppColors.neutralGrey6
                                  title: KidsStrings.whyWeAskBannerTitle,
                                  text: KidsStrings.whyWeAskBannerSubtitle,
                                ),
                              ],
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
                            hasError: state.consentError,
                            consentText: KidsStrings.consentText,
                            privacyPolicyLabel: KidsStrings.viewPrivacyPolicy,
                            privacyPolicyUrl:
                                '${EnvironmentConfig.webBaseUrl}/${AuthStrings.privacyPath}${AuthStrings.legalUrlParams}',
                            onChanged: (v) => context.read<ManageKidBloc>().add(
                              ManageKidEvent.consentChanged(v),
                            ),
                          ),
                          AppSpacing.verticalGapMd,
                          PrimaryButton.defaultType(
                            key: const ValueKey(KidsTestStrings.formSaveButton),
                            text: _isEdit
                                ? KidsStrings.saveChangesButton
                                : KidsStrings.saveButton,
                            state: state.isSubmitting
                                ? ButtonState.loading
                                : (state.isFormComplete
                                      ? ButtonState.enabled
                                      : ButtonState.disabled),
                            onTap: state.isFormComplete
                                ? () => context.read<ManageKidBloc>().add(
                                    const ManageKidEvent.submit(),
                                  )
                                : null,
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
      descriptionKey: const ValueKey(
        KidsTestStrings.discardBottomSheetDescription,
      ),
      cancelKey: const ValueKey(KidsTestStrings.discardBottomSheetCancelButton),
      confirmKey: const ValueKey(
        KidsTestStrings.discardBottomSheetConfirmButton,
      ),
    );
    if (discard == true && context.mounted) Navigator.of(context).pop();
  }
}

/// Save-call failure banner — title and subtitle share one plain style and
/// flow as a single sentence, rather than a stacked title/subtitle block
/// with a forced line break between the two. Not built on
/// `MessageBarsWidget`: that component always renders its title and
/// message as two separate blocks with a fixed gap between them, which
/// can't produce this single-paragraph look without changing a widget
/// several other screens also rely on. Sits in the normal form layout
/// (pushing the fields below it down), not an overlay — and stays visible
/// until the next submit attempt clears `apiError` in `ManageKidBloc`,
/// rather than auto-dismissing on a timer.
class _ApiErrorBanner extends StatelessWidget {
  const _ApiErrorBanner({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.brandTertiary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomImage(
            path: ImageConstants.messageBarError,
            width: 20,
            height: 20,
          ),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$title. $subtitle',
                style: AppTypographyV1.labelMedium.regular.copyWith(
                  color: AppColors.neutralGrey6,
                ),
              ),
              key: const ValueKey(KidsTestStrings.formApiErrorBannerText),
            ),
          ),
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
    this.enabled = true,
  });

  final Key radioKey;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  // Locked (muted) options still keep their grey fill, but the selected one
  // now also keeps the brand-coloured border — matching the unlocked look —
  // so the box itself calls out which was selected, not just the radio dot.
  bool get _muted => !enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: _muted ? AppColors.neutralGrey2 : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (_muted ? AppColors.neutralGrey4 : AppColors.neutralGrey3),
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
            AppRadio(
              key: radioKey,
              isSelected: isSelected,
              isDisabled: _muted,
              onTap: enabled ? onTap : null,
            ),
            AppSpacing.horizontalGapXs,
            Text(
              label,
              style: _muted
                  ? AppTypographyV1.bodyRegular.regular.copyWith(
                      color: AppColors.neutralGrey6,
                    )
                  : AppTypographyV1.bodyRegular.regular.textPrimary(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DobField extends StatefulWidget {
  const _DobField({
    super.key,
    required this.dob,
    required this.enabled,
    required this.onPicked,
    this.displayDobOverride,
  });

  final DateTime? dob;
  final bool enabled;
  final ValueChanged<DateTime> onPicked;

  /// Server-formatted `"DD - MM - YYYY"` for an existing child — used
  /// verbatim instead of reformatting [dob] client-side. Only meaningful
  /// while [enabled] is false (an existing, locked child); a live user pick
  /// always falls back to [_displayFor].
  final String? displayDobOverride;

  @override
  State<_DobField> createState() => _DobFieldState();
}

class _DobFieldState extends State<_DobField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.displayDobOverride ?? _displayFor(widget.dob),
  );

  static String _displayFor(DateTime? dob) {
    if (dob == null) return '';
    final dd = dob.day.toString().padLeft(2, '0');
    final mm = dob.month.toString().padLeft(2, '0');
    return '$dd - $mm - ${dob.year}';
  }

  @override
  void didUpdateWidget(_DobField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dob != widget.dob) {
      _controller.text = widget.displayDobOverride ?? _displayFor(widget.dob);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      controller: _controller,
      labelText: KidsStrings.dobLabel,
      required: true,
      hintTextKey: const ValueKey(KidsTestStrings.formDobInputHint),
      readOnly: true,
      enabled: widget.enabled,
      // Matches _GenderOption's locked grey fill so both locked fields read
      // the same way once a child exists.
      fillColor: widget.enabled ? null : AppColors.neutralGrey2,
      onTap: !widget.enabled
          ? null
          : () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate:
                    widget.dob ?? DateTime(now.year - 1, now.month, now.day),
                firstDate: DateTime(now.year - 25),
                lastDate: now,
              );
              if (picked != null) widget.onPicked(picked);
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
    this.hasError = false,
  });

  final bool checked;
  final bool hasError;
  final String consentText;
  final String privacyPolicyLabel;
  final String privacyPolicyUrl;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          key: const ValueKey(KidsTestStrings.formConsentRow),
          behavior: HitTestBehavior.opaque,
          // Toggles on a tap anywhere in the row, including the consent text —
          // the nested privacy-policy link below has its own GestureDetector,
          // which wins the gesture arena over this one so its tap still opens
          // the link instead of toggling the checkbox.
          onTap: () => onChanged(!checked),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckbox(
                key: const ValueKey(KidsTestStrings.formConsentCheckbox),
                isSelected: checked,
                onChanged: onChanged,
                border: hasError
                    ? Border.all(color: AppColors.error, width: 1)
                    : null,
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
                        style: AppTypographyV1.bodyRegular.regular
                            .textPrimary(),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          key: const ValueKey(
                            KidsTestStrings.formConsentPrivacyLink,
                          ),
                          onTap: () => AppNavigator.goToWebView(
                            context,
                            url: privacyPolicyUrl,
                            title: AuthStrings.privacyPolicy,
                          ),
                          child: Text(
                            privacyPolicyLabel,
                            style: AppTypographyV1.labelMedium.bold.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          AppSpacing.verticalGapXxs,
          Padding(
            // Indented to align under the consent paragraph rather than the
            // checkbox — matches the checkbox width (AppCheckbox's fixed
            // 20px box) plus the gap before the text.
            padding: const EdgeInsets.only(left: 20 + AppSpacing.sm),
            child: Text(
              KidsStrings.consentRequiredError,
              key: const ValueKey(KidsTestStrings.formConsentErrorText),
              style: AppTypographyV1.labelMedium.regular.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
