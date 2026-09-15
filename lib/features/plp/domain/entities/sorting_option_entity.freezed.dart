// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sorting_option_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SortingOptionEntity {

 String? get label; int get orderRule; bool get isSelected;/// The analytics name for this option — `"PriceHighLow"` where [label] is
/// `"Price high to low"`. This is what `from_sort` / `new_sort` report on
/// `sorting_applied`; [label] is a display string and must not be sent.
/// (Distinct from `sort_order` on viewed events, which does use the
/// display name.)
///
/// The response sends this at the option's top level, alongside `label`
/// and `orderRule`. Sort options carry no `trackingMeta` blob — unlike
/// filters and products — so this field is the only analytics name here.
 String? get eventSortName;
/// Create a copy of SortingOptionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SortingOptionEntityCopyWith<SortingOptionEntity> get copyWith => _$SortingOptionEntityCopyWithImpl<SortingOptionEntity>(this as SortingOptionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingOptionEntity&&(identical(other.label, label) || other.label == label)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.eventSortName, eventSortName) || other.eventSortName == eventSortName));
}


@override
int get hashCode => Object.hash(runtimeType,label,orderRule,isSelected,eventSortName);

@override
String toString() {
  return 'SortingOptionEntity(label: $label, orderRule: $orderRule, isSelected: $isSelected, eventSortName: $eventSortName)';
}


}

/// @nodoc
abstract mixin class $SortingOptionEntityCopyWith<$Res>  {
  factory $SortingOptionEntityCopyWith(SortingOptionEntity value, $Res Function(SortingOptionEntity) _then) = _$SortingOptionEntityCopyWithImpl;
@useResult
$Res call({
 String? label, int orderRule, bool isSelected, String? eventSortName
});




}
/// @nodoc
class _$SortingOptionEntityCopyWithImpl<$Res>
    implements $SortingOptionEntityCopyWith<$Res> {
  _$SortingOptionEntityCopyWithImpl(this._self, this._then);

  final SortingOptionEntity _self;
  final $Res Function(SortingOptionEntity) _then;

/// Create a copy of SortingOptionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = freezed,Object? orderRule = null,Object? isSelected = null,Object? eventSortName = freezed,}) {
  return _then(_self.copyWith(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,orderRule: null == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,eventSortName: freezed == eventSortName ? _self.eventSortName : eventSortName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SortingOptionEntity].
extension SortingOptionEntityPatterns on SortingOptionEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SortingOptionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SortingOptionEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SortingOptionEntity value)  $default,){
final _that = this;
switch (_that) {
case _SortingOptionEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SortingOptionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SortingOptionEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? label,  int orderRule,  bool isSelected,  String? eventSortName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SortingOptionEntity() when $default != null:
return $default(_that.label,_that.orderRule,_that.isSelected,_that.eventSortName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? label,  int orderRule,  bool isSelected,  String? eventSortName)  $default,) {final _that = this;
switch (_that) {
case _SortingOptionEntity():
return $default(_that.label,_that.orderRule,_that.isSelected,_that.eventSortName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? label,  int orderRule,  bool isSelected,  String? eventSortName)?  $default,) {final _that = this;
switch (_that) {
case _SortingOptionEntity() when $default != null:
return $default(_that.label,_that.orderRule,_that.isSelected,_that.eventSortName);case _:
  return null;

}
}

}

/// @nodoc


class _SortingOptionEntity implements SortingOptionEntity {
  const _SortingOptionEntity({this.label, this.orderRule = 0, this.isSelected = false, this.eventSortName});
  

@override final  String? label;
@override@JsonKey() final  int orderRule;
@override@JsonKey() final  bool isSelected;
/// The analytics name for this option — `"PriceHighLow"` where [label] is
/// `"Price high to low"`. This is what `from_sort` / `new_sort` report on
/// `sorting_applied`; [label] is a display string and must not be sent.
/// (Distinct from `sort_order` on viewed events, which does use the
/// display name.)
///
/// The response sends this at the option's top level, alongside `label`
/// and `orderRule`. Sort options carry no `trackingMeta` blob — unlike
/// filters and products — so this field is the only analytics name here.
@override final  String? eventSortName;

/// Create a copy of SortingOptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SortingOptionEntityCopyWith<_SortingOptionEntity> get copyWith => __$SortingOptionEntityCopyWithImpl<_SortingOptionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SortingOptionEntity&&(identical(other.label, label) || other.label == label)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.eventSortName, eventSortName) || other.eventSortName == eventSortName));
}


@override
int get hashCode => Object.hash(runtimeType,label,orderRule,isSelected,eventSortName);

@override
String toString() {
  return 'SortingOptionEntity(label: $label, orderRule: $orderRule, isSelected: $isSelected, eventSortName: $eventSortName)';
}


}

/// @nodoc
abstract mixin class _$SortingOptionEntityCopyWith<$Res> implements $SortingOptionEntityCopyWith<$Res> {
  factory _$SortingOptionEntityCopyWith(_SortingOptionEntity value, $Res Function(_SortingOptionEntity) _then) = __$SortingOptionEntityCopyWithImpl;
@override @useResult
$Res call({
 String? label, int orderRule, bool isSelected, String? eventSortName
});




}
/// @nodoc
class __$SortingOptionEntityCopyWithImpl<$Res>
    implements _$SortingOptionEntityCopyWith<$Res> {
  __$SortingOptionEntityCopyWithImpl(this._self, this._then);

  final _SortingOptionEntity _self;
  final $Res Function(_SortingOptionEntity) _then;

/// Create a copy of SortingOptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = freezed,Object? orderRule = null,Object? isSelected = null,Object? eventSortName = freezed,}) {
  return _then(_SortingOptionEntity(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,orderRule: null == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,eventSortName: freezed == eventSortName ? _self.eventSortName : eventSortName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
