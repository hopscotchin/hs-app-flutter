// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoDetailsEvent {

 int get promoId;
/// Create a copy of PromoDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoDetailsEventCopyWith<PromoDetailsEvent> get copyWith => _$PromoDetailsEventCopyWithImpl<PromoDetailsEvent>(this as PromoDetailsEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoDetailsEvent&&(identical(other.promoId, promoId) || other.promoId == promoId));
}


@override
int get hashCode => Object.hash(runtimeType,promoId);

@override
String toString() {
  return 'PromoDetailsEvent(promoId: $promoId)';
}


}

/// @nodoc
abstract mixin class $PromoDetailsEventCopyWith<$Res>  {
  factory $PromoDetailsEventCopyWith(PromoDetailsEvent value, $Res Function(PromoDetailsEvent) _then) = _$PromoDetailsEventCopyWithImpl;
@useResult
$Res call({
 int promoId
});




}
/// @nodoc
class _$PromoDetailsEventCopyWithImpl<$Res>
    implements $PromoDetailsEventCopyWith<$Res> {
  _$PromoDetailsEventCopyWithImpl(this._self, this._then);

  final PromoDetailsEvent _self;
  final $Res Function(PromoDetailsEvent) _then;

/// Create a copy of PromoDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? promoId = null,}) {
  return _then(_self.copyWith(
promoId: null == promoId ? _self.promoId : promoId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoDetailsEvent].
extension PromoDetailsEventPatterns on PromoDetailsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadPromoDetails value)?  load,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadPromoDetails() when load != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadPromoDetails value)  load,}){
final _that = this;
switch (_that) {
case LoadPromoDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadPromoDetails value)?  load,}){
final _that = this;
switch (_that) {
case LoadPromoDetails() when load != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int promoId)?  load,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadPromoDetails() when load != null:
return load(_that.promoId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int promoId)  load,}) {final _that = this;
switch (_that) {
case LoadPromoDetails():
return load(_that.promoId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int promoId)?  load,}) {final _that = this;
switch (_that) {
case LoadPromoDetails() when load != null:
return load(_that.promoId);case _:
  return null;

}
}

}

/// @nodoc


class LoadPromoDetails implements PromoDetailsEvent {
  const LoadPromoDetails(this.promoId);
  

@override final  int promoId;

/// Create a copy of PromoDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadPromoDetailsCopyWith<LoadPromoDetails> get copyWith => _$LoadPromoDetailsCopyWithImpl<LoadPromoDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadPromoDetails&&(identical(other.promoId, promoId) || other.promoId == promoId));
}


@override
int get hashCode => Object.hash(runtimeType,promoId);

@override
String toString() {
  return 'PromoDetailsEvent.load(promoId: $promoId)';
}


}

/// @nodoc
abstract mixin class $LoadPromoDetailsCopyWith<$Res> implements $PromoDetailsEventCopyWith<$Res> {
  factory $LoadPromoDetailsCopyWith(LoadPromoDetails value, $Res Function(LoadPromoDetails) _then) = _$LoadPromoDetailsCopyWithImpl;
@override @useResult
$Res call({
 int promoId
});




}
/// @nodoc
class _$LoadPromoDetailsCopyWithImpl<$Res>
    implements $LoadPromoDetailsCopyWith<$Res> {
  _$LoadPromoDetailsCopyWithImpl(this._self, this._then);

  final LoadPromoDetails _self;
  final $Res Function(LoadPromoDetails) _then;

/// Create a copy of PromoDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? promoId = null,}) {
  return _then(LoadPromoDetails(
null == promoId ? _self.promoId : promoId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PromoDetailsState {

 PromoDetailsStatus get status; PromoDetailsEntity? get details; String? get errorMessage;
/// Create a copy of PromoDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoDetailsStateCopyWith<PromoDetailsState> get copyWith => _$PromoDetailsStateCopyWithImpl<PromoDetailsState>(this as PromoDetailsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoDetailsState&&(identical(other.status, status) || other.status == status)&&(identical(other.details, details) || other.details == details)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,details,errorMessage);

@override
String toString() {
  return 'PromoDetailsState(status: $status, details: $details, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PromoDetailsStateCopyWith<$Res>  {
  factory $PromoDetailsStateCopyWith(PromoDetailsState value, $Res Function(PromoDetailsState) _then) = _$PromoDetailsStateCopyWithImpl;
@useResult
$Res call({
 PromoDetailsStatus status, PromoDetailsEntity? details, String? errorMessage
});


$PromoDetailsEntityCopyWith<$Res>? get details;

}
/// @nodoc
class _$PromoDetailsStateCopyWithImpl<$Res>
    implements $PromoDetailsStateCopyWith<$Res> {
  _$PromoDetailsStateCopyWithImpl(this._self, this._then);

  final PromoDetailsState _self;
  final $Res Function(PromoDetailsState) _then;

/// Create a copy of PromoDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? details = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PromoDetailsStatus,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as PromoDetailsEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PromoDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoDetailsEntityCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $PromoDetailsEntityCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}


/// Adds pattern-matching-related methods to [PromoDetailsState].
extension PromoDetailsStatePatterns on PromoDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoDetailsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoDetailsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoDetailsState value)  $default,){
final _that = this;
switch (_that) {
case _PromoDetailsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoDetailsState value)?  $default,){
final _that = this;
switch (_that) {
case _PromoDetailsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PromoDetailsStatus status,  PromoDetailsEntity? details,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoDetailsState() when $default != null:
return $default(_that.status,_that.details,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PromoDetailsStatus status,  PromoDetailsEntity? details,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PromoDetailsState():
return $default(_that.status,_that.details,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PromoDetailsStatus status,  PromoDetailsEntity? details,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PromoDetailsState() when $default != null:
return $default(_that.status,_that.details,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PromoDetailsState implements PromoDetailsState {
  const _PromoDetailsState({this.status = PromoDetailsStatus.initial, this.details, this.errorMessage});
  

@override@JsonKey() final  PromoDetailsStatus status;
@override final  PromoDetailsEntity? details;
@override final  String? errorMessage;

/// Create a copy of PromoDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoDetailsStateCopyWith<_PromoDetailsState> get copyWith => __$PromoDetailsStateCopyWithImpl<_PromoDetailsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoDetailsState&&(identical(other.status, status) || other.status == status)&&(identical(other.details, details) || other.details == details)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,details,errorMessage);

@override
String toString() {
  return 'PromoDetailsState(status: $status, details: $details, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PromoDetailsStateCopyWith<$Res> implements $PromoDetailsStateCopyWith<$Res> {
  factory _$PromoDetailsStateCopyWith(_PromoDetailsState value, $Res Function(_PromoDetailsState) _then) = __$PromoDetailsStateCopyWithImpl;
@override @useResult
$Res call({
 PromoDetailsStatus status, PromoDetailsEntity? details, String? errorMessage
});


@override $PromoDetailsEntityCopyWith<$Res>? get details;

}
/// @nodoc
class __$PromoDetailsStateCopyWithImpl<$Res>
    implements _$PromoDetailsStateCopyWith<$Res> {
  __$PromoDetailsStateCopyWithImpl(this._self, this._then);

  final _PromoDetailsState _self;
  final $Res Function(_PromoDetailsState) _then;

/// Create a copy of PromoDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? details = freezed,Object? errorMessage = freezed,}) {
  return _then(_PromoDetailsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PromoDetailsStatus,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as PromoDetailsEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PromoDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoDetailsEntityCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $PromoDetailsEntityCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

// dart format on
