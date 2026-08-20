import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/atoms/auto_semantics.dart';
import '../../../../components/page_components/icon_label_info_row.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../pincode/presentation/widgets/pincode_bottom_sheet.dart';
import '../../domain/entities/edd_info_entity.dart';
import '../../domain/entities/service_guarantee_entity.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────
const _kCardBg = Color(0xFFF6F6F6);
const _kCardRadius = 10.0;

class PdpDeliveryInfo extends StatelessWidget {
  const PdpDeliveryInfo({
    super.key,
    this.eddInfo,
    this.serviceGuarantees = const [],
    this.pinCode,
    this.onVerifyPincode,
    this.onSheetOpened,
    this.isSizeSelected = false,
    this.isSoldOut = false,
  });

  final EddInfoEntity? eddInfo;
  final List<ServiceGuaranteeEntity> serviceGuarantees;
  final String? pinCode;
  final Future<PincodeVerifyResult> Function(String pincode)? onVerifyPincode;

  /// Fires when the pincode sheet is opened — `pincode_form_opened`
  /// (Android `EddInfoView.kt:37`).
  final VoidCallback? onSheetOpened;

  /// Whether a size (SKU) has been chosen — drives the contextual delivery-date
  /// prompt, matching Android's isSkuSelected gate.
  final bool isSizeSelected;

  /// Hides the whole delivery section when the product is sold out (Android
  /// hides both the EDD/pincode layout and the service-guarantee row).
  final bool isSoldOut;

  bool get _hasPincode => pinCode != null && pinCode!.isNotEmpty;
  bool get _hasDestination => eddInfo?.destination?.isNotEmpty ?? false;
  bool get _isPincodeSet => _hasPincode || _hasDestination;

  /// Second line of the EDD row — the real order SLA once both size and pincode
  /// are known, otherwise a prompt guiding the user to supply what's missing.
  /// Mirrors Android EddInfoView.getMessage3.
  String get _deliveryPromptLine {
    if (isSizeSelected && _isPincodeSet) return eddInfo?.orderSla ?? '';
    if (!isSizeSelected && !_isPincodeSet) return PdpStrings.selectPincodeAndSize;
    if (isSizeSelected && !_isPincodeSet) return PdpStrings.enterPincodeForDelivery;
    return PdpStrings.selectSizeForDelivery;
  }

  Future<void> _openPincodeSheet(BuildContext context) async {
    onSheetOpened?.call();
    // Apply: the sheet verifies in-place (loader) and pops with null.
    // Proceed/address selection: the sheet pops with the pincode, verified here.
    final result = await PincodeBottomSheet.show(
      context,
      source: PincodeSheetSource.pdp,
      onPdpVerify: onVerifyPincode,
    );
    if (result != null) await onVerifyPincode?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    // Sold-out products show no delivery section at all (matches Android).
    if (isSoldOut) return const SizedBox.shrink();

    final eddText = eddInfo?.edd ?? '';
    final promptLine = _deliveryPromptLine;
    // The EDD row always shows unless there's genuinely nothing to display
    // (no date and no prompt — e.g. size + pincode set but server returned none).
    final showEddRow = eddText.isNotEmpty || promptLine.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section title ──────────────────────────────────────────────────
          Text(
            PdpStrings.deliveryAvailability,
            key: const ValueKey(PdpTestStrings.deliveryTitle),
            style: AppTypographyV1.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
              height: 1.0,
            ),
          ),

          AppSpacing.verticalGapLgMd,

          // ── Card ───────────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: _kCardBg,
              borderRadius: BorderRadius.all(Radius.circular(_kCardRadius)),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // EDD row — inset a further 20px (Figma row width = card − 80).
                if (showEddRow) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _EddRow(eddText: eddText, promptLine: promptLine),
                  ),
                  AppSpacing.verticalGapSm,
                  // Divider is wider than the rows (Figma width = card − 64).
                  const Divider(
                    key: ValueKey(PdpTestStrings.deliveryDivider),
                    height: 1,
                    thickness: 1,
                    color: Color(0x0D000000),
                    indent: 12,
                    endIndent: 12,
                  ),
                  AppSpacing.verticalGapSm,
                ],
                // Pincode row — tapping always opens the bottom sheet.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _hasDestination
                      ? _PincodeDisplay(
                          rowKey: const ValueKey(PdpTestStrings.changePincodeButton),
                          label: eddInfo!.destination!,
                          onTap: () => _openPincodeSheet(context),
                        )
                      : _hasPincode
                      ? _PincodeDisplay(
                          rowKey: const ValueKey(PdpTestStrings.changePincodeButton),
                          label: pinCode!,
                          onTap: () => _openPincodeSheet(context),
                        )
                      : _EnterPincodeRow(
                          buttonKey: const ValueKey(PdpTestStrings.enterPincodeButton),
                          onTap: () => _openPincodeSheet(context),
                        ),
                ),
              ],
            ),
          ),

          // ── Service guarantees ─────────────────────────────────────────────
          if (serviceGuarantees.isNotEmpty) ...[
            AppSpacing.verticalGapLgMd,
            IconLabelInfoRow(
              items: [
                for (final g in serviceGuarantees.take(3))
                  IconLabelInfo(icon: g.icon, label: g.label),
              ],
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── EDD row ───────────────────────────────────────────────────────────────────

class _EddRow extends StatelessWidget {
  const _EddRow({required this.eddText, required this.promptLine});

  /// Estimated delivery date (may be empty before a pincode is set).
  final String eddText;

  /// SLA or the contextual "enter pincode / select size" prompt.
  final String promptLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AppSpacing.lg,
          height: AppSpacing.lg,
          child: Center(
            child: SvgPicture.asset(
              ImageConstants.pdpPincodeInfo,
              width: AppSpacing.iconMd,
              height: AppSpacing.iconMd,
              colorFilter: const ColorFilter.mode(AppColors.brandDefault, BlendMode.srcIn),
            ),
          ),
        ),
        AppSpacing.horizontalGapMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eddText.isNotEmpty)
                Text(
                  eddText,
                  style: AppTypographyV1.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandDefault,
                    height: 1.0,
                  ),
                ),
              if (promptLine.isNotEmpty) ...[
                if (eddText.isNotEmpty) const SizedBox(height: 8),
                Text(
                  promptLine,
                  style: AppTypographyV1.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 14 / 10,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Pincode display row ───────────────────────────────────────────────────────

class _PincodeDisplay extends StatelessWidget {
  const _PincodeDisplay({required this.label, required this.onTap, this.rowKey});
  final String label;
  final VoidCallback onTap;
  final Key? rowKey;

  @override
  Widget build(BuildContext context) {
    // Same reasoning as _EnterPincodeRow: the delivery block merges into one
    // node, so this needs its own or `pincode_form_opened` is undrivable once a
    // pincode is already set.
    return AutoSemantics.fromKey(
      rowKey,
      container: true,
      child: GestureDetector(
        key: rowKey,
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypographyV1.bodyRegular.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
                height: 19 / 14,
              ),
            ),
            Text(
              PdpStrings.change,
              style: AppTypographyV1.bodyRegular.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.brandDefault,
                height: 19 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Enter pincode row (no pincode set yet) ────────────────────────────────────

class _EnterPincodeRow extends StatelessWidget {
  const _EnterPincodeRow({required this.onTap, this.buttonKey});
  final VoidCallback onTap;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    // container: true — this row owns two labelled Texts ("Enter Pincode" and
    // "Check"), and Android merges the whole delivery block into ONE node, which
    // loses an annotated identifier. Without a dedicated node there is nothing
    // addressable here at all: the merged label is the entire section, so
    // `pincode_form_opened` and `pincode_change` cannot be driven.
    return AutoSemantics.fromKey(
      buttonKey,
      container: true,
      child: GestureDetector(
        key: buttonKey,
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              PdpStrings.enterPincode,
              style: AppTypographyV1.bodyRegular.copyWith(
                fontWeight: FontWeight.w400,
                color: const Color(0x80000000),
                height: 19 / 14,
              ),
            ),
            Text(
              PdpStrings.check,
              style: AppTypographyV1.bodyRegular.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.brandDefault,
                height: 19 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
