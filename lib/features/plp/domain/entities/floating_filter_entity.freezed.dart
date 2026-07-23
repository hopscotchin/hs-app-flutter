// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floating_filter_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FloatingFilterChipEntity {

 String? get filterKey; String? get filterValue; String? get label; String? get chipType; String? get textColor; String? get backgroundColor; String? get imageUrl; bool get isSelected;
/// Create a copy of FloatingFilterChipEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloatingFilterChipEntityCopyWith<FloatingFilterChipEntity> get copyWith => _$FloatingFilterChipEntityCopyWithImpl<FloatingFilterChipEntity>(this as FloatingFilterChipEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloatingFilterChipEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.label, label) || other.label == label)&&(identical(other.chipType, chipType) || other.chipType == chipType)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,filterValue,label,chipType,textColor,backgroundColor,imageUrl,isSelected);

@override
String toString() {
  return 'FloatingFilterChipEntity(filterKey: $filterKey, filterValue: $filterValue, label: $label, chipType: $chipType, textColor: $textColor, backgroundColor: $backgroundColor, imageUrl: $imageUrl, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $FloatingFilterChipEntityCopyWith<$Res>  {
  factory $FloatingFilterChipEntityCopyWith(FloatingFilterChipEntity value, $Res Function(FloatingFilterChipEntity) _then) = _$FloatingFilterChipEntityCopyWithImpl;
@useResult
$Res call({
 String? filterKey, String? filterValue, String? label, String? chipType, String? textColor, String? backgroundColor, String? imageUrl, bool isSelected
});




}
/// @nodoc
class _$FloatingFilterChipEntityCopyWithImpl<$Res>
    implements $FloatingFilterChipEntityCopyWith<$Res> {
  _$FloatingFilterChipEntityCopyWithImpl(this._self, this._then);

  final FloatingFilterChipEntity _self;
  final $Res Function(FloatingFilterChipEntity) _then;

/// Create a copy of FloatingFilterChipEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterKey = freezed,Object? filterValue = freezed,Object? label = freezed,Object? chipType = freezed,Object? textColor = freezed,Object? backgroundColor = freezed,Object? imageUrl = freezed,Object? isSelected = null,}) {
  return _then(_self.copyWith(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,chipType: freezed == chipType ? _self.chipType : chipType // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FloatingFilterChipEntity].
extension FloatingFilterChipEntityPatterns on FloatingFilterChipEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloatingFilterChipEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloatingFilterChipEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloatingFilterChipEntity value)  $default,){
final _that = this;
switch (_that) {
case _FloatingFilterChipEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloatingFilterChipEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FloatingFilterChipEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? filterKey,  String? filterValue,  String? label,  String? chipType,  String? textColor,  String? backgroundColor,  String? imageUrl,  bool isSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloatingFilterChipEntity() when $default != null:
return $default(_that.filterKey,_that.filterValue,_that.label,_that.chipType,_that.textColor,_that.backgroundColor,_that.imageUrl,_that.isSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? filterKey,  String? filterValue,  String? label,  String? chipType,  String? textColor,  String? backgroundColor,  String? imageUrl,  bool isSelected)  $default,) {final _that = this;
switch (_that) {
case _FloatingFilterChipEntity():
return $default(_that.filterKey,_that.filterValue,_that.label,_that.chipType,_that.textColor,_that.backgroundColor,_that.imageUrl,_that.isSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? filterKey,  String? filterValue,  String? label,  String? chipType,  String? textColor,  String? backgroundColor,  String? imageUrl,  bool isSelected)?  $default,) {final _that = this;
switch (_that) {
case _FloatingFilterChipEntity() when $default != null:
return $default(_that.filterKey,_that.filterValue,_that.label,_that.chipType,_that.textColor,_that.backgroundColor,_that.imageUrl,_that.isSelected);case _:
  return null;

}
}

}

/// @nodoc


class _FloatingFilterChipEntity implements FloatingFilterChipEntity {
  const _FloatingFilterChipEntity({this.filterKey, this.filterValue, this.label, this.chipType, this.textColor, this.backgroundColor, this.imageUrl, this.isSelected = false});
  

@override final  String? filterKey;
@override final  String? filterValue;
@override final  String? label;
@override final  String? chipType;
@override final  String? textColor;
@override final  String? backgroundColor;
@override final  String? imageUrl;
@override@JsonKey() final  bool isSelected;

/// Create a copy of FloatingFilterChipEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloatingFilterChipEntityCopyWith<_FloatingFilterChipEntity> get copyWith => __$FloatingFilterChipEntityCopyWithImpl<_FloatingFilterChipEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloatingFilterChipEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.label, label) || other.label == label)&&(identical(other.chipType, chipType) || other.chipType == chipType)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,filterValue,label,chipType,textColor,backgroundColor,imageUrl,isSelected);

@override
String toString() {
  return 'FloatingFilterChipEntity(filterKey: $filterKey, filterValue: $filterValue, label: $label, chipType: $chipType, textColor: $textColor, backgroundColor: $backgroundColor, imageUrl: $imageUrl, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$FloatingFilterChipEntityCopyWith<$Res> implements $FloatingFilterChipEntityCopyWith<$Res> {
  factory _$FloatingFilterChipEntityCopyWith(_FloatingFilterChipEntity value, $Res Function(_FloatingFilterChipEntity) _then) = __$FloatingFilterChipEntityCopyWithImpl;
@override @useResult
$Res call({
 String? filterKey, String? filterValue, String? label, String? chipType, String? textColor, String? backgroundColor, String? imageUrl, bool isSelected
});




}
/// @nodoc
class __$FloatingFilterChipEntityCopyWithImpl<$Res>
    implements _$FloatingFilterChipEntityCopyWith<$Res> {
  __$FloatingFilterChipEntityCopyWithImpl(this._self, this._then);

  final _FloatingFilterChipEntity _self;
  final $Res Function(_FloatingFilterChipEntity) _then;

/// Create a copy of FloatingFilterChipEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterKey = freezed,Object? filterValue = freezed,Object? label = freezed,Object? chipType = freezed,Object? textColor = freezed,Object? backgroundColor = freezed,Object? imageUrl = freezed,Object? isSelected = null,}) {
  return _then(_FloatingFilterChipEntity(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,chipType: freezed == chipType ? _self.chipType : chipType // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$FloatingFilterSectionEntity {

 String? get title; String? get chipType; int? get position; int? get tileWidth; int? get tileHeight; bool get isMultiSelect; List<FloatingFilterChipEntity> get chips;
/// Create a copy of FloatingFilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloatingFilterSectionEntityCopyWith<FloatingFilterSectionEntity> get copyWith => _$FloatingFilterSectionEntityCopyWithImpl<FloatingFilterSectionEntity>(this as FloatingFilterSectionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloatingFilterSectionEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.chipType, chipType) || other.chipType == chipType)&&(identical(other.position, position) || other.position == position)&&(identical(other.tileWidth, tileWidth) || other.tileWidth == tileWidth)&&(identical(other.tileHeight, tileHeight) || other.tileHeight == tileHeight)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&const DeepCollectionEquality().equals(other.chips, chips));
}


@override
int get hashCode => Object.hash(runtimeType,title,chipType,position,tileWidth,tileHeight,isMultiSelect,const DeepCollectionEquality().hash(chips));

@override
String toString() {
  return 'FloatingFilterSectionEntity(title: $title, chipType: $chipType, position: $position, tileWidth: $tileWidth, tileHeight: $tileHeight, isMultiSelect: $isMultiSelect, chips: $chips)';
}


}

/// @nodoc
abstract mixin class $FloatingFilterSectionEntityCopyWith<$Res>  {
  factory $FloatingFilterSectionEntityCopyWith(FloatingFilterSectionEntity value, $Res Function(FloatingFilterSectionEntity) _then) = _$FloatingFilterSectionEntityCopyWithImpl;
@useResult
$Res call({
 String? title, String? chipType, int? position, int? tileWidth, int? tileHeight, bool isMultiSelect, List<FloatingFilterChipEntity> chips
});




}
/// @nodoc
class _$FloatingFilterSectionEntityCopyWithImpl<$Res>
    implements $FloatingFilterSectionEntityCopyWith<$Res> {
  _$FloatingFilterSectionEntityCopyWithImpl(this._self, this._then);

  final FloatingFilterSectionEntity _self;
  final $Res Function(FloatingFilterSectionEntity) _then;

/// Create a copy of FloatingFilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? chipType = freezed,Object? position = freezed,Object? tileWidth = freezed,Object? tileHeight = freezed,Object? isMultiSelect = null,Object? chips = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,chipType: freezed == chipType ? _self.chipType : chipType // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,tileWidth: freezed == tileWidth ? _self.tileWidth : tileWidth // ignore: cast_nullable_to_non_nullable
as int?,tileHeight: freezed == tileHeight ? _self.tileHeight : tileHeight // ignore: cast_nullable_to_non_nullable
as int?,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,chips: null == chips ? _self.chips : chips // ignore: cast_nullable_to_non_nullable
as List<FloatingFilterChipEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [FloatingFilterSectionEntity].
extension FloatingFilterSectionEntityPatterns on FloatingFilterSectionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloatingFilterSectionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloatingFilterSectionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloatingFilterSectionEntity value)  $default,){
final _that = this;
switch (_that) {
case _FloatingFilterSectionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloatingFilterSectionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FloatingFilterSectionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? chipType,  int? position,  int? tileWidth,  int? tileHeight,  bool isMultiSelect,  List<FloatingFilterChipEntity> chips)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloatingFilterSectionEntity() when $default != null:
return $default(_that.title,_that.chipType,_that.position,_that.tileWidth,_that.tileHeight,_that.isMultiSelect,_that.chips);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? chipType,  int? position,  int? tileWidth,  int? tileHeight,  bool isMultiSelect,  List<FloatingFilterChipEntity> chips)  $default,) {final _that = this;
switch (_that) {
case _FloatingFilterSectionEntity():
return $default(_that.title,_that.chipType,_that.position,_that.tileWidth,_that.tileHeight,_that.isMultiSelect,_that.chips);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? chipType,  int? position,  int? tileWidth,  int? tileHeight,  bool isMultiSelect,  List<FloatingFilterChipEntity> chips)?  $default,) {final _that = this;
switch (_that) {
case _FloatingFilterSectionEntity() when $default != null:
return $default(_that.title,_that.chipType,_that.position,_that.tileWidth,_that.tileHeight,_that.isMultiSelect,_that.chips);case _:
  return null;

}
}

}

/// @nodoc


class _FloatingFilterSectionEntity implements FloatingFilterSectionEntity {
  const _FloatingFilterSectionEntity({this.title, this.chipType, this.position, this.tileWidth, this.tileHeight, this.isMultiSelect = true, final  List<FloatingFilterChipEntity> chips = const []}): _chips = chips;
  

@override final  String? title;
@override final  String? chipType;
@override final  int? position;
@override final  int? tileWidth;
@override final  int? tileHeight;
@override@JsonKey() final  bool isMultiSelect;
 final  List<FloatingFilterChipEntity> _chips;
@override@JsonKey() List<FloatingFilterChipEntity> get chips {
  if (_chips is EqualUnmodifiableListView) return _chips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chips);
}


/// Create a copy of FloatingFilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloatingFilterSectionEntityCopyWith<_FloatingFilterSectionEntity> get copyWith => __$FloatingFilterSectionEntityCopyWithImpl<_FloatingFilterSectionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloatingFilterSectionEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.chipType, chipType) || other.chipType == chipType)&&(identical(other.position, position) || other.position == position)&&(identical(other.tileWidth, tileWidth) || other.tileWidth == tileWidth)&&(identical(other.tileHeight, tileHeight) || other.tileHeight == tileHeight)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&const DeepCollectionEquality().equals(other._chips, _chips));
}


@override
int get hashCode => Object.hash(runtimeType,title,chipType,position,tileWidth,tileHeight,isMultiSelect,const DeepCollectionEquality().hash(_chips));

@override
String toString() {
  return 'FloatingFilterSectionEntity(title: $title, chipType: $chipType, position: $position, tileWidth: $tileWidth, tileHeight: $tileHeight, isMultiSelect: $isMultiSelect, chips: $chips)';
}


}

/// @nodoc
abstract mixin class _$FloatingFilterSectionEntityCopyWith<$Res> implements $FloatingFilterSectionEntityCopyWith<$Res> {
  factory _$FloatingFilterSectionEntityCopyWith(_FloatingFilterSectionEntity value, $Res Function(_FloatingFilterSectionEntity) _then) = __$FloatingFilterSectionEntityCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? chipType, int? position, int? tileWidth, int? tileHeight, bool isMultiSelect, List<FloatingFilterChipEntity> chips
});




}
/// @nodoc
class __$FloatingFilterSectionEntityCopyWithImpl<$Res>
    implements _$FloatingFilterSectionEntityCopyWith<$Res> {
  __$FloatingFilterSectionEntityCopyWithImpl(this._self, this._then);

  final _FloatingFilterSectionEntity _self;
  final $Res Function(_FloatingFilterSectionEntity) _then;

/// Create a copy of FloatingFilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? chipType = freezed,Object? position = freezed,Object? tileWidth = freezed,Object? tileHeight = freezed,Object? isMultiSelect = null,Object? chips = null,}) {
  return _then(_FloatingFilterSectionEntity(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,chipType: freezed == chipType ? _self.chipType : chipType // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,tileWidth: freezed == tileWidth ? _self.tileWidth : tileWidth // ignore: cast_nullable_to_non_nullable
as int?,tileHeight: freezed == tileHeight ? _self.tileHeight : tileHeight // ignore: cast_nullable_to_non_nullable
as int?,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,chips: null == chips ? _self._chips : chips // ignore: cast_nullable_to_non_nullable
as List<FloatingFilterChipEntity>,
  ));
}


}

/// @nodoc
mixin _$FloatingFilterEntity {

 String? get type; List<FloatingFilterSectionEntity> get sections;
/// Create a copy of FloatingFilterEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloatingFilterEntityCopyWith<FloatingFilterEntity> get copyWith => _$FloatingFilterEntityCopyWithImpl<FloatingFilterEntity>(this as FloatingFilterEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloatingFilterEntity&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.sections, sections));
}


@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'FloatingFilterEntity(type: $type, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $FloatingFilterEntityCopyWith<$Res>  {
  factory $FloatingFilterEntityCopyWith(FloatingFilterEntity value, $Res Function(FloatingFilterEntity) _then) = _$FloatingFilterEntityCopyWithImpl;
@useResult
$Res call({
 String? type, List<FloatingFilterSectionEntity> sections
});




}
/// @nodoc
class _$FloatingFilterEntityCopyWithImpl<$Res>
    implements $FloatingFilterEntityCopyWith<$Res> {
  _$FloatingFilterEntityCopyWithImpl(this._self, this._then);

  final FloatingFilterEntity _self;
  final $Res Function(FloatingFilterEntity) _then;

/// Create a copy of FloatingFilterEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? sections = null,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<FloatingFilterSectionEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [FloatingFilterEntity].
extension FloatingFilterEntityPatterns on FloatingFilterEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloatingFilterEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloatingFilterEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloatingFilterEntity value)  $default,){
final _that = this;
switch (_that) {
case _FloatingFilterEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloatingFilterEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FloatingFilterEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  List<FloatingFilterSectionEntity> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloatingFilterEntity() when $default != null:
return $default(_that.type,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  List<FloatingFilterSectionEntity> sections)  $default,) {final _that = this;
switch (_that) {
case _FloatingFilterEntity():
return $default(_that.type,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  List<FloatingFilterSectionEntity> sections)?  $default,) {final _that = this;
switch (_that) {
case _FloatingFilterEntity() when $default != null:
return $default(_that.type,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _FloatingFilterEntity implements FloatingFilterEntity {
  const _FloatingFilterEntity({this.type, final  List<FloatingFilterSectionEntity> sections = const []}): _sections = sections;
  

@override final  String? type;
 final  List<FloatingFilterSectionEntity> _sections;
@override@JsonKey() List<FloatingFilterSectionEntity> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of FloatingFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloatingFilterEntityCopyWith<_FloatingFilterEntity> get copyWith => __$FloatingFilterEntityCopyWithImpl<_FloatingFilterEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloatingFilterEntity&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'FloatingFilterEntity(type: $type, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$FloatingFilterEntityCopyWith<$Res> implements $FloatingFilterEntityCopyWith<$Res> {
  factory _$FloatingFilterEntityCopyWith(_FloatingFilterEntity value, $Res Function(_FloatingFilterEntity) _then) = __$FloatingFilterEntityCopyWithImpl;
@override @useResult
$Res call({
 String? type, List<FloatingFilterSectionEntity> sections
});




}
/// @nodoc
class __$FloatingFilterEntityCopyWithImpl<$Res>
    implements _$FloatingFilterEntityCopyWith<$Res> {
  __$FloatingFilterEntityCopyWithImpl(this._self, this._then);

  final _FloatingFilterEntity _self;
  final $Res Function(_FloatingFilterEntity) _then;

/// Create a copy of FloatingFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? sections = null,}) {
  return _then(_FloatingFilterEntity(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<FloatingFilterSectionEntity>,
  ));
}


}

// dart format on
