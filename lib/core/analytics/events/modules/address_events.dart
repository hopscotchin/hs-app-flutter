import '../../analytics_map.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// `address_updated` — the one address event Android fires. Ported from
/// `AnalyticsHelperKt.logAddressUpdatedEvent` (`AnalyticsHelperKt.kt:7-35`).
///
/// Called from three surfaces on Android — save on `ManageAddressActivity`
/// (create OR edit, both routes here with [isNewAddress] set) and delete on
/// `AddressListingActivity` (leaves [isNewAddress] null). The `address`
/// property only ships when [isNewAddress] is provided: `"New"` on create,
/// `"Updated"` on edit, absent on delete — which is how the dashboard
/// tells the three intents apart.
///
/// Fires across both Account and Checkout flows; the caller's [fromScreen]
/// carries the flow context (`FromScreens.account`, `FromScreens.shoppingCart`,
/// etc.). Attribution is off — Android passes `false` to `logEvent` here.
///
/// ⚠️ Android bug preserved: `delivery_available` is only stamped when
/// `isServicable == true`, so the wire only ever carries `"Yes"`. Mirror it —
/// dashboards read absence-as-not-serviceable.
extension AddressEvents on AnalyticsHelper {
  Future<void> logAddressUpdated({
    required String? fromScreen,
    required String? pincode,
    required String? deliveryCity,
    required bool isServiceable,
    required bool canCod,
    required bool isDefault,
    bool? isNewAddress,
  }) {
    final payload = <String, Object?>{}
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
      ..putAnalyticsKey(
        AnalyticsProperties.address,
        isNewAddress == null
            ? null
            : (isNewAddress
                  ? AnalyticsProperties.newValue
                  : AnalyticsProperties.updatedValue),
      )
      ..putAnalyticsKey(AnalyticsProperties.pincode, pincode)
      ..putAnalyticsKey(AnalyticsProperties.deliveryCity, deliveryCity);
    // ponytail: mirroring Android — key omitted when not serviceable.
    if (isServiceable) {
      payload[AnalyticsProperties.deliveryAvailable] = AnalyticsProperties.yes;
    }
    // Booleans always ship (Android writes them unconditionally).
    payload[AnalyticsProperties.codAvailable] = canCod;
    payload[AnalyticsProperties.defaultAddress] = isDefault;

    return logEvent(
      AnalyticsEvents.addressUpdated,
      payload,
      attribution: false,
    );
  }
}
