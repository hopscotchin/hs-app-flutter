import 'package:freezed_annotation/freezed_annotation.dart';

part 'sorting_option_entity.freezed.dart';

@freezed
abstract class SortingOptionEntity with _$SortingOptionEntity {
  const factory SortingOptionEntity({
    String? label,
    @Default(0) int orderRule,
    @Default(false) bool isSelected,

    /// The analytics name for this option — `"PriceHighLow"` where [label] is
    /// `"Price high to low"`. This is what `from_sort` / `new_sort` report on
    /// `sorting_applied`; [label] is a display string and must not be sent.
    /// (Distinct from `sort_order` on viewed events, which does use the
    /// display name.)
    ///
    /// The response sends this at the option's top level, alongside `label`
    /// and `orderRule`. Sort options carry no `trackingMeta` blob — unlike
    /// filters and products — so this field is the only analytics name here.
    String? eventSortName,
  }) = _SortingOptionEntity;
}
