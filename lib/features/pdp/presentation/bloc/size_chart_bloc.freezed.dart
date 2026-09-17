// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_chart_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SizeChartEvent {

 int get productId;
/// Create a copy of SizeChartEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeChartEventCopyWith<SizeChartEvent> get copyWith => _$SizeChartEventCopyWithImpl<SizeChartEvent>(this as SizeChartEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeChartEvent&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'SizeChartEvent(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $SizeChartEventCopyWith<$Res>  {
  factory $SizeChartEventCopyWith(SizeChartEvent value, $Res Function(SizeChartEvent) _then) = _$SizeChartEventCopyWithImpl;
@useResult
$Res call({
 int productId
});




}
/// @nodoc
class _$SizeChartEventCopyWithImpl<$Res>
    implements $SizeChartEventCopyWith<$Res> {
  _$SizeChartEventCopyWithImpl(this._self, this._then);

  final SizeChartEvent _self;
  final $Res Function(SizeChartEvent) _then;

/// Create a copy of SizeChartEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeChartEvent].
extension SizeChartEventPatterns on SizeChartEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadSizeChart value)?  load,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadSizeChart() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadSizeChart value)  load,}){
final _that = this;
switch (_that) {
case LoadSizeChart():
return load(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadSizeChart value)?  load,}){
final _that = this;
switch (_that) {
case LoadSizeChart() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int productId)?  load,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadSizeChart() when load != null:
return load(_that.productId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int productId)  load,}) {final _that = this;
switch (_that) {
case LoadSizeChart():
return load(_that.productId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int productId)?  load,}) {final _that = this;
switch (_that) {
case LoadSizeChart() when load != null:
return load(_that.productId);case _:
  return null;

}
}

}

/// @nodoc


class LoadSizeChart implements SizeChartEvent {
  const LoadSizeChart(this.productId);
  

@override final  int productId;

/// Create a copy of SizeChartEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadSizeChartCopyWith<LoadSizeChart> get copyWith => _$LoadSizeChartCopyWithImpl<LoadSizeChart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadSizeChart&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'SizeChartEvent.load(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $LoadSizeChartCopyWith<$Res> implements $SizeChartEventCopyWith<$Res> {
  factory $LoadSizeChartCopyWith(LoadSizeChart value, $Res Function(LoadSizeChart) _then) = _$LoadSizeChartCopyWithImpl;
@override @useResult
$Res call({
 int productId
});




}
/// @nodoc
class _$LoadSizeChartCopyWithImpl<$Res>
    implements $LoadSizeChartCopyWith<$Res> {
  _$LoadSizeChartCopyWithImpl(this._self, this._then);

  final LoadSizeChart _self;
  final $Res Function(LoadSizeChart) _then;

/// Create a copy of SizeChartEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(LoadSizeChart(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SizeChartState {

 SizeChartStatus get status; SizeChartEntity? get chart; String? get errorMessage;// Product the loaded chart belongs to, so reopening the same product's
// chart does not refetch.
 int? get productId;
/// Create a copy of SizeChartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeChartStateCopyWith<SizeChartState> get copyWith => _$SizeChartStateCopyWithImpl<SizeChartState>(this as SizeChartState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeChartState&&(identical(other.status, status) || other.status == status)&&(identical(other.chart, chart) || other.chart == chart)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,status,chart,errorMessage,productId);

@override
String toString() {
  return 'SizeChartState(status: $status, chart: $chart, errorMessage: $errorMessage, productId: $productId)';
}


}

/// @nodoc
abstract mixin class $SizeChartStateCopyWith<$Res>  {
  factory $SizeChartStateCopyWith(SizeChartState value, $Res Function(SizeChartState) _then) = _$SizeChartStateCopyWithImpl;
@useResult
$Res call({
 SizeChartStatus status, SizeChartEntity? chart, String? errorMessage, int? productId
});


$SizeChartEntityCopyWith<$Res>? get chart;

}
/// @nodoc
class _$SizeChartStateCopyWithImpl<$Res>
    implements $SizeChartStateCopyWith<$Res> {
  _$SizeChartStateCopyWithImpl(this._self, this._then);

  final SizeChartState _self;
  final $Res Function(SizeChartState) _then;

/// Create a copy of SizeChartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? chart = freezed,Object? errorMessage = freezed,Object? productId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SizeChartStatus,chart: freezed == chart ? _self.chart : chart // ignore: cast_nullable_to_non_nullable
as SizeChartEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of SizeChartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SizeChartEntityCopyWith<$Res>? get chart {
    if (_self.chart == null) {
    return null;
  }

  return $SizeChartEntityCopyWith<$Res>(_self.chart!, (value) {
    return _then(_self.copyWith(chart: value));
  });
}
}


/// Adds pattern-matching-related methods to [SizeChartState].
extension SizeChartStatePatterns on SizeChartState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeChartState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeChartState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeChartState value)  $default,){
final _that = this;
switch (_that) {
case _SizeChartState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeChartState value)?  $default,){
final _that = this;
switch (_that) {
case _SizeChartState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SizeChartStatus status,  SizeChartEntity? chart,  String? errorMessage,  int? productId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeChartState() when $default != null:
return $default(_that.status,_that.chart,_that.errorMessage,_that.productId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SizeChartStatus status,  SizeChartEntity? chart,  String? errorMessage,  int? productId)  $default,) {final _that = this;
switch (_that) {
case _SizeChartState():
return $default(_that.status,_that.chart,_that.errorMessage,_that.productId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SizeChartStatus status,  SizeChartEntity? chart,  String? errorMessage,  int? productId)?  $default,) {final _that = this;
switch (_that) {
case _SizeChartState() when $default != null:
return $default(_that.status,_that.chart,_that.errorMessage,_that.productId);case _:
  return null;

}
}

}

/// @nodoc


class _SizeChartState implements SizeChartState {
  const _SizeChartState({this.status = SizeChartStatus.initial, this.chart, this.errorMessage, this.productId});
  

@override@JsonKey() final  SizeChartStatus status;
@override final  SizeChartEntity? chart;
@override final  String? errorMessage;
// Product the loaded chart belongs to, so reopening the same product's
// chart does not refetch.
@override final  int? productId;

/// Create a copy of SizeChartState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeChartStateCopyWith<_SizeChartState> get copyWith => __$SizeChartStateCopyWithImpl<_SizeChartState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeChartState&&(identical(other.status, status) || other.status == status)&&(identical(other.chart, chart) || other.chart == chart)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,status,chart,errorMessage,productId);

@override
String toString() {
  return 'SizeChartState(status: $status, chart: $chart, errorMessage: $errorMessage, productId: $productId)';
}


}

/// @nodoc
abstract mixin class _$SizeChartStateCopyWith<$Res> implements $SizeChartStateCopyWith<$Res> {
  factory _$SizeChartStateCopyWith(_SizeChartState value, $Res Function(_SizeChartState) _then) = __$SizeChartStateCopyWithImpl;
@override @useResult
$Res call({
 SizeChartStatus status, SizeChartEntity? chart, String? errorMessage, int? productId
});


@override $SizeChartEntityCopyWith<$Res>? get chart;

}
/// @nodoc
class __$SizeChartStateCopyWithImpl<$Res>
    implements _$SizeChartStateCopyWith<$Res> {
  __$SizeChartStateCopyWithImpl(this._self, this._then);

  final _SizeChartState _self;
  final $Res Function(_SizeChartState) _then;

/// Create a copy of SizeChartState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? chart = freezed,Object? errorMessage = freezed,Object? productId = freezed,}) {
  return _then(_SizeChartState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SizeChartStatus,chart: freezed == chart ? _self.chart : chart // ignore: cast_nullable_to_non_nullable
as SizeChartEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of SizeChartState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SizeChartEntityCopyWith<$Res>? get chart {
    if (_self.chart == null) {
    return null;
  }

  return $SizeChartEntityCopyWith<$Res>(_self.chart!, (value) {
    return _then(_self.copyWith(chart: value));
  });
}
}

// dart format on
