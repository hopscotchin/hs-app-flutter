import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_entity.freezed.dart';

@freezed
abstract class DetailEntity with _$DetailEntity {
  const factory DetailEntity({
    String? tabName,
    @Default([]) List<DetailItemEntity> items,
  }) = _DetailEntity;
}

/// A single item within a product detail tab.
/// Not @freezed — no code generation required.
class DetailItemEntity {
  const DetailItemEntity({
    this.type,
    this.span,
    this.displayKey,
    this.values = const [],
    this.displayStyle,
    this.showBullet,
    this.showDivider,
    this.fieldPath,
  });

  /// "keyValue" | "text" | "skuValue"
  final String? type;

  /// 1 = half-width column, 2 = full-width
  final int? span;

  final String? displayKey;
  final List<String> values;

  /// "block" | "inline"
  final String? displayStyle;

  final bool? showBullet;
  final bool? showDivider;

  /// Used by skuValue type to resolve field from selected SKU attributes.
  final String? fieldPath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailItemEntity &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          span == other.span &&
          displayKey == other.displayKey &&
          displayStyle == other.displayStyle &&
          showBullet == other.showBullet &&
          showDivider == other.showDivider &&
          fieldPath == other.fieldPath;

  @override
  int get hashCode => Object.hash(
        type,
        span,
        displayKey,
        displayStyle,
        showBullet,
        showDivider,
        fieldPath,
      );
}
