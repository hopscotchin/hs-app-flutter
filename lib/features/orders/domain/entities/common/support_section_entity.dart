import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/backend_action_entity.dart';

part 'support_section_entity.freezed.dart';

/// The support footer: a heading and its buttons.
///
/// The buttons are ordinary [BackendActionButtonEntity]s carrying a
/// [BackendActionType] and no `actionUri` — `CALL_US` and `HELP_CENTER` name
/// behaviours the app owns rather than destinations, which is why the contract
/// marks the whole block *app-config, not this endpoint*: it is identical on
/// every orders screen and the dialer number is not a property of any order.
///
/// Android hard-codes the heading from `R.string.need_help_with_your_orders`
/// and wires the dialer inside the adapter (`OrdersListingAdapter.kt:63-73`).
/// Both move to config.
@freezed
abstract class SupportSectionEntity with _$SupportSectionEntity {
  const factory SupportSectionEntity({
    String? title,
    @Default(<BackendActionButtonEntity>[])
    List<BackendActionButtonEntity> ctaActions,
  }) = _SupportSectionEntity;
}
