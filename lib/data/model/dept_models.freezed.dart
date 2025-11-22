// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dept_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeptListResponse _$DeptListResponseFromJson(Map<String, dynamic> json) {
  return _DeptListResponse.fromJson(json);
}

/// @nodoc
mixin _$DeptListResponse {
  bool get success => throw _privateConstructorUsedError;
  String get msg => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<DeptItem> get resultList => throw _privateConstructorUsedError;

  /// Serializes this DeptListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeptListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeptListResponseCopyWith<DeptListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeptListResponseCopyWith<$Res> {
  factory $DeptListResponseCopyWith(
          DeptListResponse value, $Res Function(DeptListResponse) then) =
      _$DeptListResponseCopyWithImpl<$Res, DeptListResponse>;
  @useResult
  $Res call(
      {bool success,
      String msg,
      @JsonKey(defaultValue: []) List<DeptItem> resultList});
}

/// @nodoc
class _$DeptListResponseCopyWithImpl<$Res, $Val extends DeptListResponse>
    implements $DeptListResponseCopyWith<$Res> {
  _$DeptListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeptListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = null,
    Object? resultList = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      resultList: null == resultList
          ? _value.resultList
          : resultList // ignore: cast_nullable_to_non_nullable
              as List<DeptItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeptListResponseImplCopyWith<$Res>
    implements $DeptListResponseCopyWith<$Res> {
  factory _$$DeptListResponseImplCopyWith(_$DeptListResponseImpl value,
          $Res Function(_$DeptListResponseImpl) then) =
      __$$DeptListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String msg,
      @JsonKey(defaultValue: []) List<DeptItem> resultList});
}

/// @nodoc
class __$$DeptListResponseImplCopyWithImpl<$Res>
    extends _$DeptListResponseCopyWithImpl<$Res, _$DeptListResponseImpl>
    implements _$$DeptListResponseImplCopyWith<$Res> {
  __$$DeptListResponseImplCopyWithImpl(_$DeptListResponseImpl _value,
      $Res Function(_$DeptListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeptListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = null,
    Object? resultList = null,
  }) {
    return _then(_$DeptListResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      resultList: null == resultList
          ? _value._resultList
          : resultList // ignore: cast_nullable_to_non_nullable
              as List<DeptItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeptListResponseImpl implements _DeptListResponse {
  const _$DeptListResponseImpl(
      {required this.success,
      required this.msg,
      @JsonKey(defaultValue: []) required final List<DeptItem> resultList})
      : _resultList = resultList;

  factory _$DeptListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeptListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String msg;
  final List<DeptItem> _resultList;
  @override
  @JsonKey(defaultValue: [])
  List<DeptItem> get resultList {
    if (_resultList is EqualUnmodifiableListView) return _resultList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resultList);
  }

  @override
  String toString() {
    return 'DeptListResponse(success: $success, msg: $msg, resultList: $resultList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeptListResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            const DeepCollectionEquality()
                .equals(other._resultList, _resultList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, msg,
      const DeepCollectionEquality().hash(_resultList));

  /// Create a copy of DeptListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeptListResponseImplCopyWith<_$DeptListResponseImpl> get copyWith =>
      __$$DeptListResponseImplCopyWithImpl<_$DeptListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeptListResponseImplToJson(
      this,
    );
  }
}

abstract class _DeptListResponse implements DeptListResponse {
  const factory _DeptListResponse(
      {required final bool success,
      required final String msg,
      @JsonKey(defaultValue: [])
      required final List<DeptItem> resultList}) = _$DeptListResponseImpl;

  factory _DeptListResponse.fromJson(Map<String, dynamic> json) =
      _$DeptListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get msg;
  @override
  @JsonKey(defaultValue: [])
  List<DeptItem> get resultList;

  /// Create a copy of DeptListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeptListResponseImplCopyWith<_$DeptListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeptItem _$DeptItemFromJson(Map<String, dynamic> json) {
  return _DeptItem.fromJson(json);
}

/// @nodoc
mixin _$DeptItem {
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get no => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instNo => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get deptNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get crtDt => throw _privateConstructorUsedError;

  /// Serializes this DeptItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeptItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeptItemCopyWith<DeptItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeptItemCopyWith<$Res> {
  factory $DeptItemCopyWith(DeptItem value, $Res Function(DeptItem) then) =
      _$DeptItemCopyWithImpl<$Res, DeptItem>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNo,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? deptNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? crtDt});
}

/// @nodoc
class _$DeptItemCopyWithImpl<$Res, $Val extends DeptItem>
    implements $DeptItemCopyWith<$Res> {
  _$DeptItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeptItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? no = freezed,
    Object? instNm = freezed,
    Object? instNo = freezed,
    Object? deptNm = freezed,
    Object? crtDt = freezed,
  }) {
    return _then(_value.copyWith(
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      instNm: freezed == instNm
          ? _value.instNm
          : instNm // ignore: cast_nullable_to_non_nullable
              as String?,
      instNo: freezed == instNo
          ? _value.instNo
          : instNo // ignore: cast_nullable_to_non_nullable
              as String?,
      deptNm: freezed == deptNm
          ? _value.deptNm
          : deptNm // ignore: cast_nullable_to_non_nullable
              as String?,
      crtDt: freezed == crtDt
          ? _value.crtDt
          : crtDt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeptItemImplCopyWith<$Res>
    implements $DeptItemCopyWith<$Res> {
  factory _$$DeptItemImplCopyWith(
          _$DeptItemImpl value, $Res Function(_$DeptItemImpl) then) =
      __$$DeptItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNo,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? deptNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? crtDt});
}

/// @nodoc
class __$$DeptItemImplCopyWithImpl<$Res>
    extends _$DeptItemCopyWithImpl<$Res, _$DeptItemImpl>
    implements _$$DeptItemImplCopyWith<$Res> {
  __$$DeptItemImplCopyWithImpl(
      _$DeptItemImpl _value, $Res Function(_$DeptItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeptItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? no = freezed,
    Object? instNm = freezed,
    Object? instNo = freezed,
    Object? deptNm = freezed,
    Object? crtDt = freezed,
  }) {
    return _then(_$DeptItemImpl(
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      instNm: freezed == instNm
          ? _value.instNm
          : instNm // ignore: cast_nullable_to_non_nullable
              as String?,
      instNo: freezed == instNo
          ? _value.instNo
          : instNo // ignore: cast_nullable_to_non_nullable
              as String?,
      deptNm: freezed == deptNm
          ? _value.deptNm
          : deptNm // ignore: cast_nullable_to_non_nullable
              as String?,
      crtDt: freezed == crtDt
          ? _value.crtDt
          : crtDt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeptItemImpl implements _DeptItem {
  const _$DeptItemImpl(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.instNo,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.deptNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.crtDt});

  factory _$DeptItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeptItemImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? no;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? instNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? instNo;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? deptNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? crtDt;

  @override
  String toString() {
    return 'DeptItem(no: $no, instNm: $instNm, instNo: $instNo, deptNm: $deptNm, crtDt: $crtDt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeptItemImpl &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.instNm, instNm) || other.instNm == instNm) &&
            (identical(other.instNo, instNo) || other.instNo == instNo) &&
            (identical(other.deptNm, deptNm) || other.deptNm == deptNm) &&
            (identical(other.crtDt, crtDt) || other.crtDt == crtDt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, no, instNm, instNo, deptNm, crtDt);

  /// Create a copy of DeptItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeptItemImplCopyWith<_$DeptItemImpl> get copyWith =>
      __$$DeptItemImplCopyWithImpl<_$DeptItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeptItemImplToJson(
      this,
    );
  }
}

abstract class _DeptItem implements DeptItem {
  const factory _DeptItem(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? instNo,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? deptNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? crtDt}) = _$DeptItemImpl;

  factory _DeptItem.fromJson(Map<String, dynamic> json) =
      _$DeptItemImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get no;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instNo;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get deptNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get crtDt;

  /// Create a copy of DeptItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeptItemImplCopyWith<_$DeptItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
