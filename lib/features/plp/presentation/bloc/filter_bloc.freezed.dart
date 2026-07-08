// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FilterEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent()';
}


}

/// @nodoc
class $FilterEventCopyWith<$Res>  {
$FilterEventCopyWith(FilterEvent _, $Res Function(FilterEvent) __);
}


/// Adds pattern-matching-related methods to [FilterEvent].
extension FilterEventPatterns on FilterEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitializeFilter value)?  initialize,TResult Function( ToggleFilterItem value)?  toggleFilterItem,TResult Function( SelectTreeItem value)?  selectTreeItem,TResult Function( SwitchSection value)?  switchSection,TResult Function( ClearAllPendingFilters value)?  clearAllPendingFilters,TResult Function( NavigateTreeBack value)?  navigateTreeBack,TResult Function( PopTreeToLevel value)?  popTreeToLevel,TResult Function( VerifyPincode value)?  verifyPincode,TResult Function( ClearPincodeError value)?  clearPincodeError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitializeFilter() when initialize != null:
return initialize(_that);case ToggleFilterItem() when toggleFilterItem != null:
return toggleFilterItem(_that);case SelectTreeItem() when selectTreeItem != null:
return selectTreeItem(_that);case SwitchSection() when switchSection != null:
return switchSection(_that);case ClearAllPendingFilters() when clearAllPendingFilters != null:
return clearAllPendingFilters(_that);case NavigateTreeBack() when navigateTreeBack != null:
return navigateTreeBack(_that);case PopTreeToLevel() when popTreeToLevel != null:
return popTreeToLevel(_that);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that);case ClearPincodeError() when clearPincodeError != null:
return clearPincodeError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitializeFilter value)  initialize,required TResult Function( ToggleFilterItem value)  toggleFilterItem,required TResult Function( SelectTreeItem value)  selectTreeItem,required TResult Function( SwitchSection value)  switchSection,required TResult Function( ClearAllPendingFilters value)  clearAllPendingFilters,required TResult Function( NavigateTreeBack value)  navigateTreeBack,required TResult Function( PopTreeToLevel value)  popTreeToLevel,required TResult Function( VerifyPincode value)  verifyPincode,required TResult Function( ClearPincodeError value)  clearPincodeError,}){
final _that = this;
switch (_that) {
case InitializeFilter():
return initialize(_that);case ToggleFilterItem():
return toggleFilterItem(_that);case SelectTreeItem():
return selectTreeItem(_that);case SwitchSection():
return switchSection(_that);case ClearAllPendingFilters():
return clearAllPendingFilters(_that);case NavigateTreeBack():
return navigateTreeBack(_that);case PopTreeToLevel():
return popTreeToLevel(_that);case VerifyPincode():
return verifyPincode(_that);case ClearPincodeError():
return clearPincodeError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitializeFilter value)?  initialize,TResult? Function( ToggleFilterItem value)?  toggleFilterItem,TResult? Function( SelectTreeItem value)?  selectTreeItem,TResult? Function( SwitchSection value)?  switchSection,TResult? Function( ClearAllPendingFilters value)?  clearAllPendingFilters,TResult? Function( NavigateTreeBack value)?  navigateTreeBack,TResult? Function( PopTreeToLevel value)?  popTreeToLevel,TResult? Function( VerifyPincode value)?  verifyPincode,TResult? Function( ClearPincodeError value)?  clearPincodeError,}){
final _that = this;
switch (_that) {
case InitializeFilter() when initialize != null:
return initialize(_that);case ToggleFilterItem() when toggleFilterItem != null:
return toggleFilterItem(_that);case SelectTreeItem() when selectTreeItem != null:
return selectTreeItem(_that);case SwitchSection() when switchSection != null:
return switchSection(_that);case ClearAllPendingFilters() when clearAllPendingFilters != null:
return clearAllPendingFilters(_that);case NavigateTreeBack() when navigateTreeBack != null:
return navigateTreeBack(_that);case PopTreeToLevel() when popTreeToLevel != null:
return popTreeToLevel(_that);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that);case ClearPincodeError() when clearPincodeError != null:
return clearPincodeError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PlpFilterEntity plpFilter,  Map<String, String> appliedFilters,  Map<String, dynamic> baseQueryParams)?  initialize,TResult Function( String param,  String value,  bool isMultiSelect)?  toggleFilterItem,TResult Function( String param,  String value,  int level)?  selectTreeItem,TResult Function( int sectionIndex)?  switchSection,TResult Function()?  clearAllPendingFilters,TResult Function()?  navigateTreeBack,TResult Function( int level)?  popTreeToLevel,TResult Function( String pincode)?  verifyPincode,TResult Function()?  clearPincodeError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitializeFilter() when initialize != null:
return initialize(_that.plpFilter,_that.appliedFilters,_that.baseQueryParams);case ToggleFilterItem() when toggleFilterItem != null:
return toggleFilterItem(_that.param,_that.value,_that.isMultiSelect);case SelectTreeItem() when selectTreeItem != null:
return selectTreeItem(_that.param,_that.value,_that.level);case SwitchSection() when switchSection != null:
return switchSection(_that.sectionIndex);case ClearAllPendingFilters() when clearAllPendingFilters != null:
return clearAllPendingFilters();case NavigateTreeBack() when navigateTreeBack != null:
return navigateTreeBack();case PopTreeToLevel() when popTreeToLevel != null:
return popTreeToLevel(_that.level);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that.pincode);case ClearPincodeError() when clearPincodeError != null:
return clearPincodeError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PlpFilterEntity plpFilter,  Map<String, String> appliedFilters,  Map<String, dynamic> baseQueryParams)  initialize,required TResult Function( String param,  String value,  bool isMultiSelect)  toggleFilterItem,required TResult Function( String param,  String value,  int level)  selectTreeItem,required TResult Function( int sectionIndex)  switchSection,required TResult Function()  clearAllPendingFilters,required TResult Function()  navigateTreeBack,required TResult Function( int level)  popTreeToLevel,required TResult Function( String pincode)  verifyPincode,required TResult Function()  clearPincodeError,}) {final _that = this;
switch (_that) {
case InitializeFilter():
return initialize(_that.plpFilter,_that.appliedFilters,_that.baseQueryParams);case ToggleFilterItem():
return toggleFilterItem(_that.param,_that.value,_that.isMultiSelect);case SelectTreeItem():
return selectTreeItem(_that.param,_that.value,_that.level);case SwitchSection():
return switchSection(_that.sectionIndex);case ClearAllPendingFilters():
return clearAllPendingFilters();case NavigateTreeBack():
return navigateTreeBack();case PopTreeToLevel():
return popTreeToLevel(_that.level);case VerifyPincode():
return verifyPincode(_that.pincode);case ClearPincodeError():
return clearPincodeError();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PlpFilterEntity plpFilter,  Map<String, String> appliedFilters,  Map<String, dynamic> baseQueryParams)?  initialize,TResult? Function( String param,  String value,  bool isMultiSelect)?  toggleFilterItem,TResult? Function( String param,  String value,  int level)?  selectTreeItem,TResult? Function( int sectionIndex)?  switchSection,TResult? Function()?  clearAllPendingFilters,TResult? Function()?  navigateTreeBack,TResult? Function( int level)?  popTreeToLevel,TResult? Function( String pincode)?  verifyPincode,TResult? Function()?  clearPincodeError,}) {final _that = this;
switch (_that) {
case InitializeFilter() when initialize != null:
return initialize(_that.plpFilter,_that.appliedFilters,_that.baseQueryParams);case ToggleFilterItem() when toggleFilterItem != null:
return toggleFilterItem(_that.param,_that.value,_that.isMultiSelect);case SelectTreeItem() when selectTreeItem != null:
return selectTreeItem(_that.param,_that.value,_that.level);case SwitchSection() when switchSection != null:
return switchSection(_that.sectionIndex);case ClearAllPendingFilters() when clearAllPendingFilters != null:
return clearAllPendingFilters();case NavigateTreeBack() when navigateTreeBack != null:
return navigateTreeBack();case PopTreeToLevel() when popTreeToLevel != null:
return popTreeToLevel(_that.level);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that.pincode);case ClearPincodeError() when clearPincodeError != null:
return clearPincodeError();case _:
  return null;

}
}

}

/// @nodoc


class InitializeFilter with DiagnosticableTreeMixin implements FilterEvent {
  const InitializeFilter({required this.plpFilter, required final  Map<String, String> appliedFilters, required final  Map<String, dynamic> baseQueryParams}): _appliedFilters = appliedFilters,_baseQueryParams = baseQueryParams;
  

 final  PlpFilterEntity plpFilter;
 final  Map<String, String> _appliedFilters;
 Map<String, String> get appliedFilters {
  if (_appliedFilters is EqualUnmodifiableMapView) return _appliedFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_appliedFilters);
}

 final  Map<String, dynamic> _baseQueryParams;
 Map<String, dynamic> get baseQueryParams {
  if (_baseQueryParams is EqualUnmodifiableMapView) return _baseQueryParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_baseQueryParams);
}


/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitializeFilterCopyWith<InitializeFilter> get copyWith => _$InitializeFilterCopyWithImpl<InitializeFilter>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.initialize'))
    ..add(DiagnosticsProperty('plpFilter', plpFilter))..add(DiagnosticsProperty('appliedFilters', appliedFilters))..add(DiagnosticsProperty('baseQueryParams', baseQueryParams));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitializeFilter&&(identical(other.plpFilter, plpFilter) || other.plpFilter == plpFilter)&&const DeepCollectionEquality().equals(other._appliedFilters, _appliedFilters)&&const DeepCollectionEquality().equals(other._baseQueryParams, _baseQueryParams));
}


@override
int get hashCode => Object.hash(runtimeType,plpFilter,const DeepCollectionEquality().hash(_appliedFilters),const DeepCollectionEquality().hash(_baseQueryParams));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.initialize(plpFilter: $plpFilter, appliedFilters: $appliedFilters, baseQueryParams: $baseQueryParams)';
}


}

/// @nodoc
abstract mixin class $InitializeFilterCopyWith<$Res> implements $FilterEventCopyWith<$Res> {
  factory $InitializeFilterCopyWith(InitializeFilter value, $Res Function(InitializeFilter) _then) = _$InitializeFilterCopyWithImpl;
@useResult
$Res call({
 PlpFilterEntity plpFilter, Map<String, String> appliedFilters, Map<String, dynamic> baseQueryParams
});


$PlpFilterEntityCopyWith<$Res> get plpFilter;

}
/// @nodoc
class _$InitializeFilterCopyWithImpl<$Res>
    implements $InitializeFilterCopyWith<$Res> {
  _$InitializeFilterCopyWithImpl(this._self, this._then);

  final InitializeFilter _self;
  final $Res Function(InitializeFilter) _then;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plpFilter = null,Object? appliedFilters = null,Object? baseQueryParams = null,}) {
  return _then(InitializeFilter(
plpFilter: null == plpFilter ? _self.plpFilter : plpFilter // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity,appliedFilters: null == appliedFilters ? _self._appliedFilters : appliedFilters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,baseQueryParams: null == baseQueryParams ? _self._baseQueryParams : baseQueryParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<$Res> get plpFilter {
  
  return $PlpFilterEntityCopyWith<$Res>(_self.plpFilter, (value) {
    return _then(_self.copyWith(plpFilter: value));
  });
}
}

/// @nodoc


class ToggleFilterItem with DiagnosticableTreeMixin implements FilterEvent {
  const ToggleFilterItem({required this.param, required this.value, required this.isMultiSelect});
  

 final  String param;
 final  String value;
 final  bool isMultiSelect;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleFilterItemCopyWith<ToggleFilterItem> get copyWith => _$ToggleFilterItemCopyWithImpl<ToggleFilterItem>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.toggleFilterItem'))
    ..add(DiagnosticsProperty('param', param))..add(DiagnosticsProperty('value', value))..add(DiagnosticsProperty('isMultiSelect', isMultiSelect));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleFilterItem&&(identical(other.param, param) || other.param == param)&&(identical(other.value, value) || other.value == value)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect));
}


@override
int get hashCode => Object.hash(runtimeType,param,value,isMultiSelect);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.toggleFilterItem(param: $param, value: $value, isMultiSelect: $isMultiSelect)';
}


}

/// @nodoc
abstract mixin class $ToggleFilterItemCopyWith<$Res> implements $FilterEventCopyWith<$Res> {
  factory $ToggleFilterItemCopyWith(ToggleFilterItem value, $Res Function(ToggleFilterItem) _then) = _$ToggleFilterItemCopyWithImpl;
@useResult
$Res call({
 String param, String value, bool isMultiSelect
});




}
/// @nodoc
class _$ToggleFilterItemCopyWithImpl<$Res>
    implements $ToggleFilterItemCopyWith<$Res> {
  _$ToggleFilterItemCopyWithImpl(this._self, this._then);

  final ToggleFilterItem _self;
  final $Res Function(ToggleFilterItem) _then;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? param = null,Object? value = null,Object? isMultiSelect = null,}) {
  return _then(ToggleFilterItem(
param: null == param ? _self.param : param // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SelectTreeItem with DiagnosticableTreeMixin implements FilterEvent {
  const SelectTreeItem({required this.param, required this.value, required this.level});
  

 final  String param;
 final  String value;
 final  int level;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectTreeItemCopyWith<SelectTreeItem> get copyWith => _$SelectTreeItemCopyWithImpl<SelectTreeItem>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.selectTreeItem'))
    ..add(DiagnosticsProperty('param', param))..add(DiagnosticsProperty('value', value))..add(DiagnosticsProperty('level', level));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectTreeItem&&(identical(other.param, param) || other.param == param)&&(identical(other.value, value) || other.value == value)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,param,value,level);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.selectTreeItem(param: $param, value: $value, level: $level)';
}


}

/// @nodoc
abstract mixin class $SelectTreeItemCopyWith<$Res> implements $FilterEventCopyWith<$Res> {
  factory $SelectTreeItemCopyWith(SelectTreeItem value, $Res Function(SelectTreeItem) _then) = _$SelectTreeItemCopyWithImpl;
@useResult
$Res call({
 String param, String value, int level
});




}
/// @nodoc
class _$SelectTreeItemCopyWithImpl<$Res>
    implements $SelectTreeItemCopyWith<$Res> {
  _$SelectTreeItemCopyWithImpl(this._self, this._then);

  final SelectTreeItem _self;
  final $Res Function(SelectTreeItem) _then;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? param = null,Object? value = null,Object? level = null,}) {
  return _then(SelectTreeItem(
param: null == param ? _self.param : param // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SwitchSection with DiagnosticableTreeMixin implements FilterEvent {
  const SwitchSection({required this.sectionIndex});
  

 final  int sectionIndex;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwitchSectionCopyWith<SwitchSection> get copyWith => _$SwitchSectionCopyWithImpl<SwitchSection>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.switchSection'))
    ..add(DiagnosticsProperty('sectionIndex', sectionIndex));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwitchSection&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex));
}


@override
int get hashCode => Object.hash(runtimeType,sectionIndex);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.switchSection(sectionIndex: $sectionIndex)';
}


}

/// @nodoc
abstract mixin class $SwitchSectionCopyWith<$Res> implements $FilterEventCopyWith<$Res> {
  factory $SwitchSectionCopyWith(SwitchSection value, $Res Function(SwitchSection) _then) = _$SwitchSectionCopyWithImpl;
@useResult
$Res call({
 int sectionIndex
});




}
/// @nodoc
class _$SwitchSectionCopyWithImpl<$Res>
    implements $SwitchSectionCopyWith<$Res> {
  _$SwitchSectionCopyWithImpl(this._self, this._then);

  final SwitchSection _self;
  final $Res Function(SwitchSection) _then;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sectionIndex = null,}) {
  return _then(SwitchSection(
sectionIndex: null == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ClearAllPendingFilters with DiagnosticableTreeMixin implements FilterEvent {
  const ClearAllPendingFilters();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.clearAllPendingFilters'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearAllPendingFilters);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.clearAllPendingFilters()';
}


}




/// @nodoc


class NavigateTreeBack with DiagnosticableTreeMixin implements FilterEvent {
  const NavigateTreeBack();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.navigateTreeBack'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigateTreeBack);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.navigateTreeBack()';
}


}




/// @nodoc


class PopTreeToLevel with DiagnosticableTreeMixin implements FilterEvent {
  const PopTreeToLevel({required this.level});
  

 final  int level;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopTreeToLevelCopyWith<PopTreeToLevel> get copyWith => _$PopTreeToLevelCopyWithImpl<PopTreeToLevel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.popTreeToLevel'))
    ..add(DiagnosticsProperty('level', level));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopTreeToLevel&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.popTreeToLevel(level: $level)';
}


}

/// @nodoc
abstract mixin class $PopTreeToLevelCopyWith<$Res> implements $FilterEventCopyWith<$Res> {
  factory $PopTreeToLevelCopyWith(PopTreeToLevel value, $Res Function(PopTreeToLevel) _then) = _$PopTreeToLevelCopyWithImpl;
@useResult
$Res call({
 int level
});




}
/// @nodoc
class _$PopTreeToLevelCopyWithImpl<$Res>
    implements $PopTreeToLevelCopyWith<$Res> {
  _$PopTreeToLevelCopyWithImpl(this._self, this._then);

  final PopTreeToLevel _self;
  final $Res Function(PopTreeToLevel) _then;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(PopTreeToLevel(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class VerifyPincode with DiagnosticableTreeMixin implements FilterEvent {
  const VerifyPincode({required this.pincode});
  

 final  String pincode;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyPincodeCopyWith<VerifyPincode> get copyWith => _$VerifyPincodeCopyWithImpl<VerifyPincode>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.verifyPincode'))
    ..add(DiagnosticsProperty('pincode', pincode));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyPincode&&(identical(other.pincode, pincode) || other.pincode == pincode));
}


@override
int get hashCode => Object.hash(runtimeType,pincode);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.verifyPincode(pincode: $pincode)';
}


}

/// @nodoc
abstract mixin class $VerifyPincodeCopyWith<$Res> implements $FilterEventCopyWith<$Res> {
  factory $VerifyPincodeCopyWith(VerifyPincode value, $Res Function(VerifyPincode) _then) = _$VerifyPincodeCopyWithImpl;
@useResult
$Res call({
 String pincode
});




}
/// @nodoc
class _$VerifyPincodeCopyWithImpl<$Res>
    implements $VerifyPincodeCopyWith<$Res> {
  _$VerifyPincodeCopyWithImpl(this._self, this._then);

  final VerifyPincode _self;
  final $Res Function(VerifyPincode) _then;

/// Create a copy of FilterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pincode = null,}) {
  return _then(VerifyPincode(
pincode: null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClearPincodeError with DiagnosticableTreeMixin implements FilterEvent {
  const ClearPincodeError();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterEvent.clearPincodeError'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearPincodeError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterEvent.clearPincodeError()';
}


}




/// @nodoc
mixin _$FilterState implements DiagnosticableTreeMixin {

 FilterStatus get status; PlpFilterEntity get plpFilter; Map<String, Set<String>> get pendingFilters; Map<String, String> get treeSelections;// Tree keys written into [treeSelections] purely to auto-expand a
// single-child branch for navigation (e.g. a lone top-level category). They
// are NOT user selections, so they must not be sent to the API or counted
// as active filters unless the user actually selects something below them.
 Set<String> get autoExpandedKeys;// Whether the filter UI opened with filters already applied. Captured once
// at initialization and never mutated. Lets the Apply button stay enabled
// after the user clears previously-applied filters, so an empty selection
// can still be committed (see [canApply]).
 bool get hadInitialFilters; int get selectedSectionIndex; bool get isRefreshing; Map<String, dynamic> get baseQueryParams; String? get errorMessage; bool get isPincodeLoading; String? get pincodeError; String? get verifiedPincode;
/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterStateCopyWith<FilterState> get copyWith => _$FilterStateCopyWithImpl<FilterState>(this as FilterState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('plpFilter', plpFilter))..add(DiagnosticsProperty('pendingFilters', pendingFilters))..add(DiagnosticsProperty('treeSelections', treeSelections))..add(DiagnosticsProperty('autoExpandedKeys', autoExpandedKeys))..add(DiagnosticsProperty('hadInitialFilters', hadInitialFilters))..add(DiagnosticsProperty('selectedSectionIndex', selectedSectionIndex))..add(DiagnosticsProperty('isRefreshing', isRefreshing))..add(DiagnosticsProperty('baseQueryParams', baseQueryParams))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('isPincodeLoading', isPincodeLoading))..add(DiagnosticsProperty('pincodeError', pincodeError))..add(DiagnosticsProperty('verifiedPincode', verifiedPincode));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterState&&(identical(other.status, status) || other.status == status)&&(identical(other.plpFilter, plpFilter) || other.plpFilter == plpFilter)&&const DeepCollectionEquality().equals(other.pendingFilters, pendingFilters)&&const DeepCollectionEquality().equals(other.treeSelections, treeSelections)&&const DeepCollectionEquality().equals(other.autoExpandedKeys, autoExpandedKeys)&&(identical(other.hadInitialFilters, hadInitialFilters) || other.hadInitialFilters == hadInitialFilters)&&(identical(other.selectedSectionIndex, selectedSectionIndex) || other.selectedSectionIndex == selectedSectionIndex)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&const DeepCollectionEquality().equals(other.baseQueryParams, baseQueryParams)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isPincodeLoading, isPincodeLoading) || other.isPincodeLoading == isPincodeLoading)&&(identical(other.pincodeError, pincodeError) || other.pincodeError == pincodeError)&&(identical(other.verifiedPincode, verifiedPincode) || other.verifiedPincode == verifiedPincode));
}


@override
int get hashCode => Object.hash(runtimeType,status,plpFilter,const DeepCollectionEquality().hash(pendingFilters),const DeepCollectionEquality().hash(treeSelections),const DeepCollectionEquality().hash(autoExpandedKeys),hadInitialFilters,selectedSectionIndex,isRefreshing,const DeepCollectionEquality().hash(baseQueryParams),errorMessage,isPincodeLoading,pincodeError,verifiedPincode);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterState(status: $status, plpFilter: $plpFilter, pendingFilters: $pendingFilters, treeSelections: $treeSelections, autoExpandedKeys: $autoExpandedKeys, hadInitialFilters: $hadInitialFilters, selectedSectionIndex: $selectedSectionIndex, isRefreshing: $isRefreshing, baseQueryParams: $baseQueryParams, errorMessage: $errorMessage, isPincodeLoading: $isPincodeLoading, pincodeError: $pincodeError, verifiedPincode: $verifiedPincode)';
}


}

/// @nodoc
abstract mixin class $FilterStateCopyWith<$Res>  {
  factory $FilterStateCopyWith(FilterState value, $Res Function(FilterState) _then) = _$FilterStateCopyWithImpl;
@useResult
$Res call({
 FilterStatus status, PlpFilterEntity plpFilter, Map<String, Set<String>> pendingFilters, Map<String, String> treeSelections, Set<String> autoExpandedKeys, bool hadInitialFilters, int selectedSectionIndex, bool isRefreshing, Map<String, dynamic> baseQueryParams, String? errorMessage, bool isPincodeLoading, String? pincodeError, String? verifiedPincode
});


$PlpFilterEntityCopyWith<$Res> get plpFilter;

}
/// @nodoc
class _$FilterStateCopyWithImpl<$Res>
    implements $FilterStateCopyWith<$Res> {
  _$FilterStateCopyWithImpl(this._self, this._then);

  final FilterState _self;
  final $Res Function(FilterState) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? plpFilter = null,Object? pendingFilters = null,Object? treeSelections = null,Object? autoExpandedKeys = null,Object? hadInitialFilters = null,Object? selectedSectionIndex = null,Object? isRefreshing = null,Object? baseQueryParams = null,Object? errorMessage = freezed,Object? isPincodeLoading = null,Object? pincodeError = freezed,Object? verifiedPincode = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FilterStatus,plpFilter: null == plpFilter ? _self.plpFilter : plpFilter // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity,pendingFilters: null == pendingFilters ? _self.pendingFilters : pendingFilters // ignore: cast_nullable_to_non_nullable
as Map<String, Set<String>>,treeSelections: null == treeSelections ? _self.treeSelections : treeSelections // ignore: cast_nullable_to_non_nullable
as Map<String, String>,autoExpandedKeys: null == autoExpandedKeys ? _self.autoExpandedKeys : autoExpandedKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,hadInitialFilters: null == hadInitialFilters ? _self.hadInitialFilters : hadInitialFilters // ignore: cast_nullable_to_non_nullable
as bool,selectedSectionIndex: null == selectedSectionIndex ? _self.selectedSectionIndex : selectedSectionIndex // ignore: cast_nullable_to_non_nullable
as int,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,baseQueryParams: null == baseQueryParams ? _self.baseQueryParams : baseQueryParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isPincodeLoading: null == isPincodeLoading ? _self.isPincodeLoading : isPincodeLoading // ignore: cast_nullable_to_non_nullable
as bool,pincodeError: freezed == pincodeError ? _self.pincodeError : pincodeError // ignore: cast_nullable_to_non_nullable
as String?,verifiedPincode: freezed == verifiedPincode ? _self.verifiedPincode : verifiedPincode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<$Res> get plpFilter {
  
  return $PlpFilterEntityCopyWith<$Res>(_self.plpFilter, (value) {
    return _then(_self.copyWith(plpFilter: value));
  });
}
}


/// Adds pattern-matching-related methods to [FilterState].
extension FilterStatePatterns on FilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterState value)  $default,){
final _that = this;
switch (_that) {
case _FilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterState value)?  $default,){
final _that = this;
switch (_that) {
case _FilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FilterStatus status,  PlpFilterEntity plpFilter,  Map<String, Set<String>> pendingFilters,  Map<String, String> treeSelections,  Set<String> autoExpandedKeys,  bool hadInitialFilters,  int selectedSectionIndex,  bool isRefreshing,  Map<String, dynamic> baseQueryParams,  String? errorMessage,  bool isPincodeLoading,  String? pincodeError,  String? verifiedPincode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.status,_that.plpFilter,_that.pendingFilters,_that.treeSelections,_that.autoExpandedKeys,_that.hadInitialFilters,_that.selectedSectionIndex,_that.isRefreshing,_that.baseQueryParams,_that.errorMessage,_that.isPincodeLoading,_that.pincodeError,_that.verifiedPincode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FilterStatus status,  PlpFilterEntity plpFilter,  Map<String, Set<String>> pendingFilters,  Map<String, String> treeSelections,  Set<String> autoExpandedKeys,  bool hadInitialFilters,  int selectedSectionIndex,  bool isRefreshing,  Map<String, dynamic> baseQueryParams,  String? errorMessage,  bool isPincodeLoading,  String? pincodeError,  String? verifiedPincode)  $default,) {final _that = this;
switch (_that) {
case _FilterState():
return $default(_that.status,_that.plpFilter,_that.pendingFilters,_that.treeSelections,_that.autoExpandedKeys,_that.hadInitialFilters,_that.selectedSectionIndex,_that.isRefreshing,_that.baseQueryParams,_that.errorMessage,_that.isPincodeLoading,_that.pincodeError,_that.verifiedPincode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FilterStatus status,  PlpFilterEntity plpFilter,  Map<String, Set<String>> pendingFilters,  Map<String, String> treeSelections,  Set<String> autoExpandedKeys,  bool hadInitialFilters,  int selectedSectionIndex,  bool isRefreshing,  Map<String, dynamic> baseQueryParams,  String? errorMessage,  bool isPincodeLoading,  String? pincodeError,  String? verifiedPincode)?  $default,) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.status,_that.plpFilter,_that.pendingFilters,_that.treeSelections,_that.autoExpandedKeys,_that.hadInitialFilters,_that.selectedSectionIndex,_that.isRefreshing,_that.baseQueryParams,_that.errorMessage,_that.isPincodeLoading,_that.pincodeError,_that.verifiedPincode);case _:
  return null;

}
}

}

/// @nodoc


class _FilterState with DiagnosticableTreeMixin implements FilterState {
  const _FilterState({this.status = FilterStatus.initial, this.plpFilter = const PlpFilterEntity(), final  Map<String, Set<String>> pendingFilters = const <String, Set<String>>{}, final  Map<String, String> treeSelections = const <String, String>{}, final  Set<String> autoExpandedKeys = const <String>{}, this.hadInitialFilters = false, this.selectedSectionIndex = 0, this.isRefreshing = false, final  Map<String, dynamic> baseQueryParams = const <String, dynamic>{}, this.errorMessage, this.isPincodeLoading = false, this.pincodeError, this.verifiedPincode}): _pendingFilters = pendingFilters,_treeSelections = treeSelections,_autoExpandedKeys = autoExpandedKeys,_baseQueryParams = baseQueryParams;
  

@override@JsonKey() final  FilterStatus status;
@override@JsonKey() final  PlpFilterEntity plpFilter;
 final  Map<String, Set<String>> _pendingFilters;
@override@JsonKey() Map<String, Set<String>> get pendingFilters {
  if (_pendingFilters is EqualUnmodifiableMapView) return _pendingFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pendingFilters);
}

 final  Map<String, String> _treeSelections;
@override@JsonKey() Map<String, String> get treeSelections {
  if (_treeSelections is EqualUnmodifiableMapView) return _treeSelections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_treeSelections);
}

// Tree keys written into [treeSelections] purely to auto-expand a
// single-child branch for navigation (e.g. a lone top-level category). They
// are NOT user selections, so they must not be sent to the API or counted
// as active filters unless the user actually selects something below them.
 final  Set<String> _autoExpandedKeys;
// Tree keys written into [treeSelections] purely to auto-expand a
// single-child branch for navigation (e.g. a lone top-level category). They
// are NOT user selections, so they must not be sent to the API or counted
// as active filters unless the user actually selects something below them.
@override@JsonKey() Set<String> get autoExpandedKeys {
  if (_autoExpandedKeys is EqualUnmodifiableSetView) return _autoExpandedKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_autoExpandedKeys);
}

// Whether the filter UI opened with filters already applied. Captured once
// at initialization and never mutated. Lets the Apply button stay enabled
// after the user clears previously-applied filters, so an empty selection
// can still be committed (see [canApply]).
@override@JsonKey() final  bool hadInitialFilters;
@override@JsonKey() final  int selectedSectionIndex;
@override@JsonKey() final  bool isRefreshing;
 final  Map<String, dynamic> _baseQueryParams;
@override@JsonKey() Map<String, dynamic> get baseQueryParams {
  if (_baseQueryParams is EqualUnmodifiableMapView) return _baseQueryParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_baseQueryParams);
}

@override final  String? errorMessage;
@override@JsonKey() final  bool isPincodeLoading;
@override final  String? pincodeError;
@override final  String? verifiedPincode;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterStateCopyWith<_FilterState> get copyWith => __$FilterStateCopyWithImpl<_FilterState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FilterState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('plpFilter', plpFilter))..add(DiagnosticsProperty('pendingFilters', pendingFilters))..add(DiagnosticsProperty('treeSelections', treeSelections))..add(DiagnosticsProperty('autoExpandedKeys', autoExpandedKeys))..add(DiagnosticsProperty('hadInitialFilters', hadInitialFilters))..add(DiagnosticsProperty('selectedSectionIndex', selectedSectionIndex))..add(DiagnosticsProperty('isRefreshing', isRefreshing))..add(DiagnosticsProperty('baseQueryParams', baseQueryParams))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('isPincodeLoading', isPincodeLoading))..add(DiagnosticsProperty('pincodeError', pincodeError))..add(DiagnosticsProperty('verifiedPincode', verifiedPincode));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterState&&(identical(other.status, status) || other.status == status)&&(identical(other.plpFilter, plpFilter) || other.plpFilter == plpFilter)&&const DeepCollectionEquality().equals(other._pendingFilters, _pendingFilters)&&const DeepCollectionEquality().equals(other._treeSelections, _treeSelections)&&const DeepCollectionEquality().equals(other._autoExpandedKeys, _autoExpandedKeys)&&(identical(other.hadInitialFilters, hadInitialFilters) || other.hadInitialFilters == hadInitialFilters)&&(identical(other.selectedSectionIndex, selectedSectionIndex) || other.selectedSectionIndex == selectedSectionIndex)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&const DeepCollectionEquality().equals(other._baseQueryParams, _baseQueryParams)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isPincodeLoading, isPincodeLoading) || other.isPincodeLoading == isPincodeLoading)&&(identical(other.pincodeError, pincodeError) || other.pincodeError == pincodeError)&&(identical(other.verifiedPincode, verifiedPincode) || other.verifiedPincode == verifiedPincode));
}


@override
int get hashCode => Object.hash(runtimeType,status,plpFilter,const DeepCollectionEquality().hash(_pendingFilters),const DeepCollectionEquality().hash(_treeSelections),const DeepCollectionEquality().hash(_autoExpandedKeys),hadInitialFilters,selectedSectionIndex,isRefreshing,const DeepCollectionEquality().hash(_baseQueryParams),errorMessage,isPincodeLoading,pincodeError,verifiedPincode);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FilterState(status: $status, plpFilter: $plpFilter, pendingFilters: $pendingFilters, treeSelections: $treeSelections, autoExpandedKeys: $autoExpandedKeys, hadInitialFilters: $hadInitialFilters, selectedSectionIndex: $selectedSectionIndex, isRefreshing: $isRefreshing, baseQueryParams: $baseQueryParams, errorMessage: $errorMessage, isPincodeLoading: $isPincodeLoading, pincodeError: $pincodeError, verifiedPincode: $verifiedPincode)';
}


}

/// @nodoc
abstract mixin class _$FilterStateCopyWith<$Res> implements $FilterStateCopyWith<$Res> {
  factory _$FilterStateCopyWith(_FilterState value, $Res Function(_FilterState) _then) = __$FilterStateCopyWithImpl;
@override @useResult
$Res call({
 FilterStatus status, PlpFilterEntity plpFilter, Map<String, Set<String>> pendingFilters, Map<String, String> treeSelections, Set<String> autoExpandedKeys, bool hadInitialFilters, int selectedSectionIndex, bool isRefreshing, Map<String, dynamic> baseQueryParams, String? errorMessage, bool isPincodeLoading, String? pincodeError, String? verifiedPincode
});


@override $PlpFilterEntityCopyWith<$Res> get plpFilter;

}
/// @nodoc
class __$FilterStateCopyWithImpl<$Res>
    implements _$FilterStateCopyWith<$Res> {
  __$FilterStateCopyWithImpl(this._self, this._then);

  final _FilterState _self;
  final $Res Function(_FilterState) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? plpFilter = null,Object? pendingFilters = null,Object? treeSelections = null,Object? autoExpandedKeys = null,Object? hadInitialFilters = null,Object? selectedSectionIndex = null,Object? isRefreshing = null,Object? baseQueryParams = null,Object? errorMessage = freezed,Object? isPincodeLoading = null,Object? pincodeError = freezed,Object? verifiedPincode = freezed,}) {
  return _then(_FilterState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FilterStatus,plpFilter: null == plpFilter ? _self.plpFilter : plpFilter // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity,pendingFilters: null == pendingFilters ? _self._pendingFilters : pendingFilters // ignore: cast_nullable_to_non_nullable
as Map<String, Set<String>>,treeSelections: null == treeSelections ? _self._treeSelections : treeSelections // ignore: cast_nullable_to_non_nullable
as Map<String, String>,autoExpandedKeys: null == autoExpandedKeys ? _self._autoExpandedKeys : autoExpandedKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,hadInitialFilters: null == hadInitialFilters ? _self.hadInitialFilters : hadInitialFilters // ignore: cast_nullable_to_non_nullable
as bool,selectedSectionIndex: null == selectedSectionIndex ? _self.selectedSectionIndex : selectedSectionIndex // ignore: cast_nullable_to_non_nullable
as int,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,baseQueryParams: null == baseQueryParams ? _self._baseQueryParams : baseQueryParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isPincodeLoading: null == isPincodeLoading ? _self.isPincodeLoading : isPincodeLoading // ignore: cast_nullable_to_non_nullable
as bool,pincodeError: freezed == pincodeError ? _self.pincodeError : pincodeError // ignore: cast_nullable_to_non_nullable
as String?,verifiedPincode: freezed == verifiedPincode ? _self.verifiedPincode : verifiedPincode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<$Res> get plpFilter {
  
  return $PlpFilterEntityCopyWith<$Res>(_self.plpFilter, (value) {
    return _then(_self.copyWith(plpFilter: value));
  });
}
}

// dart format on
