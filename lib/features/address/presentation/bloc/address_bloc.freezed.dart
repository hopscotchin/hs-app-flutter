// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent()';
}


}

/// @nodoc
class $AddressEventCopyWith<$Res>  {
$AddressEventCopyWith(AddressEvent _, $Res Function(AddressEvent) __);
}


/// Adds pattern-matching-related methods to [AddressEvent].
extension AddressEventPatterns on AddressEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadAddresses value)?  load,TResult Function( RefreshAddresses value)?  refresh,TResult Function( DeleteAddress value)?  delete,TResult Function( ClearDeleteFeedback value)?  clearDeleteFeedback,TResult Function( SelectAddress value)?  select,TResult Function( ClearSelectFeedback value)?  clearSelectFeedback,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadAddresses() when load != null:
return load(_that);case RefreshAddresses() when refresh != null:
return refresh(_that);case DeleteAddress() when delete != null:
return delete(_that);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback(_that);case SelectAddress() when select != null:
return select(_that);case ClearSelectFeedback() when clearSelectFeedback != null:
return clearSelectFeedback(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadAddresses value)  load,required TResult Function( RefreshAddresses value)  refresh,required TResult Function( DeleteAddress value)  delete,required TResult Function( ClearDeleteFeedback value)  clearDeleteFeedback,required TResult Function( SelectAddress value)  select,required TResult Function( ClearSelectFeedback value)  clearSelectFeedback,}){
final _that = this;
switch (_that) {
case LoadAddresses():
return load(_that);case RefreshAddresses():
return refresh(_that);case DeleteAddress():
return delete(_that);case ClearDeleteFeedback():
return clearDeleteFeedback(_that);case SelectAddress():
return select(_that);case ClearSelectFeedback():
return clearSelectFeedback(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadAddresses value)?  load,TResult? Function( RefreshAddresses value)?  refresh,TResult? Function( DeleteAddress value)?  delete,TResult? Function( ClearDeleteFeedback value)?  clearDeleteFeedback,TResult? Function( SelectAddress value)?  select,TResult? Function( ClearSelectFeedback value)?  clearSelectFeedback,}){
final _that = this;
switch (_that) {
case LoadAddresses() when load != null:
return load(_that);case RefreshAddresses() when refresh != null:
return refresh(_that);case DeleteAddress() when delete != null:
return delete(_that);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback(_that);case SelectAddress() when select != null:
return select(_that);case ClearSelectFeedback() when clearSelectFeedback != null:
return clearSelectFeedback(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AddressSource source)?  load,TResult Function()?  refresh,TResult Function( int addressId)?  delete,TResult Function()?  clearDeleteFeedback,TResult Function( int addressId)?  select,TResult Function()?  clearSelectFeedback,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadAddresses() when load != null:
return load(_that.source);case RefreshAddresses() when refresh != null:
return refresh();case DeleteAddress() when delete != null:
return delete(_that.addressId);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback();case SelectAddress() when select != null:
return select(_that.addressId);case ClearSelectFeedback() when clearSelectFeedback != null:
return clearSelectFeedback();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AddressSource source)  load,required TResult Function()  refresh,required TResult Function( int addressId)  delete,required TResult Function()  clearDeleteFeedback,required TResult Function( int addressId)  select,required TResult Function()  clearSelectFeedback,}) {final _that = this;
switch (_that) {
case LoadAddresses():
return load(_that.source);case RefreshAddresses():
return refresh();case DeleteAddress():
return delete(_that.addressId);case ClearDeleteFeedback():
return clearDeleteFeedback();case SelectAddress():
return select(_that.addressId);case ClearSelectFeedback():
return clearSelectFeedback();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AddressSource source)?  load,TResult? Function()?  refresh,TResult? Function( int addressId)?  delete,TResult? Function()?  clearDeleteFeedback,TResult? Function( int addressId)?  select,TResult? Function()?  clearSelectFeedback,}) {final _that = this;
switch (_that) {
case LoadAddresses() when load != null:
return load(_that.source);case RefreshAddresses() when refresh != null:
return refresh();case DeleteAddress() when delete != null:
return delete(_that.addressId);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback();case SelectAddress() when select != null:
return select(_that.addressId);case ClearSelectFeedback() when clearSelectFeedback != null:
return clearSelectFeedback();case _:
  return null;

}
}

}

/// @nodoc


class LoadAddresses implements AddressEvent {
  const LoadAddresses({this.source = AddressSource.customer});
  

@JsonKey() final  AddressSource source;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadAddressesCopyWith<LoadAddresses> get copyWith => _$LoadAddressesCopyWithImpl<LoadAddresses>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAddresses&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,source);

@override
String toString() {
  return 'AddressEvent.load(source: $source)';
}


}

/// @nodoc
abstract mixin class $LoadAddressesCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory $LoadAddressesCopyWith(LoadAddresses value, $Res Function(LoadAddresses) _then) = _$LoadAddressesCopyWithImpl;
@useResult
$Res call({
 AddressSource source
});




}
/// @nodoc
class _$LoadAddressesCopyWithImpl<$Res>
    implements $LoadAddressesCopyWith<$Res> {
  _$LoadAddressesCopyWithImpl(this._self, this._then);

  final LoadAddresses _self;
  final $Res Function(LoadAddresses) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? source = null,}) {
  return _then(LoadAddresses(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AddressSource,
  ));
}


}

/// @nodoc


class RefreshAddresses implements AddressEvent {
  const RefreshAddresses();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshAddresses);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent.refresh()';
}


}




/// @nodoc


class DeleteAddress implements AddressEvent {
  const DeleteAddress(this.addressId);
  

 final  int addressId;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAddressCopyWith<DeleteAddress> get copyWith => _$DeleteAddressCopyWithImpl<DeleteAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAddress&&(identical(other.addressId, addressId) || other.addressId == addressId));
}


@override
int get hashCode => Object.hash(runtimeType,addressId);

@override
String toString() {
  return 'AddressEvent.delete(addressId: $addressId)';
}


}

/// @nodoc
abstract mixin class $DeleteAddressCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory $DeleteAddressCopyWith(DeleteAddress value, $Res Function(DeleteAddress) _then) = _$DeleteAddressCopyWithImpl;
@useResult
$Res call({
 int addressId
});




}
/// @nodoc
class _$DeleteAddressCopyWithImpl<$Res>
    implements $DeleteAddressCopyWith<$Res> {
  _$DeleteAddressCopyWithImpl(this._self, this._then);

  final DeleteAddress _self;
  final $Res Function(DeleteAddress) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addressId = null,}) {
  return _then(DeleteAddress(
null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ClearDeleteFeedback implements AddressEvent {
  const ClearDeleteFeedback();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearDeleteFeedback);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent.clearDeleteFeedback()';
}


}




/// @nodoc


class SelectAddress implements AddressEvent {
  const SelectAddress(this.addressId);
  

 final  int addressId;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectAddressCopyWith<SelectAddress> get copyWith => _$SelectAddressCopyWithImpl<SelectAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectAddress&&(identical(other.addressId, addressId) || other.addressId == addressId));
}


@override
int get hashCode => Object.hash(runtimeType,addressId);

@override
String toString() {
  return 'AddressEvent.select(addressId: $addressId)';
}


}

/// @nodoc
abstract mixin class $SelectAddressCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory $SelectAddressCopyWith(SelectAddress value, $Res Function(SelectAddress) _then) = _$SelectAddressCopyWithImpl;
@useResult
$Res call({
 int addressId
});




}
/// @nodoc
class _$SelectAddressCopyWithImpl<$Res>
    implements $SelectAddressCopyWith<$Res> {
  _$SelectAddressCopyWithImpl(this._self, this._then);

  final SelectAddress _self;
  final $Res Function(SelectAddress) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addressId = null,}) {
  return _then(SelectAddress(
null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ClearSelectFeedback implements AddressEvent {
  const ClearSelectFeedback();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearSelectFeedback);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent.clearSelectFeedback()';
}


}




/// @nodoc
mixin _$AddressState {

 AddressStatus get status; AddressSource get source; AddressesListEntity? get addresses; String? get errorMessage; int? get deletingId; String? get deleteSuccessMessage; String? get deleteError; int? get selectingId; bool get selectSucceeded; String? get selectError;
/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressStateCopyWith<AddressState> get copyWith => _$AddressStateCopyWithImpl<AddressState>(this as AddressState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressState&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.addresses, addresses) || other.addresses == addresses)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.deletingId, deletingId) || other.deletingId == deletingId)&&(identical(other.deleteSuccessMessage, deleteSuccessMessage) || other.deleteSuccessMessage == deleteSuccessMessage)&&(identical(other.deleteError, deleteError) || other.deleteError == deleteError)&&(identical(other.selectingId, selectingId) || other.selectingId == selectingId)&&(identical(other.selectSucceeded, selectSucceeded) || other.selectSucceeded == selectSucceeded)&&(identical(other.selectError, selectError) || other.selectError == selectError));
}


@override
int get hashCode => Object.hash(runtimeType,status,source,addresses,errorMessage,deletingId,deleteSuccessMessage,deleteError,selectingId,selectSucceeded,selectError);

@override
String toString() {
  return 'AddressState(status: $status, source: $source, addresses: $addresses, errorMessage: $errorMessage, deletingId: $deletingId, deleteSuccessMessage: $deleteSuccessMessage, deleteError: $deleteError, selectingId: $selectingId, selectSucceeded: $selectSucceeded, selectError: $selectError)';
}


}

/// @nodoc
abstract mixin class $AddressStateCopyWith<$Res>  {
  factory $AddressStateCopyWith(AddressState value, $Res Function(AddressState) _then) = _$AddressStateCopyWithImpl;
@useResult
$Res call({
 AddressStatus status, AddressSource source, AddressesListEntity? addresses, String? errorMessage, int? deletingId, String? deleteSuccessMessage, String? deleteError, int? selectingId, bool selectSucceeded, String? selectError
});


$AddressesListEntityCopyWith<$Res>? get addresses;

}
/// @nodoc
class _$AddressStateCopyWithImpl<$Res>
    implements $AddressStateCopyWith<$Res> {
  _$AddressStateCopyWithImpl(this._self, this._then);

  final AddressState _self;
  final $Res Function(AddressState) _then;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? source = null,Object? addresses = freezed,Object? errorMessage = freezed,Object? deletingId = freezed,Object? deleteSuccessMessage = freezed,Object? deleteError = freezed,Object? selectingId = freezed,Object? selectSucceeded = null,Object? selectError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AddressStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AddressSource,addresses: freezed == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as AddressesListEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,deletingId: freezed == deletingId ? _self.deletingId : deletingId // ignore: cast_nullable_to_non_nullable
as int?,deleteSuccessMessage: freezed == deleteSuccessMessage ? _self.deleteSuccessMessage : deleteSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,deleteError: freezed == deleteError ? _self.deleteError : deleteError // ignore: cast_nullable_to_non_nullable
as String?,selectingId: freezed == selectingId ? _self.selectingId : selectingId // ignore: cast_nullable_to_non_nullable
as int?,selectSucceeded: null == selectSucceeded ? _self.selectSucceeded : selectSucceeded // ignore: cast_nullable_to_non_nullable
as bool,selectError: freezed == selectError ? _self.selectError : selectError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressesListEntityCopyWith<$Res>? get addresses {
    if (_self.addresses == null) {
    return null;
  }

  return $AddressesListEntityCopyWith<$Res>(_self.addresses!, (value) {
    return _then(_self.copyWith(addresses: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddressState].
extension AddressStatePatterns on AddressState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressState value)  $default,){
final _that = this;
switch (_that) {
case _AddressState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressState value)?  $default,){
final _that = this;
switch (_that) {
case _AddressState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AddressStatus status,  AddressSource source,  AddressesListEntity? addresses,  String? errorMessage,  int? deletingId,  String? deleteSuccessMessage,  String? deleteError,  int? selectingId,  bool selectSucceeded,  String? selectError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressState() when $default != null:
return $default(_that.status,_that.source,_that.addresses,_that.errorMessage,_that.deletingId,_that.deleteSuccessMessage,_that.deleteError,_that.selectingId,_that.selectSucceeded,_that.selectError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AddressStatus status,  AddressSource source,  AddressesListEntity? addresses,  String? errorMessage,  int? deletingId,  String? deleteSuccessMessage,  String? deleteError,  int? selectingId,  bool selectSucceeded,  String? selectError)  $default,) {final _that = this;
switch (_that) {
case _AddressState():
return $default(_that.status,_that.source,_that.addresses,_that.errorMessage,_that.deletingId,_that.deleteSuccessMessage,_that.deleteError,_that.selectingId,_that.selectSucceeded,_that.selectError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AddressStatus status,  AddressSource source,  AddressesListEntity? addresses,  String? errorMessage,  int? deletingId,  String? deleteSuccessMessage,  String? deleteError,  int? selectingId,  bool selectSucceeded,  String? selectError)?  $default,) {final _that = this;
switch (_that) {
case _AddressState() when $default != null:
return $default(_that.status,_that.source,_that.addresses,_that.errorMessage,_that.deletingId,_that.deleteSuccessMessage,_that.deleteError,_that.selectingId,_that.selectSucceeded,_that.selectError);case _:
  return null;

}
}

}

/// @nodoc


class _AddressState implements AddressState {
  const _AddressState({this.status = AddressStatus.initial, this.source = AddressSource.customer, this.addresses, this.errorMessage, this.deletingId, this.deleteSuccessMessage, this.deleteError, this.selectingId, this.selectSucceeded = false, this.selectError});
  

@override@JsonKey() final  AddressStatus status;
@override@JsonKey() final  AddressSource source;
@override final  AddressesListEntity? addresses;
@override final  String? errorMessage;
@override final  int? deletingId;
@override final  String? deleteSuccessMessage;
@override final  String? deleteError;
@override final  int? selectingId;
@override@JsonKey() final  bool selectSucceeded;
@override final  String? selectError;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressStateCopyWith<_AddressState> get copyWith => __$AddressStateCopyWithImpl<_AddressState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressState&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.addresses, addresses) || other.addresses == addresses)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.deletingId, deletingId) || other.deletingId == deletingId)&&(identical(other.deleteSuccessMessage, deleteSuccessMessage) || other.deleteSuccessMessage == deleteSuccessMessage)&&(identical(other.deleteError, deleteError) || other.deleteError == deleteError)&&(identical(other.selectingId, selectingId) || other.selectingId == selectingId)&&(identical(other.selectSucceeded, selectSucceeded) || other.selectSucceeded == selectSucceeded)&&(identical(other.selectError, selectError) || other.selectError == selectError));
}


@override
int get hashCode => Object.hash(runtimeType,status,source,addresses,errorMessage,deletingId,deleteSuccessMessage,deleteError,selectingId,selectSucceeded,selectError);

@override
String toString() {
  return 'AddressState(status: $status, source: $source, addresses: $addresses, errorMessage: $errorMessage, deletingId: $deletingId, deleteSuccessMessage: $deleteSuccessMessage, deleteError: $deleteError, selectingId: $selectingId, selectSucceeded: $selectSucceeded, selectError: $selectError)';
}


}

/// @nodoc
abstract mixin class _$AddressStateCopyWith<$Res> implements $AddressStateCopyWith<$Res> {
  factory _$AddressStateCopyWith(_AddressState value, $Res Function(_AddressState) _then) = __$AddressStateCopyWithImpl;
@override @useResult
$Res call({
 AddressStatus status, AddressSource source, AddressesListEntity? addresses, String? errorMessage, int? deletingId, String? deleteSuccessMessage, String? deleteError, int? selectingId, bool selectSucceeded, String? selectError
});


@override $AddressesListEntityCopyWith<$Res>? get addresses;

}
/// @nodoc
class __$AddressStateCopyWithImpl<$Res>
    implements _$AddressStateCopyWith<$Res> {
  __$AddressStateCopyWithImpl(this._self, this._then);

  final _AddressState _self;
  final $Res Function(_AddressState) _then;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? source = null,Object? addresses = freezed,Object? errorMessage = freezed,Object? deletingId = freezed,Object? deleteSuccessMessage = freezed,Object? deleteError = freezed,Object? selectingId = freezed,Object? selectSucceeded = null,Object? selectError = freezed,}) {
  return _then(_AddressState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AddressStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AddressSource,addresses: freezed == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as AddressesListEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,deletingId: freezed == deletingId ? _self.deletingId : deletingId // ignore: cast_nullable_to_non_nullable
as int?,deleteSuccessMessage: freezed == deleteSuccessMessage ? _self.deleteSuccessMessage : deleteSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,deleteError: freezed == deleteError ? _self.deleteError : deleteError // ignore: cast_nullable_to_non_nullable
as String?,selectingId: freezed == selectingId ? _self.selectingId : selectingId // ignore: cast_nullable_to_non_nullable
as int?,selectSucceeded: null == selectSucceeded ? _self.selectSucceeded : selectSucceeded // ignore: cast_nullable_to_non_nullable
as bool,selectError: freezed == selectError ? _self.selectError : selectError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressesListEntityCopyWith<$Res>? get addresses {
    if (_self.addresses == null) {
    return null;
  }

  return $AddressesListEntityCopyWith<$Res>(_self.addresses!, (value) {
    return _then(_self.copyWith(addresses: value));
  });
}
}

// dart format on
