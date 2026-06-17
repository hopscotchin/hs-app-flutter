// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pincode_sheet_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PincodeSheetEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PincodeSheetEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PincodeSheetEvent()';
}


}

/// @nodoc
class $PincodeSheetEventCopyWith<$Res>  {
$PincodeSheetEventCopyWith(PincodeSheetEvent _, $Res Function(PincodeSheetEvent) __);
}


/// Adds pattern-matching-related methods to [PincodeSheetEvent].
extension PincodeSheetEventPatterns on PincodeSheetEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OpenPincodeSheet value)?  open,TResult Function( SelectPincodeAddress value)?  selectAddress,TResult Function( FocusPincodeInput value)?  focusInput,TResult Function( PincodeInputChanged value)?  pincodeChanged,TResult Function( ApplyPincode value)?  apply,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OpenPincodeSheet() when open != null:
return open(_that);case SelectPincodeAddress() when selectAddress != null:
return selectAddress(_that);case FocusPincodeInput() when focusInput != null:
return focusInput(_that);case PincodeInputChanged() when pincodeChanged != null:
return pincodeChanged(_that);case ApplyPincode() when apply != null:
return apply(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OpenPincodeSheet value)  open,required TResult Function( SelectPincodeAddress value)  selectAddress,required TResult Function( FocusPincodeInput value)  focusInput,required TResult Function( PincodeInputChanged value)  pincodeChanged,required TResult Function( ApplyPincode value)  apply,}){
final _that = this;
switch (_that) {
case OpenPincodeSheet():
return open(_that);case SelectPincodeAddress():
return selectAddress(_that);case FocusPincodeInput():
return focusInput(_that);case PincodeInputChanged():
return pincodeChanged(_that);case ApplyPincode():
return apply(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OpenPincodeSheet value)?  open,TResult? Function( SelectPincodeAddress value)?  selectAddress,TResult? Function( FocusPincodeInput value)?  focusInput,TResult? Function( PincodeInputChanged value)?  pincodeChanged,TResult? Function( ApplyPincode value)?  apply,}){
final _that = this;
switch (_that) {
case OpenPincodeSheet() when open != null:
return open(_that);case SelectPincodeAddress() when selectAddress != null:
return selectAddress(_that);case FocusPincodeInput() when focusInput != null:
return focusInput(_that);case PincodeInputChanged() when pincodeChanged != null:
return pincodeChanged(_that);case ApplyPincode() when apply != null:
return apply(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  open,TResult Function( int addressId)?  selectAddress,TResult Function()?  focusInput,TResult Function( String pincode)?  pincodeChanged,TResult Function()?  apply,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OpenPincodeSheet() when open != null:
return open();case SelectPincodeAddress() when selectAddress != null:
return selectAddress(_that.addressId);case FocusPincodeInput() when focusInput != null:
return focusInput();case PincodeInputChanged() when pincodeChanged != null:
return pincodeChanged(_that.pincode);case ApplyPincode() when apply != null:
return apply();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  open,required TResult Function( int addressId)  selectAddress,required TResult Function()  focusInput,required TResult Function( String pincode)  pincodeChanged,required TResult Function()  apply,}) {final _that = this;
switch (_that) {
case OpenPincodeSheet():
return open();case SelectPincodeAddress():
return selectAddress(_that.addressId);case FocusPincodeInput():
return focusInput();case PincodeInputChanged():
return pincodeChanged(_that.pincode);case ApplyPincode():
return apply();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  open,TResult? Function( int addressId)?  selectAddress,TResult? Function()?  focusInput,TResult? Function( String pincode)?  pincodeChanged,TResult? Function()?  apply,}) {final _that = this;
switch (_that) {
case OpenPincodeSheet() when open != null:
return open();case SelectPincodeAddress() when selectAddress != null:
return selectAddress(_that.addressId);case FocusPincodeInput() when focusInput != null:
return focusInput();case PincodeInputChanged() when pincodeChanged != null:
return pincodeChanged(_that.pincode);case ApplyPincode() when apply != null:
return apply();case _:
  return null;

}
}

}

/// @nodoc


class OpenPincodeSheet implements PincodeSheetEvent {
  const OpenPincodeSheet();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenPincodeSheet);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PincodeSheetEvent.open()';
}


}




/// @nodoc


class SelectPincodeAddress implements PincodeSheetEvent {
  const SelectPincodeAddress(this.addressId);
  

 final  int addressId;

/// Create a copy of PincodeSheetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectPincodeAddressCopyWith<SelectPincodeAddress> get copyWith => _$SelectPincodeAddressCopyWithImpl<SelectPincodeAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectPincodeAddress&&(identical(other.addressId, addressId) || other.addressId == addressId));
}


@override
int get hashCode => Object.hash(runtimeType,addressId);

@override
String toString() {
  return 'PincodeSheetEvent.selectAddress(addressId: $addressId)';
}


}

/// @nodoc
abstract mixin class $SelectPincodeAddressCopyWith<$Res> implements $PincodeSheetEventCopyWith<$Res> {
  factory $SelectPincodeAddressCopyWith(SelectPincodeAddress value, $Res Function(SelectPincodeAddress) _then) = _$SelectPincodeAddressCopyWithImpl;
@useResult
$Res call({
 int addressId
});




}
/// @nodoc
class _$SelectPincodeAddressCopyWithImpl<$Res>
    implements $SelectPincodeAddressCopyWith<$Res> {
  _$SelectPincodeAddressCopyWithImpl(this._self, this._then);

  final SelectPincodeAddress _self;
  final $Res Function(SelectPincodeAddress) _then;

/// Create a copy of PincodeSheetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addressId = null,}) {
  return _then(SelectPincodeAddress(
null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class FocusPincodeInput implements PincodeSheetEvent {
  const FocusPincodeInput();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusPincodeInput);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PincodeSheetEvent.focusInput()';
}


}




/// @nodoc


class PincodeInputChanged implements PincodeSheetEvent {
  const PincodeInputChanged(this.pincode);
  

 final  String pincode;

/// Create a copy of PincodeSheetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PincodeInputChangedCopyWith<PincodeInputChanged> get copyWith => _$PincodeInputChangedCopyWithImpl<PincodeInputChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PincodeInputChanged&&(identical(other.pincode, pincode) || other.pincode == pincode));
}


@override
int get hashCode => Object.hash(runtimeType,pincode);

@override
String toString() {
  return 'PincodeSheetEvent.pincodeChanged(pincode: $pincode)';
}


}

/// @nodoc
abstract mixin class $PincodeInputChangedCopyWith<$Res> implements $PincodeSheetEventCopyWith<$Res> {
  factory $PincodeInputChangedCopyWith(PincodeInputChanged value, $Res Function(PincodeInputChanged) _then) = _$PincodeInputChangedCopyWithImpl;
@useResult
$Res call({
 String pincode
});




}
/// @nodoc
class _$PincodeInputChangedCopyWithImpl<$Res>
    implements $PincodeInputChangedCopyWith<$Res> {
  _$PincodeInputChangedCopyWithImpl(this._self, this._then);

  final PincodeInputChanged _self;
  final $Res Function(PincodeInputChanged) _then;

/// Create a copy of PincodeSheetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pincode = null,}) {
  return _then(PincodeInputChanged(
null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ApplyPincode implements PincodeSheetEvent {
  const ApplyPincode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyPincode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PincodeSheetEvent.apply()';
}


}




/// @nodoc
mixin _$PincodeSheetState {

 PincodeSheetStatus get status; List<AddressEntity> get addresses; int? get selectedAddressId; String get enteredPincode; String? get lastCheckedValidPincode; bool get isChecking; List<MessageBarEntity> get messageBars; String? get toastMessage; String? get popResult;
/// Create a copy of PincodeSheetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PincodeSheetStateCopyWith<PincodeSheetState> get copyWith => _$PincodeSheetStateCopyWithImpl<PincodeSheetState>(this as PincodeSheetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PincodeSheetState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.addresses, addresses)&&(identical(other.selectedAddressId, selectedAddressId) || other.selectedAddressId == selectedAddressId)&&(identical(other.enteredPincode, enteredPincode) || other.enteredPincode == enteredPincode)&&(identical(other.lastCheckedValidPincode, lastCheckedValidPincode) || other.lastCheckedValidPincode == lastCheckedValidPincode)&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&const DeepCollectionEquality().equals(other.messageBars, messageBars)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.popResult, popResult) || other.popResult == popResult));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(addresses),selectedAddressId,enteredPincode,lastCheckedValidPincode,isChecking,const DeepCollectionEquality().hash(messageBars),toastMessage,popResult);

@override
String toString() {
  return 'PincodeSheetState(status: $status, addresses: $addresses, selectedAddressId: $selectedAddressId, enteredPincode: $enteredPincode, lastCheckedValidPincode: $lastCheckedValidPincode, isChecking: $isChecking, messageBars: $messageBars, toastMessage: $toastMessage, popResult: $popResult)';
}


}

/// @nodoc
abstract mixin class $PincodeSheetStateCopyWith<$Res>  {
  factory $PincodeSheetStateCopyWith(PincodeSheetState value, $Res Function(PincodeSheetState) _then) = _$PincodeSheetStateCopyWithImpl;
@useResult
$Res call({
 PincodeSheetStatus status, List<AddressEntity> addresses, int? selectedAddressId, String enteredPincode, String? lastCheckedValidPincode, bool isChecking, List<MessageBarEntity> messageBars, String? toastMessage, String? popResult
});




}
/// @nodoc
class _$PincodeSheetStateCopyWithImpl<$Res>
    implements $PincodeSheetStateCopyWith<$Res> {
  _$PincodeSheetStateCopyWithImpl(this._self, this._then);

  final PincodeSheetState _self;
  final $Res Function(PincodeSheetState) _then;

/// Create a copy of PincodeSheetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? addresses = null,Object? selectedAddressId = freezed,Object? enteredPincode = null,Object? lastCheckedValidPincode = freezed,Object? isChecking = null,Object? messageBars = null,Object? toastMessage = freezed,Object? popResult = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PincodeSheetStatus,addresses: null == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,selectedAddressId: freezed == selectedAddressId ? _self.selectedAddressId : selectedAddressId // ignore: cast_nullable_to_non_nullable
as int?,enteredPincode: null == enteredPincode ? _self.enteredPincode : enteredPincode // ignore: cast_nullable_to_non_nullable
as String,lastCheckedValidPincode: freezed == lastCheckedValidPincode ? _self.lastCheckedValidPincode : lastCheckedValidPincode // ignore: cast_nullable_to_non_nullable
as String?,isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,toastMessage: freezed == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String?,popResult: freezed == popResult ? _self.popResult : popResult // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PincodeSheetState].
extension PincodeSheetStatePatterns on PincodeSheetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PincodeSheetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PincodeSheetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PincodeSheetState value)  $default,){
final _that = this;
switch (_that) {
case _PincodeSheetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PincodeSheetState value)?  $default,){
final _that = this;
switch (_that) {
case _PincodeSheetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PincodeSheetStatus status,  List<AddressEntity> addresses,  int? selectedAddressId,  String enteredPincode,  String? lastCheckedValidPincode,  bool isChecking,  List<MessageBarEntity> messageBars,  String? toastMessage,  String? popResult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PincodeSheetState() when $default != null:
return $default(_that.status,_that.addresses,_that.selectedAddressId,_that.enteredPincode,_that.lastCheckedValidPincode,_that.isChecking,_that.messageBars,_that.toastMessage,_that.popResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PincodeSheetStatus status,  List<AddressEntity> addresses,  int? selectedAddressId,  String enteredPincode,  String? lastCheckedValidPincode,  bool isChecking,  List<MessageBarEntity> messageBars,  String? toastMessage,  String? popResult)  $default,) {final _that = this;
switch (_that) {
case _PincodeSheetState():
return $default(_that.status,_that.addresses,_that.selectedAddressId,_that.enteredPincode,_that.lastCheckedValidPincode,_that.isChecking,_that.messageBars,_that.toastMessage,_that.popResult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PincodeSheetStatus status,  List<AddressEntity> addresses,  int? selectedAddressId,  String enteredPincode,  String? lastCheckedValidPincode,  bool isChecking,  List<MessageBarEntity> messageBars,  String? toastMessage,  String? popResult)?  $default,) {final _that = this;
switch (_that) {
case _PincodeSheetState() when $default != null:
return $default(_that.status,_that.addresses,_that.selectedAddressId,_that.enteredPincode,_that.lastCheckedValidPincode,_that.isChecking,_that.messageBars,_that.toastMessage,_that.popResult);case _:
  return null;

}
}

}

/// @nodoc


class _PincodeSheetState implements PincodeSheetState {
  const _PincodeSheetState({this.status = PincodeSheetStatus.initial, final  List<AddressEntity> addresses = const <AddressEntity>[], this.selectedAddressId, this.enteredPincode = '', this.lastCheckedValidPincode, this.isChecking = false, final  List<MessageBarEntity> messageBars = const <MessageBarEntity>[], this.toastMessage, this.popResult}): _addresses = addresses,_messageBars = messageBars;
  

@override@JsonKey() final  PincodeSheetStatus status;
 final  List<AddressEntity> _addresses;
@override@JsonKey() List<AddressEntity> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}

@override final  int? selectedAddressId;
@override@JsonKey() final  String enteredPincode;
@override final  String? lastCheckedValidPincode;
@override@JsonKey() final  bool isChecking;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}

@override final  String? toastMessage;
@override final  String? popResult;

/// Create a copy of PincodeSheetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PincodeSheetStateCopyWith<_PincodeSheetState> get copyWith => __$PincodeSheetStateCopyWithImpl<_PincodeSheetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PincodeSheetState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&(identical(other.selectedAddressId, selectedAddressId) || other.selectedAddressId == selectedAddressId)&&(identical(other.enteredPincode, enteredPincode) || other.enteredPincode == enteredPincode)&&(identical(other.lastCheckedValidPincode, lastCheckedValidPincode) || other.lastCheckedValidPincode == lastCheckedValidPincode)&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.popResult, popResult) || other.popResult == popResult));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_addresses),selectedAddressId,enteredPincode,lastCheckedValidPincode,isChecking,const DeepCollectionEquality().hash(_messageBars),toastMessage,popResult);

@override
String toString() {
  return 'PincodeSheetState(status: $status, addresses: $addresses, selectedAddressId: $selectedAddressId, enteredPincode: $enteredPincode, lastCheckedValidPincode: $lastCheckedValidPincode, isChecking: $isChecking, messageBars: $messageBars, toastMessage: $toastMessage, popResult: $popResult)';
}


}

/// @nodoc
abstract mixin class _$PincodeSheetStateCopyWith<$Res> implements $PincodeSheetStateCopyWith<$Res> {
  factory _$PincodeSheetStateCopyWith(_PincodeSheetState value, $Res Function(_PincodeSheetState) _then) = __$PincodeSheetStateCopyWithImpl;
@override @useResult
$Res call({
 PincodeSheetStatus status, List<AddressEntity> addresses, int? selectedAddressId, String enteredPincode, String? lastCheckedValidPincode, bool isChecking, List<MessageBarEntity> messageBars, String? toastMessage, String? popResult
});




}
/// @nodoc
class __$PincodeSheetStateCopyWithImpl<$Res>
    implements _$PincodeSheetStateCopyWith<$Res> {
  __$PincodeSheetStateCopyWithImpl(this._self, this._then);

  final _PincodeSheetState _self;
  final $Res Function(_PincodeSheetState) _then;

/// Create a copy of PincodeSheetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? addresses = null,Object? selectedAddressId = freezed,Object? enteredPincode = null,Object? lastCheckedValidPincode = freezed,Object? isChecking = null,Object? messageBars = null,Object? toastMessage = freezed,Object? popResult = freezed,}) {
  return _then(_PincodeSheetState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PincodeSheetStatus,addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,selectedAddressId: freezed == selectedAddressId ? _self.selectedAddressId : selectedAddressId // ignore: cast_nullable_to_non_nullable
as int?,enteredPincode: null == enteredPincode ? _self.enteredPincode : enteredPincode // ignore: cast_nullable_to_non_nullable
as String,lastCheckedValidPincode: freezed == lastCheckedValidPincode ? _self.lastCheckedValidPincode : lastCheckedValidPincode // ignore: cast_nullable_to_non_nullable
as String?,isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,toastMessage: freezed == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String?,popResult: freezed == popResult ? _self.popResult : popResult // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
