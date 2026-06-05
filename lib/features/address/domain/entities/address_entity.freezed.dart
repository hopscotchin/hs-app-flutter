// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressEntity {

 int get id; String get name; String get country; String get state; String get city; String get pincode; String get streetAddress; String get landmark; String get mobile; String get alternateMobile; bool get isDefault; bool get canCod; bool get canPol; bool get isServicable; String get simpleStreetAddress; String get displayAddress; String get address1; AddressLocationEntity? get location; AddressLocationEntity? get pinCodeLocation;
/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressEntityCopyWith<AddressEntity> get copyWith => _$AddressEntityCopyWithImpl<AddressEntity>(this as AddressEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state)&&(identical(other.city, city) || other.city == city)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.landmark, landmark) || other.landmark == landmark)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.alternateMobile, alternateMobile) || other.alternateMobile == alternateMobile)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.canCod, canCod) || other.canCod == canCod)&&(identical(other.canPol, canPol) || other.canPol == canPol)&&(identical(other.isServicable, isServicable) || other.isServicable == isServicable)&&(identical(other.simpleStreetAddress, simpleStreetAddress) || other.simpleStreetAddress == simpleStreetAddress)&&(identical(other.displayAddress, displayAddress) || other.displayAddress == displayAddress)&&(identical(other.address1, address1) || other.address1 == address1)&&(identical(other.location, location) || other.location == location)&&(identical(other.pinCodeLocation, pinCodeLocation) || other.pinCodeLocation == pinCodeLocation));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,country,state,city,pincode,streetAddress,landmark,mobile,alternateMobile,isDefault,canCod,canPol,isServicable,simpleStreetAddress,displayAddress,address1,location,pinCodeLocation]);

@override
String toString() {
  return 'AddressEntity(id: $id, name: $name, country: $country, state: $state, city: $city, pincode: $pincode, streetAddress: $streetAddress, landmark: $landmark, mobile: $mobile, alternateMobile: $alternateMobile, isDefault: $isDefault, canCod: $canCod, canPol: $canPol, isServicable: $isServicable, simpleStreetAddress: $simpleStreetAddress, displayAddress: $displayAddress, address1: $address1, location: $location, pinCodeLocation: $pinCodeLocation)';
}


}

/// @nodoc
abstract mixin class $AddressEntityCopyWith<$Res>  {
  factory $AddressEntityCopyWith(AddressEntity value, $Res Function(AddressEntity) _then) = _$AddressEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String country, String state, String city, String pincode, String streetAddress, String landmark, String mobile, String alternateMobile, bool isDefault, bool canCod, bool canPol, bool isServicable, String simpleStreetAddress, String displayAddress, String address1, AddressLocationEntity? location, AddressLocationEntity? pinCodeLocation
});


$AddressLocationEntityCopyWith<$Res>? get location;$AddressLocationEntityCopyWith<$Res>? get pinCodeLocation;

}
/// @nodoc
class _$AddressEntityCopyWithImpl<$Res>
    implements $AddressEntityCopyWith<$Res> {
  _$AddressEntityCopyWithImpl(this._self, this._then);

  final AddressEntity _self;
  final $Res Function(AddressEntity) _then;

/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? country = null,Object? state = null,Object? city = null,Object? pincode = null,Object? streetAddress = null,Object? landmark = null,Object? mobile = null,Object? alternateMobile = null,Object? isDefault = null,Object? canCod = null,Object? canPol = null,Object? isServicable = null,Object? simpleStreetAddress = null,Object? displayAddress = null,Object? address1 = null,Object? location = freezed,Object? pinCodeLocation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,pincode: null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,streetAddress: null == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String,landmark: null == landmark ? _self.landmark : landmark // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,alternateMobile: null == alternateMobile ? _self.alternateMobile : alternateMobile // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,canCod: null == canCod ? _self.canCod : canCod // ignore: cast_nullable_to_non_nullable
as bool,canPol: null == canPol ? _self.canPol : canPol // ignore: cast_nullable_to_non_nullable
as bool,isServicable: null == isServicable ? _self.isServicable : isServicable // ignore: cast_nullable_to_non_nullable
as bool,simpleStreetAddress: null == simpleStreetAddress ? _self.simpleStreetAddress : simpleStreetAddress // ignore: cast_nullable_to_non_nullable
as String,displayAddress: null == displayAddress ? _self.displayAddress : displayAddress // ignore: cast_nullable_to_non_nullable
as String,address1: null == address1 ? _self.address1 : address1 // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as AddressLocationEntity?,pinCodeLocation: freezed == pinCodeLocation ? _self.pinCodeLocation : pinCodeLocation // ignore: cast_nullable_to_non_nullable
as AddressLocationEntity?,
  ));
}
/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressLocationEntityCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $AddressLocationEntityCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressLocationEntityCopyWith<$Res>? get pinCodeLocation {
    if (_self.pinCodeLocation == null) {
    return null;
  }

  return $AddressLocationEntityCopyWith<$Res>(_self.pinCodeLocation!, (value) {
    return _then(_self.copyWith(pinCodeLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddressEntity].
extension AddressEntityPatterns on AddressEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressEntity value)  $default,){
final _that = this;
switch (_that) {
case _AddressEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AddressEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String country,  String state,  String city,  String pincode,  String streetAddress,  String landmark,  String mobile,  String alternateMobile,  bool isDefault,  bool canCod,  bool canPol,  bool isServicable,  String simpleStreetAddress,  String displayAddress,  String address1,  AddressLocationEntity? location,  AddressLocationEntity? pinCodeLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressEntity() when $default != null:
return $default(_that.id,_that.name,_that.country,_that.state,_that.city,_that.pincode,_that.streetAddress,_that.landmark,_that.mobile,_that.alternateMobile,_that.isDefault,_that.canCod,_that.canPol,_that.isServicable,_that.simpleStreetAddress,_that.displayAddress,_that.address1,_that.location,_that.pinCodeLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String country,  String state,  String city,  String pincode,  String streetAddress,  String landmark,  String mobile,  String alternateMobile,  bool isDefault,  bool canCod,  bool canPol,  bool isServicable,  String simpleStreetAddress,  String displayAddress,  String address1,  AddressLocationEntity? location,  AddressLocationEntity? pinCodeLocation)  $default,) {final _that = this;
switch (_that) {
case _AddressEntity():
return $default(_that.id,_that.name,_that.country,_that.state,_that.city,_that.pincode,_that.streetAddress,_that.landmark,_that.mobile,_that.alternateMobile,_that.isDefault,_that.canCod,_that.canPol,_that.isServicable,_that.simpleStreetAddress,_that.displayAddress,_that.address1,_that.location,_that.pinCodeLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String country,  String state,  String city,  String pincode,  String streetAddress,  String landmark,  String mobile,  String alternateMobile,  bool isDefault,  bool canCod,  bool canPol,  bool isServicable,  String simpleStreetAddress,  String displayAddress,  String address1,  AddressLocationEntity? location,  AddressLocationEntity? pinCodeLocation)?  $default,) {final _that = this;
switch (_that) {
case _AddressEntity() when $default != null:
return $default(_that.id,_that.name,_that.country,_that.state,_that.city,_that.pincode,_that.streetAddress,_that.landmark,_that.mobile,_that.alternateMobile,_that.isDefault,_that.canCod,_that.canPol,_that.isServicable,_that.simpleStreetAddress,_that.displayAddress,_that.address1,_that.location,_that.pinCodeLocation);case _:
  return null;

}
}

}

/// @nodoc


class _AddressEntity implements AddressEntity {
  const _AddressEntity({this.id = 0, this.name = '', this.country = '', this.state = '', this.city = '', this.pincode = '', this.streetAddress = '', this.landmark = '', this.mobile = '', this.alternateMobile = '', this.isDefault = false, this.canCod = false, this.canPol = false, this.isServicable = false, this.simpleStreetAddress = '', this.displayAddress = '', this.address1 = '', this.location, this.pinCodeLocation});
  

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String country;
@override@JsonKey() final  String state;
@override@JsonKey() final  String city;
@override@JsonKey() final  String pincode;
@override@JsonKey() final  String streetAddress;
@override@JsonKey() final  String landmark;
@override@JsonKey() final  String mobile;
@override@JsonKey() final  String alternateMobile;
@override@JsonKey() final  bool isDefault;
@override@JsonKey() final  bool canCod;
@override@JsonKey() final  bool canPol;
@override@JsonKey() final  bool isServicable;
@override@JsonKey() final  String simpleStreetAddress;
@override@JsonKey() final  String displayAddress;
@override@JsonKey() final  String address1;
@override final  AddressLocationEntity? location;
@override final  AddressLocationEntity? pinCodeLocation;

/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressEntityCopyWith<_AddressEntity> get copyWith => __$AddressEntityCopyWithImpl<_AddressEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state)&&(identical(other.city, city) || other.city == city)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.landmark, landmark) || other.landmark == landmark)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.alternateMobile, alternateMobile) || other.alternateMobile == alternateMobile)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.canCod, canCod) || other.canCod == canCod)&&(identical(other.canPol, canPol) || other.canPol == canPol)&&(identical(other.isServicable, isServicable) || other.isServicable == isServicable)&&(identical(other.simpleStreetAddress, simpleStreetAddress) || other.simpleStreetAddress == simpleStreetAddress)&&(identical(other.displayAddress, displayAddress) || other.displayAddress == displayAddress)&&(identical(other.address1, address1) || other.address1 == address1)&&(identical(other.location, location) || other.location == location)&&(identical(other.pinCodeLocation, pinCodeLocation) || other.pinCodeLocation == pinCodeLocation));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,country,state,city,pincode,streetAddress,landmark,mobile,alternateMobile,isDefault,canCod,canPol,isServicable,simpleStreetAddress,displayAddress,address1,location,pinCodeLocation]);

@override
String toString() {
  return 'AddressEntity(id: $id, name: $name, country: $country, state: $state, city: $city, pincode: $pincode, streetAddress: $streetAddress, landmark: $landmark, mobile: $mobile, alternateMobile: $alternateMobile, isDefault: $isDefault, canCod: $canCod, canPol: $canPol, isServicable: $isServicable, simpleStreetAddress: $simpleStreetAddress, displayAddress: $displayAddress, address1: $address1, location: $location, pinCodeLocation: $pinCodeLocation)';
}


}

/// @nodoc
abstract mixin class _$AddressEntityCopyWith<$Res> implements $AddressEntityCopyWith<$Res> {
  factory _$AddressEntityCopyWith(_AddressEntity value, $Res Function(_AddressEntity) _then) = __$AddressEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String country, String state, String city, String pincode, String streetAddress, String landmark, String mobile, String alternateMobile, bool isDefault, bool canCod, bool canPol, bool isServicable, String simpleStreetAddress, String displayAddress, String address1, AddressLocationEntity? location, AddressLocationEntity? pinCodeLocation
});


@override $AddressLocationEntityCopyWith<$Res>? get location;@override $AddressLocationEntityCopyWith<$Res>? get pinCodeLocation;

}
/// @nodoc
class __$AddressEntityCopyWithImpl<$Res>
    implements _$AddressEntityCopyWith<$Res> {
  __$AddressEntityCopyWithImpl(this._self, this._then);

  final _AddressEntity _self;
  final $Res Function(_AddressEntity) _then;

/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? country = null,Object? state = null,Object? city = null,Object? pincode = null,Object? streetAddress = null,Object? landmark = null,Object? mobile = null,Object? alternateMobile = null,Object? isDefault = null,Object? canCod = null,Object? canPol = null,Object? isServicable = null,Object? simpleStreetAddress = null,Object? displayAddress = null,Object? address1 = null,Object? location = freezed,Object? pinCodeLocation = freezed,}) {
  return _then(_AddressEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,pincode: null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,streetAddress: null == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String,landmark: null == landmark ? _self.landmark : landmark // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,alternateMobile: null == alternateMobile ? _self.alternateMobile : alternateMobile // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,canCod: null == canCod ? _self.canCod : canCod // ignore: cast_nullable_to_non_nullable
as bool,canPol: null == canPol ? _self.canPol : canPol // ignore: cast_nullable_to_non_nullable
as bool,isServicable: null == isServicable ? _self.isServicable : isServicable // ignore: cast_nullable_to_non_nullable
as bool,simpleStreetAddress: null == simpleStreetAddress ? _self.simpleStreetAddress : simpleStreetAddress // ignore: cast_nullable_to_non_nullable
as String,displayAddress: null == displayAddress ? _self.displayAddress : displayAddress // ignore: cast_nullable_to_non_nullable
as String,address1: null == address1 ? _self.address1 : address1 // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as AddressLocationEntity?,pinCodeLocation: freezed == pinCodeLocation ? _self.pinCodeLocation : pinCodeLocation // ignore: cast_nullable_to_non_nullable
as AddressLocationEntity?,
  ));
}

/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressLocationEntityCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $AddressLocationEntityCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of AddressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressLocationEntityCopyWith<$Res>? get pinCodeLocation {
    if (_self.pinCodeLocation == null) {
    return null;
  }

  return $AddressLocationEntityCopyWith<$Res>(_self.pinCodeLocation!, (value) {
    return _then(_self.copyWith(pinCodeLocation: value));
  });
}
}

/// @nodoc
mixin _$AddressLocationEntity {

 double get latitude; double get longitude;
/// Create a copy of AddressLocationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressLocationEntityCopyWith<AddressLocationEntity> get copyWith => _$AddressLocationEntityCopyWithImpl<AddressLocationEntity>(this as AddressLocationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLocationEntity&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'AddressLocationEntity(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $AddressLocationEntityCopyWith<$Res>  {
  factory $AddressLocationEntityCopyWith(AddressLocationEntity value, $Res Function(AddressLocationEntity) _then) = _$AddressLocationEntityCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$AddressLocationEntityCopyWithImpl<$Res>
    implements $AddressLocationEntityCopyWith<$Res> {
  _$AddressLocationEntityCopyWithImpl(this._self, this._then);

  final AddressLocationEntity _self;
  final $Res Function(AddressLocationEntity) _then;

/// Create a copy of AddressLocationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressLocationEntity].
extension AddressLocationEntityPatterns on AddressLocationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressLocationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressLocationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressLocationEntity value)  $default,){
final _that = this;
switch (_that) {
case _AddressLocationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressLocationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AddressLocationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressLocationEntity() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _AddressLocationEntity():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _AddressLocationEntity() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _AddressLocationEntity implements AddressLocationEntity {
  const _AddressLocationEntity({this.latitude = 0.0, this.longitude = 0.0});
  

@override@JsonKey() final  double latitude;
@override@JsonKey() final  double longitude;

/// Create a copy of AddressLocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressLocationEntityCopyWith<_AddressLocationEntity> get copyWith => __$AddressLocationEntityCopyWithImpl<_AddressLocationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressLocationEntity&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'AddressLocationEntity(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$AddressLocationEntityCopyWith<$Res> implements $AddressLocationEntityCopyWith<$Res> {
  factory _$AddressLocationEntityCopyWith(_AddressLocationEntity value, $Res Function(_AddressLocationEntity) _then) = __$AddressLocationEntityCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$AddressLocationEntityCopyWithImpl<$Res>
    implements _$AddressLocationEntityCopyWith<$Res> {
  __$AddressLocationEntityCopyWithImpl(this._self, this._then);

  final _AddressLocationEntity _self;
  final $Res Function(_AddressLocationEntity) _then;

/// Create a copy of AddressLocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_AddressLocationEntity(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
