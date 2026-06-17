// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plp_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlpListItem {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlpListItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlpListItem()';
}


}

/// @nodoc
class $PlpListItemCopyWith<$Res>  {
$PlpListItemCopyWith(PlpListItem _, $Res Function(PlpListItem) __);
}


/// Adds pattern-matching-related methods to [PlpListItem].
extension PlpListItemPatterns on PlpListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductRowItem value)?  productRow,TResult Function( ProductXLItem value)?  productXL,TResult Function( FloatingFilterItem value)?  floatingFilter,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductRowItem() when productRow != null:
return productRow(_that);case ProductXLItem() when productXL != null:
return productXL(_that);case FloatingFilterItem() when floatingFilter != null:
return floatingFilter(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductRowItem value)  productRow,required TResult Function( ProductXLItem value)  productXL,required TResult Function( FloatingFilterItem value)  floatingFilter,}){
final _that = this;
switch (_that) {
case ProductRowItem():
return productRow(_that);case ProductXLItem():
return productXL(_that);case FloatingFilterItem():
return floatingFilter(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductRowItem value)?  productRow,TResult? Function( ProductXLItem value)?  productXL,TResult? Function( FloatingFilterItem value)?  floatingFilter,}){
final _that = this;
switch (_that) {
case ProductRowItem() when productRow != null:
return productRow(_that);case ProductXLItem() when productXL != null:
return productXL(_that);case FloatingFilterItem() when floatingFilter != null:
return floatingFilter(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ListingProductEntity left,  ListingProductEntity? right)?  productRow,TResult Function( ListingProductEntity product)?  productXL,TResult Function( FloatingFilterSectionEntity section)?  floatingFilter,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductRowItem() when productRow != null:
return productRow(_that.left,_that.right);case ProductXLItem() when productXL != null:
return productXL(_that.product);case FloatingFilterItem() when floatingFilter != null:
return floatingFilter(_that.section);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ListingProductEntity left,  ListingProductEntity? right)  productRow,required TResult Function( ListingProductEntity product)  productXL,required TResult Function( FloatingFilterSectionEntity section)  floatingFilter,}) {final _that = this;
switch (_that) {
case ProductRowItem():
return productRow(_that.left,_that.right);case ProductXLItem():
return productXL(_that.product);case FloatingFilterItem():
return floatingFilter(_that.section);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ListingProductEntity left,  ListingProductEntity? right)?  productRow,TResult? Function( ListingProductEntity product)?  productXL,TResult? Function( FloatingFilterSectionEntity section)?  floatingFilter,}) {final _that = this;
switch (_that) {
case ProductRowItem() when productRow != null:
return productRow(_that.left,_that.right);case ProductXLItem() when productXL != null:
return productXL(_that.product);case FloatingFilterItem() when floatingFilter != null:
return floatingFilter(_that.section);case _:
  return null;

}
}

}

/// @nodoc


class ProductRowItem implements PlpListItem {
  const ProductRowItem({required this.left, this.right});
  

 final  ListingProductEntity left;
 final  ListingProductEntity? right;

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductRowItemCopyWith<ProductRowItem> get copyWith => _$ProductRowItemCopyWithImpl<ProductRowItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductRowItem&&(identical(other.left, left) || other.left == left)&&(identical(other.right, right) || other.right == right));
}


@override
int get hashCode => Object.hash(runtimeType,left,right);

@override
String toString() {
  return 'PlpListItem.productRow(left: $left, right: $right)';
}


}

/// @nodoc
abstract mixin class $ProductRowItemCopyWith<$Res> implements $PlpListItemCopyWith<$Res> {
  factory $ProductRowItemCopyWith(ProductRowItem value, $Res Function(ProductRowItem) _then) = _$ProductRowItemCopyWithImpl;
@useResult
$Res call({
 ListingProductEntity left, ListingProductEntity? right
});


$ListingProductEntityCopyWith<$Res> get left;$ListingProductEntityCopyWith<$Res>? get right;

}
/// @nodoc
class _$ProductRowItemCopyWithImpl<$Res>
    implements $ProductRowItemCopyWith<$Res> {
  _$ProductRowItemCopyWithImpl(this._self, this._then);

  final ProductRowItem _self;
  final $Res Function(ProductRowItem) _then;

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? left = null,Object? right = freezed,}) {
  return _then(ProductRowItem(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as ListingProductEntity,right: freezed == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as ListingProductEntity?,
  ));
}

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingProductEntityCopyWith<$Res> get left {
  
  return $ListingProductEntityCopyWith<$Res>(_self.left, (value) {
    return _then(_self.copyWith(left: value));
  });
}/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingProductEntityCopyWith<$Res>? get right {
    if (_self.right == null) {
    return null;
  }

  return $ListingProductEntityCopyWith<$Res>(_self.right!, (value) {
    return _then(_self.copyWith(right: value));
  });
}
}

/// @nodoc


class ProductXLItem implements PlpListItem {
  const ProductXLItem({required this.product});
  

 final  ListingProductEntity product;

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductXLItemCopyWith<ProductXLItem> get copyWith => _$ProductXLItemCopyWithImpl<ProductXLItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductXLItem&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'PlpListItem.productXL(product: $product)';
}


}

/// @nodoc
abstract mixin class $ProductXLItemCopyWith<$Res> implements $PlpListItemCopyWith<$Res> {
  factory $ProductXLItemCopyWith(ProductXLItem value, $Res Function(ProductXLItem) _then) = _$ProductXLItemCopyWithImpl;
@useResult
$Res call({
 ListingProductEntity product
});


$ListingProductEntityCopyWith<$Res> get product;

}
/// @nodoc
class _$ProductXLItemCopyWithImpl<$Res>
    implements $ProductXLItemCopyWith<$Res> {
  _$ProductXLItemCopyWithImpl(this._self, this._then);

  final ProductXLItem _self;
  final $Res Function(ProductXLItem) _then;

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(ProductXLItem(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ListingProductEntity,
  ));
}

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingProductEntityCopyWith<$Res> get product {
  
  return $ListingProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class FloatingFilterItem implements PlpListItem {
  const FloatingFilterItem({required this.section});
  

 final  FloatingFilterSectionEntity section;

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloatingFilterItemCopyWith<FloatingFilterItem> get copyWith => _$FloatingFilterItemCopyWithImpl<FloatingFilterItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloatingFilterItem&&(identical(other.section, section) || other.section == section));
}


@override
int get hashCode => Object.hash(runtimeType,section);

@override
String toString() {
  return 'PlpListItem.floatingFilter(section: $section)';
}


}

/// @nodoc
abstract mixin class $FloatingFilterItemCopyWith<$Res> implements $PlpListItemCopyWith<$Res> {
  factory $FloatingFilterItemCopyWith(FloatingFilterItem value, $Res Function(FloatingFilterItem) _then) = _$FloatingFilterItemCopyWithImpl;
@useResult
$Res call({
 FloatingFilterSectionEntity section
});


$FloatingFilterSectionEntityCopyWith<$Res> get section;

}
/// @nodoc
class _$FloatingFilterItemCopyWithImpl<$Res>
    implements $FloatingFilterItemCopyWith<$Res> {
  _$FloatingFilterItemCopyWithImpl(this._self, this._then);

  final FloatingFilterItem _self;
  final $Res Function(FloatingFilterItem) _then;

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? section = null,}) {
  return _then(FloatingFilterItem(
section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as FloatingFilterSectionEntity,
  ));
}

/// Create a copy of PlpListItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloatingFilterSectionEntityCopyWith<$Res> get section {
  
  return $FloatingFilterSectionEntityCopyWith<$Res>(_self.section, (value) {
    return _then(_self.copyWith(section: value));
  });
}
}

// dart format on
