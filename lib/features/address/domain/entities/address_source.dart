/// Which backend endpoint to hit when fetching the address list.
///
/// - [delivery] → `/delivery/addresses/v3` (splash prefetch, checkout flow)
/// - [customer] → `/customer/v2/addresses` (account flow)
enum AddressSource { delivery, customer }