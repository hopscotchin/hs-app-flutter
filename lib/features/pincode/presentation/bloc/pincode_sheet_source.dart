/// Where the pincode bottom sheet was launched from. Drives post-selection
/// behavior (e.g. PDP skips serviceability check and runs its own
/// product-aware verifyPincode). Add new entry points here as they appear.
enum PincodeSheetSource { cart, pdp }