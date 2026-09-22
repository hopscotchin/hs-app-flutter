// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manage_kid_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManageKidEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManageKidEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ManageKidEvent()';
}


}

/// @nodoc
class $ManageKidEventCopyWith<$Res>  {
$ManageKidEventCopyWith(ManageKidEvent _, $Res Function(ManageKidEvent) __);
}


/// Adds pattern-matching-related methods to [ManageKidEvent].
extension ManageKidEventPatterns on ManageKidEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitManageKid value)?  init,TResult Function( NameChanged value)?  nameChanged,TResult Function( DobChanged value)?  dobChanged,TResult Function( GenderChanged value)?  genderChanged,TResult Function( ConsentChanged value)?  consentChanged,TResult Function( SubmitKid value)?  submit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitManageKid() when init != null:
return init(_that);case NameChanged() when nameChanged != null:
return nameChanged(_that);case DobChanged() when dobChanged != null:
return dobChanged(_that);case GenderChanged() when genderChanged != null:
return genderChanged(_that);case ConsentChanged() when consentChanged != null:
return consentChanged(_that);case SubmitKid() when submit != null:
return submit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitManageKid value)  init,required TResult Function( NameChanged value)  nameChanged,required TResult Function( DobChanged value)  dobChanged,required TResult Function( GenderChanged value)  genderChanged,required TResult Function( ConsentChanged value)  consentChanged,required TResult Function( SubmitKid value)  submit,}){
final _that = this;
switch (_that) {
case InitManageKid():
return init(_that);case NameChanged():
return nameChanged(_that);case DobChanged():
return dobChanged(_that);case GenderChanged():
return genderChanged(_that);case ConsentChanged():
return consentChanged(_that);case SubmitKid():
return submit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitManageKid value)?  init,TResult? Function( NameChanged value)?  nameChanged,TResult? Function( DobChanged value)?  dobChanged,TResult? Function( GenderChanged value)?  genderChanged,TResult? Function( ConsentChanged value)?  consentChanged,TResult? Function( SubmitKid value)?  submit,}){
final _that = this;
switch (_that) {
case InitManageKid() when init != null:
return init(_that);case NameChanged() when nameChanged != null:
return nameChanged(_that);case DobChanged() when dobChanged != null:
return dobChanged(_that);case GenderChanged() when genderChanged != null:
return genderChanged(_that);case ConsentChanged() when consentChanged != null:
return consentChanged(_that);case SubmitKid() when submit != null:
return submit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ChildEntity? existing)?  init,TResult Function( String name)?  nameChanged,TResult Function( DateTime dob)?  dobChanged,TResult Function( ChildGender gender)?  genderChanged,TResult Function( bool given)?  consentChanged,TResult Function()?  submit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitManageKid() when init != null:
return init(_that.existing);case NameChanged() when nameChanged != null:
return nameChanged(_that.name);case DobChanged() when dobChanged != null:
return dobChanged(_that.dob);case GenderChanged() when genderChanged != null:
return genderChanged(_that.gender);case ConsentChanged() when consentChanged != null:
return consentChanged(_that.given);case SubmitKid() when submit != null:
return submit();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ChildEntity? existing)  init,required TResult Function( String name)  nameChanged,required TResult Function( DateTime dob)  dobChanged,required TResult Function( ChildGender gender)  genderChanged,required TResult Function( bool given)  consentChanged,required TResult Function()  submit,}) {final _that = this;
switch (_that) {
case InitManageKid():
return init(_that.existing);case NameChanged():
return nameChanged(_that.name);case DobChanged():
return dobChanged(_that.dob);case GenderChanged():
return genderChanged(_that.gender);case ConsentChanged():
return consentChanged(_that.given);case SubmitKid():
return submit();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ChildEntity? existing)?  init,TResult? Function( String name)?  nameChanged,TResult? Function( DateTime dob)?  dobChanged,TResult? Function( ChildGender gender)?  genderChanged,TResult? Function( bool given)?  consentChanged,TResult? Function()?  submit,}) {final _that = this;
switch (_that) {
case InitManageKid() when init != null:
return init(_that.existing);case NameChanged() when nameChanged != null:
return nameChanged(_that.name);case DobChanged() when dobChanged != null:
return dobChanged(_that.dob);case GenderChanged() when genderChanged != null:
return genderChanged(_that.gender);case ConsentChanged() when consentChanged != null:
return consentChanged(_that.given);case SubmitKid() when submit != null:
return submit();case _:
  return null;

}
}

}

/// @nodoc


class InitManageKid implements ManageKidEvent {
  const InitManageKid(this.existing);
  

 final  ChildEntity? existing;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitManageKidCopyWith<InitManageKid> get copyWith => _$InitManageKidCopyWithImpl<InitManageKid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitManageKid&&(identical(other.existing, existing) || other.existing == existing));
}


@override
int get hashCode => Object.hash(runtimeType,existing);

@override
String toString() {
  return 'ManageKidEvent.init(existing: $existing)';
}


}

/// @nodoc
abstract mixin class $InitManageKidCopyWith<$Res> implements $ManageKidEventCopyWith<$Res> {
  factory $InitManageKidCopyWith(InitManageKid value, $Res Function(InitManageKid) _then) = _$InitManageKidCopyWithImpl;
@useResult
$Res call({
 ChildEntity? existing
});


$ChildEntityCopyWith<$Res>? get existing;

}
/// @nodoc
class _$InitManageKidCopyWithImpl<$Res>
    implements $InitManageKidCopyWith<$Res> {
  _$InitManageKidCopyWithImpl(this._self, this._then);

  final InitManageKid _self;
  final $Res Function(InitManageKid) _then;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? existing = freezed,}) {
  return _then(InitManageKid(
freezed == existing ? _self.existing : existing // ignore: cast_nullable_to_non_nullable
as ChildEntity?,
  ));
}

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildEntityCopyWith<$Res>? get existing {
    if (_self.existing == null) {
    return null;
  }

  return $ChildEntityCopyWith<$Res>(_self.existing!, (value) {
    return _then(_self.copyWith(existing: value));
  });
}
}

/// @nodoc


class NameChanged implements ManageKidEvent {
  const NameChanged(this.name);
  

 final  String name;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameChangedCopyWith<NameChanged> get copyWith => _$NameChangedCopyWithImpl<NameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameChanged&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ManageKidEvent.nameChanged(name: $name)';
}


}

/// @nodoc
abstract mixin class $NameChangedCopyWith<$Res> implements $ManageKidEventCopyWith<$Res> {
  factory $NameChangedCopyWith(NameChanged value, $Res Function(NameChanged) _then) = _$NameChangedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$NameChangedCopyWithImpl<$Res>
    implements $NameChangedCopyWith<$Res> {
  _$NameChangedCopyWithImpl(this._self, this._then);

  final NameChanged _self;
  final $Res Function(NameChanged) _then;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(NameChanged(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DobChanged implements ManageKidEvent {
  const DobChanged(this.dob);
  

 final  DateTime dob;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DobChangedCopyWith<DobChanged> get copyWith => _$DobChangedCopyWithImpl<DobChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DobChanged&&(identical(other.dob, dob) || other.dob == dob));
}


@override
int get hashCode => Object.hash(runtimeType,dob);

@override
String toString() {
  return 'ManageKidEvent.dobChanged(dob: $dob)';
}


}

/// @nodoc
abstract mixin class $DobChangedCopyWith<$Res> implements $ManageKidEventCopyWith<$Res> {
  factory $DobChangedCopyWith(DobChanged value, $Res Function(DobChanged) _then) = _$DobChangedCopyWithImpl;
@useResult
$Res call({
 DateTime dob
});




}
/// @nodoc
class _$DobChangedCopyWithImpl<$Res>
    implements $DobChangedCopyWith<$Res> {
  _$DobChangedCopyWithImpl(this._self, this._then);

  final DobChanged _self;
  final $Res Function(DobChanged) _then;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dob = null,}) {
  return _then(DobChanged(
null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class GenderChanged implements ManageKidEvent {
  const GenderChanged(this.gender);
  

 final  ChildGender gender;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenderChangedCopyWith<GenderChanged> get copyWith => _$GenderChangedCopyWithImpl<GenderChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenderChanged&&(identical(other.gender, gender) || other.gender == gender));
}


@override
int get hashCode => Object.hash(runtimeType,gender);

@override
String toString() {
  return 'ManageKidEvent.genderChanged(gender: $gender)';
}


}

/// @nodoc
abstract mixin class $GenderChangedCopyWith<$Res> implements $ManageKidEventCopyWith<$Res> {
  factory $GenderChangedCopyWith(GenderChanged value, $Res Function(GenderChanged) _then) = _$GenderChangedCopyWithImpl;
@useResult
$Res call({
 ChildGender gender
});




}
/// @nodoc
class _$GenderChangedCopyWithImpl<$Res>
    implements $GenderChangedCopyWith<$Res> {
  _$GenderChangedCopyWithImpl(this._self, this._then);

  final GenderChanged _self;
  final $Res Function(GenderChanged) _then;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gender = null,}) {
  return _then(GenderChanged(
null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as ChildGender,
  ));
}


}

/// @nodoc


class ConsentChanged implements ManageKidEvent {
  const ConsentChanged(this.given);
  

 final  bool given;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentChangedCopyWith<ConsentChanged> get copyWith => _$ConsentChangedCopyWithImpl<ConsentChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentChanged&&(identical(other.given, given) || other.given == given));
}


@override
int get hashCode => Object.hash(runtimeType,given);

@override
String toString() {
  return 'ManageKidEvent.consentChanged(given: $given)';
}


}

/// @nodoc
abstract mixin class $ConsentChangedCopyWith<$Res> implements $ManageKidEventCopyWith<$Res> {
  factory $ConsentChangedCopyWith(ConsentChanged value, $Res Function(ConsentChanged) _then) = _$ConsentChangedCopyWithImpl;
@useResult
$Res call({
 bool given
});




}
/// @nodoc
class _$ConsentChangedCopyWithImpl<$Res>
    implements $ConsentChangedCopyWith<$Res> {
  _$ConsentChangedCopyWithImpl(this._self, this._then);

  final ConsentChanged _self;
  final $Res Function(ConsentChanged) _then;

/// Create a copy of ManageKidEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? given = null,}) {
  return _then(ConsentChanged(
null == given ? _self.given : given // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SubmitKid implements ManageKidEvent {
  const SubmitKid();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitKid);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ManageKidEvent.submit()';
}


}




/// @nodoc
mixin _$ManageKidState {

 ManageKidMode get mode; ChildEntity? get original; String get name;// Nullable and unset by default — neither Boy nor Girl is pre-selected;
// the user must actively choose one (checked in validation before submit).
 ChildGender? get gender; DateTime? get dob;// Unchecked by default on create — consent must be an explicit opt-in
// action by the user, not a pre-ticked box. `_onInit` overrides this to
// the stored value on edit, where consent was already given when the
// child was created.
 bool get consentGiven;// Set when submit is attempted with an unchecked consent box — driven
// inline under the checkbox (red border + message) instead of the
// generic bottom toast, per the updated Figma. Cleared as soon as the
// user checks the box.
 bool get consentError; bool get isSubmitting;// Field-validation failure (name/gender/dob) — shown as a bottom toast.
 String? get submitError;// Save-call failure at the network/server level — shown as an inline
// banner at the top of the form instead, since it's not something the
// user can fix by editing a field.
 String? get apiError; ChildEntity? get saved;
/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManageKidStateCopyWith<ManageKidState> get copyWith => _$ManageKidStateCopyWithImpl<ManageKidState>(this as ManageKidState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManageKidState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.original, original) || other.original == original)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.consentGiven, consentGiven) || other.consentGiven == consentGiven)&&(identical(other.consentError, consentError) || other.consentError == consentError)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitError, submitError) || other.submitError == submitError)&&(identical(other.apiError, apiError) || other.apiError == apiError)&&(identical(other.saved, saved) || other.saved == saved));
}


@override
int get hashCode => Object.hash(runtimeType,mode,original,name,gender,dob,consentGiven,consentError,isSubmitting,submitError,apiError,saved);

@override
String toString() {
  return 'ManageKidState(mode: $mode, original: $original, name: $name, gender: $gender, dob: $dob, consentGiven: $consentGiven, consentError: $consentError, isSubmitting: $isSubmitting, submitError: $submitError, apiError: $apiError, saved: $saved)';
}


}

/// @nodoc
abstract mixin class $ManageKidStateCopyWith<$Res>  {
  factory $ManageKidStateCopyWith(ManageKidState value, $Res Function(ManageKidState) _then) = _$ManageKidStateCopyWithImpl;
@useResult
$Res call({
 ManageKidMode mode, ChildEntity? original, String name, ChildGender? gender, DateTime? dob, bool consentGiven, bool consentError, bool isSubmitting, String? submitError, String? apiError, ChildEntity? saved
});


$ChildEntityCopyWith<$Res>? get original;$ChildEntityCopyWith<$Res>? get saved;

}
/// @nodoc
class _$ManageKidStateCopyWithImpl<$Res>
    implements $ManageKidStateCopyWith<$Res> {
  _$ManageKidStateCopyWithImpl(this._self, this._then);

  final ManageKidState _self;
  final $Res Function(ManageKidState) _then;

/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? original = freezed,Object? name = null,Object? gender = freezed,Object? dob = freezed,Object? consentGiven = null,Object? consentError = null,Object? isSubmitting = null,Object? submitError = freezed,Object? apiError = freezed,Object? saved = freezed,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ManageKidMode,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as ChildEntity?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as ChildGender?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,consentGiven: null == consentGiven ? _self.consentGiven : consentGiven // ignore: cast_nullable_to_non_nullable
as bool,consentError: null == consentError ? _self.consentError : consentError // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as String?,apiError: freezed == apiError ? _self.apiError : apiError // ignore: cast_nullable_to_non_nullable
as String?,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as ChildEntity?,
  ));
}
/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildEntityCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $ChildEntityCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildEntityCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $ChildEntityCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}


/// Adds pattern-matching-related methods to [ManageKidState].
extension ManageKidStatePatterns on ManageKidState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManageKidState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManageKidState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManageKidState value)  $default,){
final _that = this;
switch (_that) {
case _ManageKidState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManageKidState value)?  $default,){
final _that = this;
switch (_that) {
case _ManageKidState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ManageKidMode mode,  ChildEntity? original,  String name,  ChildGender? gender,  DateTime? dob,  bool consentGiven,  bool consentError,  bool isSubmitting,  String? submitError,  String? apiError,  ChildEntity? saved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManageKidState() when $default != null:
return $default(_that.mode,_that.original,_that.name,_that.gender,_that.dob,_that.consentGiven,_that.consentError,_that.isSubmitting,_that.submitError,_that.apiError,_that.saved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ManageKidMode mode,  ChildEntity? original,  String name,  ChildGender? gender,  DateTime? dob,  bool consentGiven,  bool consentError,  bool isSubmitting,  String? submitError,  String? apiError,  ChildEntity? saved)  $default,) {final _that = this;
switch (_that) {
case _ManageKidState():
return $default(_that.mode,_that.original,_that.name,_that.gender,_that.dob,_that.consentGiven,_that.consentError,_that.isSubmitting,_that.submitError,_that.apiError,_that.saved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ManageKidMode mode,  ChildEntity? original,  String name,  ChildGender? gender,  DateTime? dob,  bool consentGiven,  bool consentError,  bool isSubmitting,  String? submitError,  String? apiError,  ChildEntity? saved)?  $default,) {final _that = this;
switch (_that) {
case _ManageKidState() when $default != null:
return $default(_that.mode,_that.original,_that.name,_that.gender,_that.dob,_that.consentGiven,_that.consentError,_that.isSubmitting,_that.submitError,_that.apiError,_that.saved);case _:
  return null;

}
}

}

/// @nodoc


class _ManageKidState implements ManageKidState {
  const _ManageKidState({this.mode = ManageKidMode.create, this.original, this.name = '', this.gender, this.dob, this.consentGiven = false, this.consentError = false, this.isSubmitting = false, this.submitError, this.apiError, this.saved});
  

@override@JsonKey() final  ManageKidMode mode;
@override final  ChildEntity? original;
@override@JsonKey() final  String name;
// Nullable and unset by default — neither Boy nor Girl is pre-selected;
// the user must actively choose one (checked in validation before submit).
@override final  ChildGender? gender;
@override final  DateTime? dob;
// Unchecked by default on create — consent must be an explicit opt-in
// action by the user, not a pre-ticked box. `_onInit` overrides this to
// the stored value on edit, where consent was already given when the
// child was created.
@override@JsonKey() final  bool consentGiven;
// Set when submit is attempted with an unchecked consent box — driven
// inline under the checkbox (red border + message) instead of the
// generic bottom toast, per the updated Figma. Cleared as soon as the
// user checks the box.
@override@JsonKey() final  bool consentError;
@override@JsonKey() final  bool isSubmitting;
// Field-validation failure (name/gender/dob) — shown as a bottom toast.
@override final  String? submitError;
// Save-call failure at the network/server level — shown as an inline
// banner at the top of the form instead, since it's not something the
// user can fix by editing a field.
@override final  String? apiError;
@override final  ChildEntity? saved;

/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManageKidStateCopyWith<_ManageKidState> get copyWith => __$ManageKidStateCopyWithImpl<_ManageKidState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManageKidState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.original, original) || other.original == original)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.consentGiven, consentGiven) || other.consentGiven == consentGiven)&&(identical(other.consentError, consentError) || other.consentError == consentError)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitError, submitError) || other.submitError == submitError)&&(identical(other.apiError, apiError) || other.apiError == apiError)&&(identical(other.saved, saved) || other.saved == saved));
}


@override
int get hashCode => Object.hash(runtimeType,mode,original,name,gender,dob,consentGiven,consentError,isSubmitting,submitError,apiError,saved);

@override
String toString() {
  return 'ManageKidState(mode: $mode, original: $original, name: $name, gender: $gender, dob: $dob, consentGiven: $consentGiven, consentError: $consentError, isSubmitting: $isSubmitting, submitError: $submitError, apiError: $apiError, saved: $saved)';
}


}

/// @nodoc
abstract mixin class _$ManageKidStateCopyWith<$Res> implements $ManageKidStateCopyWith<$Res> {
  factory _$ManageKidStateCopyWith(_ManageKidState value, $Res Function(_ManageKidState) _then) = __$ManageKidStateCopyWithImpl;
@override @useResult
$Res call({
 ManageKidMode mode, ChildEntity? original, String name, ChildGender? gender, DateTime? dob, bool consentGiven, bool consentError, bool isSubmitting, String? submitError, String? apiError, ChildEntity? saved
});


@override $ChildEntityCopyWith<$Res>? get original;@override $ChildEntityCopyWith<$Res>? get saved;

}
/// @nodoc
class __$ManageKidStateCopyWithImpl<$Res>
    implements _$ManageKidStateCopyWith<$Res> {
  __$ManageKidStateCopyWithImpl(this._self, this._then);

  final _ManageKidState _self;
  final $Res Function(_ManageKidState) _then;

/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? original = freezed,Object? name = null,Object? gender = freezed,Object? dob = freezed,Object? consentGiven = null,Object? consentError = null,Object? isSubmitting = null,Object? submitError = freezed,Object? apiError = freezed,Object? saved = freezed,}) {
  return _then(_ManageKidState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ManageKidMode,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as ChildEntity?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as ChildGender?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,consentGiven: null == consentGiven ? _self.consentGiven : consentGiven // ignore: cast_nullable_to_non_nullable
as bool,consentError: null == consentError ? _self.consentError : consentError // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as String?,apiError: freezed == apiError ? _self.apiError : apiError // ignore: cast_nullable_to_non_nullable
as String?,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as ChildEntity?,
  ));
}

/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildEntityCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $ChildEntityCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of ManageKidState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildEntityCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $ChildEntityCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}

// dart format on
