/// Where the pincode bottom sheet was launched from. Drives post-selection
/// behavior (e.g. PDP skips serviceability check and runs its own
/// product-aware verifyPincode). Add new entry points here as they appear.
///
/// [cart] and [pdp] are pincode-only (no address list). [checkout] is the
/// upcoming flow that lists saved addresses and shows a bottom action button —
/// not wired yet.
enum PincodeSheetSource { cart, pdp, checkout }