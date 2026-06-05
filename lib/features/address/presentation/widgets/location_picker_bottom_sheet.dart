import 'package:flutter/material.dart';

import '../../../../core/constants/strings/address_pincode_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/address_entity.dart';

/// Stub for the Android `LocationPickerBottomSheet` (Google Maps based).
///
/// Real map integration requires `google_maps_flutter` + iOS/Android API
/// keys + permission setup — none of which are present in this Flutter
/// project today. The bottom sheet currently shows an info notice and
/// returns `null` so the bloc state stays consistent. Replace the body
/// with the actual map widget once the maps dependency is wired up.
Future<AddressLocationEntity?> showLocationPickerBottomSheet(
  BuildContext context, {
  AddressLocationEntity? initial,
}) async {
  return showModalBottomSheet<AddressLocationEntity?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.baseDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AddressStrings.markItOnMap,
                style: AppTypographyV1.titleMedium.bold.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Map picker is not yet integrated in Flutter. '
                'Address will be saved without coordinates.',
                style: AppTypographyV1.bodyMedium.regular.textSecondary(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    AddressStrings.cancel,
                    style: AppTypographyV1.bodyLarge.semiBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
