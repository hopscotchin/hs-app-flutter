// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pincode_check_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PincodeCheckEntity {

 String? get action; String? get message; List<SkuEntity> get skus; bool? get isServiceable; EddInfoEntity? get eddInfo; List<VisualCueEntity> get visualCues; List<ServiceGuaranteeEntity> get serviceGuarantee; String? get noPinCodeMessage;
/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PincodeCheckEntityCopyWith<PincodeCheckEntity> get copyWith => _$PincodeCheckEntityCopyWithImpl<PincodeCheckEntity>(this as PincodeCheckEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PincodeCheckEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.skus, skus)&&(identical(other.isServiceable, isServiceable) || other.isServiceable == isServiceable)&&(identical(other.eddInfo, eddInfo) || other.eddInfo == eddInfo)&&const DeepCollectionEquality().equals(other.visualCues, visualCues)&&const DeepCollectionEquality().equals(other.serviceGuarantee, serviceGuarantee)&&(identical(other.noPinCodeMessage, noPinCodeMessage) || other.noPinCodeMessage == noPinCodeMessage));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,const DeepCollectionEquality().hash(skus),isServiceable,eddInfo,const DeepCollectionEquality().hash(visualCues),const DeepCollectionEquality().hash(serviceGuarantee),noPinCodeMessage);

@override
String toString() {
  return 'PincodeCheckEntity(action: $action, message: $message, skus: $skus, isServiceable: $isServiceable, eddInfo: $eddInfo, visualCues: $visualCues, serviceGuarantee: $serviceGuarantee, noPinCodeMessage: $noPinCodeMessage)';
}


}

/// @nodoc
abstract mixin class $PincodeCheckEntityCopyWith<$Res>  {
  factory $PincodeCheckEntityCopyWith(PincodeCheckEntity value, $Res Function(PincodeCheckEntity) _then) = _$PincodeCheckEntityCopyWithImpl;
@useResult
$Res call({
 String? action, String? message, List<SkuEntity> skus, bool? isServiceable, EddInfoEntity? eddInfo, List<VisualCueEntity> visualCues, List<ServiceGuaranteeEntity> serviceGuarantee, String? noPinCodeMessage
});


$EddInfoEntityCopyWith<$Res>? get eddInfo;

}
/// @nodoc
class _$PincodeCheckEntityCopyWithImpl<$Res>
    implements $PincodeCheckEntityCopyWith<$Res> {
  _$PincodeCheckEntityCopyWithImpl(this._self, this._then);

  final PincodeCheckEntity _self;
  final $Res Function(PincodeCheckEntity) _then;

/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? message = freezed,Object? skus = null,Object? isServiceable = freezed,Object? eddInfo = freezed,Object? visualCues = null,Object? serviceGuarantee = null,Object? noPinCodeMessage = freezed,}) {
  return _then(_self.copyWith(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,skus: null == skus ? _self.skus : skus // ignore: cast_nullable_to_non_nullable
as List<SkuEntity>,isServiceable: freezed == isServiceable ? _self.isServiceable : isServiceable // ignore: cast_nullable_to_non_nullable
as bool?,eddInfo: freezed == eddInfo ? _self.eddInfo : eddInfo // ignore: cast_nullable_to_non_nullable
as EddInfoEntity?,visualCues: null == visualCues ? _self.visualCues : visualCues // ignore: cast_nullable_to_non_nullable
as List<VisualCueEntity>,serviceGuarantee: null == serviceGuarantee ? _self.serviceGuarantee : serviceGuarantee // ignore: cast_nullable_to_non_nullable
as List<ServiceGuaranteeEntity>,noPinCodeMessage: freezed == noPinCodeMessage ? _self.noPinCodeMessage : noPinCodeMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EddInfoEntityCopyWith<$Res>? get eddInfo {
    if (_self.eddInfo == null) {
    return null;
  }

  return $EddInfoEntityCopyWith<$Res>(_self.eddInfo!, (value) {
    return _then(_self.copyWith(eddInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [PincodeCheckEntity].
extension PincodeCheckEntityPatterns on PincodeCheckEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PincodeCheckEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PincodeCheckEntity value)  $default,){
final _that = this;
switch (_that) {
case _PincodeCheckEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PincodeCheckEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  String? message,  List<SkuEntity> skus,  bool? isServiceable,  EddInfoEntity? eddInfo,  List<VisualCueEntity> visualCues,  List<ServiceGuaranteeEntity> serviceGuarantee,  String? noPinCodeMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
return $default(_that.action,_that.message,_that.skus,_that.isServiceable,_that.eddInfo,_that.visualCues,_that.serviceGuarantee,_that.noPinCodeMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  String? message,  List<SkuEntity> skus,  bool? isServiceable,  EddInfoEntity? eddInfo,  List<VisualCueEntity> visualCues,  List<ServiceGuaranteeEntity> serviceGuarantee,  String? noPinCodeMessage)  $default,) {final _that = this;
switch (_that) {
case _PincodeCheckEntity():
return $default(_that.action,_that.message,_that.skus,_that.isServiceable,_that.eddInfo,_that.visualCues,_that.serviceGuarantee,_that.noPinCodeMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  String? message,  List<SkuEntity> skus,  bool? isServiceable,  EddInfoEntity? eddInfo,  List<VisualCueEntity> visualCues,  List<ServiceGuaranteeEntity> serviceGuarantee,  String? noPinCodeMessage)?  $default,) {final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
return $default(_that.action,_that.message,_that.skus,_that.isServiceable,_that.eddInfo,_that.visualCues,_that.serviceGuarantee,_that.noPinCodeMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PincodeCheckEntity implements PincodeCheckEntity {
  const _PincodeCheckEntity({this.action, this.message, final  List<SkuEntity> skus = const [], this.isServiceable, this.eddInfo, final  List<VisualCueEntity> visualCues = const [], final  List<ServiceGuaranteeEntity> serviceGuarantee = const [], this.noPinCodeMessage}): _skus = skus,_visualCues = visualCues,_serviceGuarantee = serviceGuarantee;
  

@override final  String? action;
@override final  String? message;
 final  List<SkuEntity> _skus;
@override@JsonKey() List<SkuEntity> get skus {
  if (_skus is EqualUnmodifiableListView) return _skus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skus);
}

@override final  bool? isServiceable;
@override final  EddInfoEntity? eddInfo;
 final  List<VisualCueEntity> _visualCues;
@override@JsonKey() List<VisualCueEntity> get visualCues {
  if (_visualCues is EqualUnmodifiableListView) return _visualCues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visualCues);
}

 final  List<ServiceGuaranteeEntity> _serviceGuarantee;
@override@JsonKey() List<ServiceGuaranteeEntity> get serviceGuarantee {
  if (_serviceGuarantee is EqualUnmodifiableListView) return _serviceGuarantee;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceGuarantee);
}

@override final  String? noPinCodeMessage;

/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PincodeCheckEntityCopyWith<_PincodeCheckEntity> get copyWith => __$PincodeCheckEntityCopyWithImpl<_PincodeCheckEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PincodeCheckEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._skus, _skus)&&(identical(other.isServiceable, isServiceable) || other.isServiceable == isServiceable)&&(identical(other.eddInfo, eddInfo) || other.eddInfo == eddInfo)&&const DeepCollectionEquality().equals(other._visualCues, _visualCues)&&const DeepCollectionEquality().equals(other._serviceGuarantee, _serviceGuarantee)&&(identical(other.noPinCodeMessage, noPinCodeMessage) || other.noPinCodeMessage == noPinCodeMessage));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,const DeepCollectionEquality().hash(_skus),isServiceable,eddInfo,const DeepCollectionEquality().hash(_visualCues),const DeepCollectionEquality().hash(_serviceGuarantee),noPinCodeMessage);

@override
String toString() {
  return 'PincodeCheckEntity(action: $action, message: $message, skus: $skus, isServiceable: $isServiceable, eddInfo: $eddInfo, visualCues: $visualCues, serviceGuarantee: $serviceGuarantee, noPinCodeMessage: $noPinCodeMessage)';
}


}

/// @nodoc
abstract mixin class _$PincodeCheckEntityCopyWith<$Res> implements $PincodeCheckEntityCopyWith<$Res> {
  factory _$PincodeCheckEntityCopyWith(_PincodeCheckEntity value, $Res Function(_PincodeCheckEntity) _then) = __$PincodeCheckEntityCopyWithImpl;
@override @useResult
$Res call({
 String? action, String? message, List<SkuEntity> skus, bool? isServiceable, EddInfoEntity? eddInfo, List<VisualCueEntity> visualCues, List<ServiceGuaranteeEntity> serviceGuarantee, String? noPinCodeMessage
});


@override $EddInfoEntityCopyWith<$Res>? get eddInfo;

}
/// @nodoc
class __$PincodeCheckEntityCopyWithImpl<$Res>
    implements _$PincodeCheckEntityCopyWith<$Res> {
  __$PincodeCheckEntityCopyWithImpl(this._self, this._then);

  final _PincodeCheckEntity _self;
  final $Res Function(_PincodeCheckEntity) _then;

/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? message = freezed,Object? skus = null,Object? isServiceable = freezed,Object? eddInfo = freezed,Object? visualCues = null,Object? serviceGuarantee = null,Object? noPinCodeMessage = freezed,}) {
  return _then(_PincodeCheckEntity(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,skus: null == skus ? _self._skus : skus // ignore: cast_nullable_to_non_nullable
as List<SkuEntity>,isServiceable: freezed == isServiceable ? _self.isServiceable : isServiceable // ignore: cast_nullable_to_non_nullable
as bool?,eddInfo: freezed == eddInfo ? _self.eddInfo : eddInfo // ignore: cast_nullable_to_non_nullable
as EddInfoEntity?,visualCues: null == visualCues ? _self._visualCues : visualCues // ignore: cast_nullable_to_non_nullable
as List<VisualCueEntity>,serviceGuarantee: null == serviceGuarantee ? _self._serviceGuarantee : serviceGuarantee // ignore: cast_nullable_to_non_nullable
as List<ServiceGuaranteeEntity>,noPinCodeMessage: freezed == noPinCodeMessage ? _self.noPinCodeMessage : noPinCodeMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EddInfoEntityCopyWith<$Res>? get eddInfo {
    if (_self.eddInfo == null) {
    return null;
  }

  return $EddInfoEntityCopyWith<$Res>(_self.eddInfo!, (value) {
    return _then(_self.copyWith(eddInfo: value));
  });
}
}

// dart format on
