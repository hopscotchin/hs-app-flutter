import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/backend_action_entity.dart';

part 'promo_action_result_entity.freezed.dart';

/// Outcome of an apply / remove promo call.
@freezed
abstract class PromoActionResultEntity with _$PromoActionResultEntity {
  const factory PromoActionResultEntity({
    @Default(false) bool success,
    @Default('') String message,
    @Default('') String promoCode,

    /// Backend-authored bottom sheet to show instead of the toast — sent on
    /// either outcome (e.g. "Invalid promotion" with a "Got It" button).
    BackendActionContentEntity? bottomSheet,
  }) = _PromoActionResultEntity;
}

extension PromoActionResultEntityX on PromoActionResultEntity {
  bool get hasMessage => message.isNotEmpty;

  /// A sheet is only renderable with body copy — `AppBottomSheet` requires it.
  bool get hasBottomSheet =>
      bottomSheet?.description != null &&
      bottomSheet!.description!.isNotEmpty;
}