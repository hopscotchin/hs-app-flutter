import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_filter_entity.freezed.dart';

@freezed
abstract class QuickFilterEntity with _$QuickFilterEntity {
  const factory QuickFilterEntity({
    String? filterKey,
    String? label,
    @Default(false) bool isApplied,
    @Default(<String, dynamic>{}) Map<String, dynamic> trackingMeta,
  }) = _QuickFilterEntity;
}
