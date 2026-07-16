// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_chart_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SizeChartEntity {

 List<SizeChartDtoEntity> get charts;
/// Create a copy of SizeChartEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeChartEntityCopyWith<SizeChartEntity> get copyWith => _$SizeChartEntityCopyWithImpl<SizeChartEntity>(this as SizeChartEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeChartEntity&&const DeepCollectionEquality().equals(other.charts, charts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(charts));

@override
String toString() {
  return 'SizeChartEntity(charts: $charts)';
}


}

/// @nodoc
abstract mixin class $SizeChartEntityCopyWith<$Res>  {
  factory $SizeChartEntityCopyWith(SizeChartEntity value, $Res Function(SizeChartEntity) _then) = _$SizeChartEntityCopyWithImpl;
@useResult
$Res call({
 List<SizeChartDtoEntity> charts
});




}
/// @nodoc
class _$SizeChartEntityCopyWithImpl<$Res>
    implements $SizeChartEntityCopyWith<$Res> {
  _$SizeChartEntityCopyWithImpl(this._self, this._then);

  final SizeChartEntity _self;
  final $Res Function(SizeChartEntity) _then;

/// Create a copy of SizeChartEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? charts = null,}) {
  return _then(_self.copyWith(
charts: null == charts ? _self.charts : charts // ignore: cast_nullable_to_non_nullable
as List<SizeChartDtoEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeChartEntity].
extension SizeChartEntityPatterns on SizeChartEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeChartEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeChartEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeChartEntity value)  $default,){
final _that = this;
switch (_that) {
case _SizeChartEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeChartEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SizeChartEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SizeChartDtoEntity> charts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeChartEntity() when $default != null:
return $default(_that.charts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SizeChartDtoEntity> charts)  $default,) {final _that = this;
switch (_that) {
case _SizeChartEntity():
return $default(_that.charts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SizeChartDtoEntity> charts)?  $default,) {final _that = this;
switch (_that) {
case _SizeChartEntity() when $default != null:
return $default(_that.charts);case _:
  return null;

}
}

}

/// @nodoc


class _SizeChartEntity implements SizeChartEntity {
  const _SizeChartEntity({final  List<SizeChartDtoEntity> charts = const []}): _charts = charts;
  

 final  List<SizeChartDtoEntity> _charts;
@override@JsonKey() List<SizeChartDtoEntity> get charts {
  if (_charts is EqualUnmodifiableListView) return _charts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_charts);
}


/// Create a copy of SizeChartEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeChartEntityCopyWith<_SizeChartEntity> get copyWith => __$SizeChartEntityCopyWithImpl<_SizeChartEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeChartEntity&&const DeepCollectionEquality().equals(other._charts, _charts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_charts));

@override
String toString() {
  return 'SizeChartEntity(charts: $charts)';
}


}

/// @nodoc
abstract mixin class _$SizeChartEntityCopyWith<$Res> implements $SizeChartEntityCopyWith<$Res> {
  factory _$SizeChartEntityCopyWith(_SizeChartEntity value, $Res Function(_SizeChartEntity) _then) = __$SizeChartEntityCopyWithImpl;
@override @useResult
$Res call({
 List<SizeChartDtoEntity> charts
});




}
/// @nodoc
class __$SizeChartEntityCopyWithImpl<$Res>
    implements _$SizeChartEntityCopyWith<$Res> {
  __$SizeChartEntityCopyWithImpl(this._self, this._then);

  final _SizeChartEntity _self;
  final $Res Function(_SizeChartEntity) _then;

/// Create a copy of SizeChartEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? charts = null,}) {
  return _then(_SizeChartEntity(
charts: null == charts ? _self._charts : charts // ignore: cast_nullable_to_non_nullable
as List<SizeChartDtoEntity>,
  ));
}


}

/// @nodoc
mixin _$SizeChartDtoEntity {

 String? get illustrationImageUrl;/// Default length unit from API: "cm" or "in"
 String? get lengthUnit;/// Default weight unit from API: "kg" or "lb"
 String? get weightUnit; List<String> get notesList; List<String> get cueImageUrlList;/// Rows of table data; each row contains one value per column.
 List<SizeChartRowEntity> get rows;/// Column header names (e.g. ["Size", "Chest", "Length"]).
 List<String> get parameterNames;/// Per-column measure type: "L" for length, "W" for weight, else no conversion.
 List<String> get parameterMeasureTypes; String? get importantInfo;
/// Create a copy of SizeChartDtoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeChartDtoEntityCopyWith<SizeChartDtoEntity> get copyWith => _$SizeChartDtoEntityCopyWithImpl<SizeChartDtoEntity>(this as SizeChartDtoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeChartDtoEntity&&(identical(other.illustrationImageUrl, illustrationImageUrl) || other.illustrationImageUrl == illustrationImageUrl)&&(identical(other.lengthUnit, lengthUnit) || other.lengthUnit == lengthUnit)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&const DeepCollectionEquality().equals(other.notesList, notesList)&&const DeepCollectionEquality().equals(other.cueImageUrlList, cueImageUrlList)&&const DeepCollectionEquality().equals(other.rows, rows)&&const DeepCollectionEquality().equals(other.parameterNames, parameterNames)&&const DeepCollectionEquality().equals(other.parameterMeasureTypes, parameterMeasureTypes)&&(identical(other.importantInfo, importantInfo) || other.importantInfo == importantInfo));
}


@override
int get hashCode => Object.hash(runtimeType,illustrationImageUrl,lengthUnit,weightUnit,const DeepCollectionEquality().hash(notesList),const DeepCollectionEquality().hash(cueImageUrlList),const DeepCollectionEquality().hash(rows),const DeepCollectionEquality().hash(parameterNames),const DeepCollectionEquality().hash(parameterMeasureTypes),importantInfo);

@override
String toString() {
  return 'SizeChartDtoEntity(illustrationImageUrl: $illustrationImageUrl, lengthUnit: $lengthUnit, weightUnit: $weightUnit, notesList: $notesList, cueImageUrlList: $cueImageUrlList, rows: $rows, parameterNames: $parameterNames, parameterMeasureTypes: $parameterMeasureTypes, importantInfo: $importantInfo)';
}


}

/// @nodoc
abstract mixin class $SizeChartDtoEntityCopyWith<$Res>  {
  factory $SizeChartDtoEntityCopyWith(SizeChartDtoEntity value, $Res Function(SizeChartDtoEntity) _then) = _$SizeChartDtoEntityCopyWithImpl;
@useResult
$Res call({
 String? illustrationImageUrl, String? lengthUnit, String? weightUnit, List<String> notesList, List<String> cueImageUrlList, List<SizeChartRowEntity> rows, List<String> parameterNames, List<String> parameterMeasureTypes, String? importantInfo
});




}
/// @nodoc
class _$SizeChartDtoEntityCopyWithImpl<$Res>
    implements $SizeChartDtoEntityCopyWith<$Res> {
  _$SizeChartDtoEntityCopyWithImpl(this._self, this._then);

  final SizeChartDtoEntity _self;
  final $Res Function(SizeChartDtoEntity) _then;

/// Create a copy of SizeChartDtoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? illustrationImageUrl = freezed,Object? lengthUnit = freezed,Object? weightUnit = freezed,Object? notesList = null,Object? cueImageUrlList = null,Object? rows = null,Object? parameterNames = null,Object? parameterMeasureTypes = null,Object? importantInfo = freezed,}) {
  return _then(_self.copyWith(
illustrationImageUrl: freezed == illustrationImageUrl ? _self.illustrationImageUrl : illustrationImageUrl // ignore: cast_nullable_to_non_nullable
as String?,lengthUnit: freezed == lengthUnit ? _self.lengthUnit : lengthUnit // ignore: cast_nullable_to_non_nullable
as String?,weightUnit: freezed == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as String?,notesList: null == notesList ? _self.notesList : notesList // ignore: cast_nullable_to_non_nullable
as List<String>,cueImageUrlList: null == cueImageUrlList ? _self.cueImageUrlList : cueImageUrlList // ignore: cast_nullable_to_non_nullable
as List<String>,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<SizeChartRowEntity>,parameterNames: null == parameterNames ? _self.parameterNames : parameterNames // ignore: cast_nullable_to_non_nullable
as List<String>,parameterMeasureTypes: null == parameterMeasureTypes ? _self.parameterMeasureTypes : parameterMeasureTypes // ignore: cast_nullable_to_non_nullable
as List<String>,importantInfo: freezed == importantInfo ? _self.importantInfo : importantInfo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeChartDtoEntity].
extension SizeChartDtoEntityPatterns on SizeChartDtoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeChartDtoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeChartDtoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeChartDtoEntity value)  $default,){
final _that = this;
switch (_that) {
case _SizeChartDtoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeChartDtoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SizeChartDtoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? illustrationImageUrl,  String? lengthUnit,  String? weightUnit,  List<String> notesList,  List<String> cueImageUrlList,  List<SizeChartRowEntity> rows,  List<String> parameterNames,  List<String> parameterMeasureTypes,  String? importantInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeChartDtoEntity() when $default != null:
return $default(_that.illustrationImageUrl,_that.lengthUnit,_that.weightUnit,_that.notesList,_that.cueImageUrlList,_that.rows,_that.parameterNames,_that.parameterMeasureTypes,_that.importantInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? illustrationImageUrl,  String? lengthUnit,  String? weightUnit,  List<String> notesList,  List<String> cueImageUrlList,  List<SizeChartRowEntity> rows,  List<String> parameterNames,  List<String> parameterMeasureTypes,  String? importantInfo)  $default,) {final _that = this;
switch (_that) {
case _SizeChartDtoEntity():
return $default(_that.illustrationImageUrl,_that.lengthUnit,_that.weightUnit,_that.notesList,_that.cueImageUrlList,_that.rows,_that.parameterNames,_that.parameterMeasureTypes,_that.importantInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? illustrationImageUrl,  String? lengthUnit,  String? weightUnit,  List<String> notesList,  List<String> cueImageUrlList,  List<SizeChartRowEntity> rows,  List<String> parameterNames,  List<String> parameterMeasureTypes,  String? importantInfo)?  $default,) {final _that = this;
switch (_that) {
case _SizeChartDtoEntity() when $default != null:
return $default(_that.illustrationImageUrl,_that.lengthUnit,_that.weightUnit,_that.notesList,_that.cueImageUrlList,_that.rows,_that.parameterNames,_that.parameterMeasureTypes,_that.importantInfo);case _:
  return null;

}
}

}

/// @nodoc


class _SizeChartDtoEntity implements SizeChartDtoEntity {
  const _SizeChartDtoEntity({this.illustrationImageUrl, this.lengthUnit, this.weightUnit, final  List<String> notesList = const [], final  List<String> cueImageUrlList = const [], final  List<SizeChartRowEntity> rows = const [], final  List<String> parameterNames = const [], final  List<String> parameterMeasureTypes = const [], this.importantInfo}): _notesList = notesList,_cueImageUrlList = cueImageUrlList,_rows = rows,_parameterNames = parameterNames,_parameterMeasureTypes = parameterMeasureTypes;
  

@override final  String? illustrationImageUrl;
/// Default length unit from API: "cm" or "in"
@override final  String? lengthUnit;
/// Default weight unit from API: "kg" or "lb"
@override final  String? weightUnit;
 final  List<String> _notesList;
@override@JsonKey() List<String> get notesList {
  if (_notesList is EqualUnmodifiableListView) return _notesList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notesList);
}

 final  List<String> _cueImageUrlList;
@override@JsonKey() List<String> get cueImageUrlList {
  if (_cueImageUrlList is EqualUnmodifiableListView) return _cueImageUrlList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cueImageUrlList);
}

/// Rows of table data; each row contains one value per column.
 final  List<SizeChartRowEntity> _rows;
/// Rows of table data; each row contains one value per column.
@override@JsonKey() List<SizeChartRowEntity> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

/// Column header names (e.g. ["Size", "Chest", "Length"]).
 final  List<String> _parameterNames;
/// Column header names (e.g. ["Size", "Chest", "Length"]).
@override@JsonKey() List<String> get parameterNames {
  if (_parameterNames is EqualUnmodifiableListView) return _parameterNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parameterNames);
}

/// Per-column measure type: "L" for length, "W" for weight, else no conversion.
 final  List<String> _parameterMeasureTypes;
/// Per-column measure type: "L" for length, "W" for weight, else no conversion.
@override@JsonKey() List<String> get parameterMeasureTypes {
  if (_parameterMeasureTypes is EqualUnmodifiableListView) return _parameterMeasureTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parameterMeasureTypes);
}

@override final  String? importantInfo;

/// Create a copy of SizeChartDtoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeChartDtoEntityCopyWith<_SizeChartDtoEntity> get copyWith => __$SizeChartDtoEntityCopyWithImpl<_SizeChartDtoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeChartDtoEntity&&(identical(other.illustrationImageUrl, illustrationImageUrl) || other.illustrationImageUrl == illustrationImageUrl)&&(identical(other.lengthUnit, lengthUnit) || other.lengthUnit == lengthUnit)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&const DeepCollectionEquality().equals(other._notesList, _notesList)&&const DeepCollectionEquality().equals(other._cueImageUrlList, _cueImageUrlList)&&const DeepCollectionEquality().equals(other._rows, _rows)&&const DeepCollectionEquality().equals(other._parameterNames, _parameterNames)&&const DeepCollectionEquality().equals(other._parameterMeasureTypes, _parameterMeasureTypes)&&(identical(other.importantInfo, importantInfo) || other.importantInfo == importantInfo));
}


@override
int get hashCode => Object.hash(runtimeType,illustrationImageUrl,lengthUnit,weightUnit,const DeepCollectionEquality().hash(_notesList),const DeepCollectionEquality().hash(_cueImageUrlList),const DeepCollectionEquality().hash(_rows),const DeepCollectionEquality().hash(_parameterNames),const DeepCollectionEquality().hash(_parameterMeasureTypes),importantInfo);

@override
String toString() {
  return 'SizeChartDtoEntity(illustrationImageUrl: $illustrationImageUrl, lengthUnit: $lengthUnit, weightUnit: $weightUnit, notesList: $notesList, cueImageUrlList: $cueImageUrlList, rows: $rows, parameterNames: $parameterNames, parameterMeasureTypes: $parameterMeasureTypes, importantInfo: $importantInfo)';
}


}

/// @nodoc
abstract mixin class _$SizeChartDtoEntityCopyWith<$Res> implements $SizeChartDtoEntityCopyWith<$Res> {
  factory _$SizeChartDtoEntityCopyWith(_SizeChartDtoEntity value, $Res Function(_SizeChartDtoEntity) _then) = __$SizeChartDtoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? illustrationImageUrl, String? lengthUnit, String? weightUnit, List<String> notesList, List<String> cueImageUrlList, List<SizeChartRowEntity> rows, List<String> parameterNames, List<String> parameterMeasureTypes, String? importantInfo
});




}
/// @nodoc
class __$SizeChartDtoEntityCopyWithImpl<$Res>
    implements _$SizeChartDtoEntityCopyWith<$Res> {
  __$SizeChartDtoEntityCopyWithImpl(this._self, this._then);

  final _SizeChartDtoEntity _self;
  final $Res Function(_SizeChartDtoEntity) _then;

/// Create a copy of SizeChartDtoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? illustrationImageUrl = freezed,Object? lengthUnit = freezed,Object? weightUnit = freezed,Object? notesList = null,Object? cueImageUrlList = null,Object? rows = null,Object? parameterNames = null,Object? parameterMeasureTypes = null,Object? importantInfo = freezed,}) {
  return _then(_SizeChartDtoEntity(
illustrationImageUrl: freezed == illustrationImageUrl ? _self.illustrationImageUrl : illustrationImageUrl // ignore: cast_nullable_to_non_nullable
as String?,lengthUnit: freezed == lengthUnit ? _self.lengthUnit : lengthUnit // ignore: cast_nullable_to_non_nullable
as String?,weightUnit: freezed == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as String?,notesList: null == notesList ? _self._notesList : notesList // ignore: cast_nullable_to_non_nullable
as List<String>,cueImageUrlList: null == cueImageUrlList ? _self._cueImageUrlList : cueImageUrlList // ignore: cast_nullable_to_non_nullable
as List<String>,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<SizeChartRowEntity>,parameterNames: null == parameterNames ? _self._parameterNames : parameterNames // ignore: cast_nullable_to_non_nullable
as List<String>,parameterMeasureTypes: null == parameterMeasureTypes ? _self._parameterMeasureTypes : parameterMeasureTypes // ignore: cast_nullable_to_non_nullable
as List<String>,importantInfo: freezed == importantInfo ? _self.importantInfo : importantInfo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SizeChartRowEntity {

 List<String> get values;
/// Create a copy of SizeChartRowEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeChartRowEntityCopyWith<SizeChartRowEntity> get copyWith => _$SizeChartRowEntityCopyWithImpl<SizeChartRowEntity>(this as SizeChartRowEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeChartRowEntity&&const DeepCollectionEquality().equals(other.values, values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(values));

@override
String toString() {
  return 'SizeChartRowEntity(values: $values)';
}


}

/// @nodoc
abstract mixin class $SizeChartRowEntityCopyWith<$Res>  {
  factory $SizeChartRowEntityCopyWith(SizeChartRowEntity value, $Res Function(SizeChartRowEntity) _then) = _$SizeChartRowEntityCopyWithImpl;
@useResult
$Res call({
 List<String> values
});




}
/// @nodoc
class _$SizeChartRowEntityCopyWithImpl<$Res>
    implements $SizeChartRowEntityCopyWith<$Res> {
  _$SizeChartRowEntityCopyWithImpl(this._self, this._then);

  final SizeChartRowEntity _self;
  final $Res Function(SizeChartRowEntity) _then;

/// Create a copy of SizeChartRowEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,}) {
  return _then(_self.copyWith(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeChartRowEntity].
extension SizeChartRowEntityPatterns on SizeChartRowEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeChartRowEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeChartRowEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeChartRowEntity value)  $default,){
final _that = this;
switch (_that) {
case _SizeChartRowEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeChartRowEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SizeChartRowEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> values)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeChartRowEntity() when $default != null:
return $default(_that.values);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> values)  $default,) {final _that = this;
switch (_that) {
case _SizeChartRowEntity():
return $default(_that.values);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> values)?  $default,) {final _that = this;
switch (_that) {
case _SizeChartRowEntity() when $default != null:
return $default(_that.values);case _:
  return null;

}
}

}

/// @nodoc


class _SizeChartRowEntity implements SizeChartRowEntity {
  const _SizeChartRowEntity({final  List<String> values = const []}): _values = values;
  

 final  List<String> _values;
@override@JsonKey() List<String> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of SizeChartRowEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeChartRowEntityCopyWith<_SizeChartRowEntity> get copyWith => __$SizeChartRowEntityCopyWithImpl<_SizeChartRowEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeChartRowEntity&&const DeepCollectionEquality().equals(other._values, _values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'SizeChartRowEntity(values: $values)';
}


}

/// @nodoc
abstract mixin class _$SizeChartRowEntityCopyWith<$Res> implements $SizeChartRowEntityCopyWith<$Res> {
  factory _$SizeChartRowEntityCopyWith(_SizeChartRowEntity value, $Res Function(_SizeChartRowEntity) _then) = __$SizeChartRowEntityCopyWithImpl;
@override @useResult
$Res call({
 List<String> values
});




}
/// @nodoc
class __$SizeChartRowEntityCopyWithImpl<$Res>
    implements _$SizeChartRowEntityCopyWith<$Res> {
  __$SizeChartRowEntityCopyWithImpl(this._self, this._then);

  final _SizeChartRowEntity _self;
  final $Res Function(_SizeChartRowEntity) _then;

/// Create a copy of SizeChartRowEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(_SizeChartRowEntity(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
