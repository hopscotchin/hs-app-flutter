import 'package:freezed_annotation/freezed_annotation.dart';

part 'pincode_check_entity.freezed.dart';

/// Response from `GET /products/pincode` — tells us whether a pincode is
/// serviceable and what the estimated delivery message should be.
///
/// Mirrors Android's `PinCodeCheckResponse` (see hs-app-android
/// `plpfilters/domain/model/PinCodeCheckResponse.kt`).
///
/// The `serviceable` flag is the gate the UI cares about:
///   • true  → pincode accepted, refresh the filter list with the new
///             pincode so the Delivery section re-renders.
///   • false → show `noPinCodeMessage` as an inline / dialog error.
@freezed
abstract class PincodeCheckEntity with _$PincodeCheckEntity {
  const factory PincodeCheckEntity({
    @Default(false) bool serviceable,
    @Default(false) bool codAvailable,
    String? edd,
    String? eddPrefix,
    String? eddSuffix,
    String? eddSecondaryMsg,
    String? eddColor,
    String? eddTextColor,
    String? noPinCodeMessage,
  }) = _PincodeCheckEntity;
}
