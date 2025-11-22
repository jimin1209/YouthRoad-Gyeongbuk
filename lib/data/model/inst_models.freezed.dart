// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inst_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InstListResponse _$InstListResponseFromJson(Map<String, dynamic> json) {
  return _InstListResponse.fromJson(json);
}

/// @nodoc
mixin _$InstListResponse {
  bool get success => throw _privateConstructorUsedError;
  String get msg => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<InstItem> get resultList => throw _privateConstructorUsedError;

  /// Serializes this InstListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstListResponseCopyWith<InstListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstListResponseCopyWith<$Res> {
  factory $InstListResponseCopyWith(
          InstListResponse value, $Res Function(InstListResponse) then) =
      _$InstListResponseCopyWithImpl<$Res, InstListResponse>;
  @useResult
  $Res call(
      {bool success,
      String msg,
      @JsonKey(defaultValue: []) List<InstItem> resultList});
}

/// @nodoc
class _$InstListResponseCopyWithImpl<$Res, $Val extends InstListResponse>
    implements $InstListResponseCopyWith<$Res> {
  _$InstListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstListResponse
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
              as List<InstItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstListResponseImplCopyWith<$Res>
    implements $InstListResponseCopyWith<$Res> {
  factory _$$InstListResponseImplCopyWith(_$InstListResponseImpl value,
          $Res Function(_$InstListResponseImpl) then) =
      __$$InstListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String msg,
      @JsonKey(defaultValue: []) List<InstItem> resultList});
}

/// @nodoc
class __$$InstListResponseImplCopyWithImpl<$Res>
    extends _$InstListResponseCopyWithImpl<$Res, _$InstListResponseImpl>
    implements _$$InstListResponseImplCopyWith<$Res> {
  __$$InstListResponseImplCopyWithImpl(_$InstListResponseImpl _value,
      $Res Function(_$InstListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of InstListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = null,
    Object? resultList = null,
  }) {
    return _then(_$InstListResponseImpl(
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
              as List<InstItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstListResponseImpl implements _InstListResponse {
  const _$InstListResponseImpl(
      {required this.success,
      required this.msg,
      @JsonKey(defaultValue: []) required final List<InstItem> resultList})
      : _resultList = resultList;

  factory _$InstListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String msg;
  final List<InstItem> _resultList;
  @override
  @JsonKey(defaultValue: [])
  List<InstItem> get resultList {
    if (_resultList is EqualUnmodifiableListView) return _resultList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resultList);
  }

  @override
  String toString() {
    return 'InstListResponse(success: $success, msg: $msg, resultList: $resultList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstListResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            const DeepCollectionEquality()
                .equals(other._resultList, _resultList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, msg,
      const DeepCollectionEquality().hash(_resultList));

  /// Create a copy of InstListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstListResponseImplCopyWith<_$InstListResponseImpl> get copyWith =>
      __$$InstListResponseImplCopyWithImpl<_$InstListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstListResponseImplToJson(
      this,
    );
  }
}

abstract class _InstListResponse implements InstListResponse {
  const factory _InstListResponse(
      {required final bool success,
      required final String msg,
      @JsonKey(defaultValue: [])
      required final List<InstItem> resultList}) = _$InstListResponseImpl;

  factory _InstListResponse.fromJson(Map<String, dynamic> json) =
      _$InstListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get msg;
  @override
  @JsonKey(defaultValue: [])
  List<InstItem> get resultList;

  /// Create a copy of InstListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstListResponseImplCopyWith<_$InstListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InstItem _$InstItemFromJson(Map<String, dynamic> json) {
  return _InstItem.fromJson(json);
}

/// @nodoc
mixin _$InstItem {
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get no => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instKindNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get crtDt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get deptCnt => throw _privateConstructorUsedError;

  /// Serializes this InstItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstItemCopyWith<InstItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstItemCopyWith<$Res> {
  factory $InstItemCopyWith(InstItem value, $Res Function(InstItem) then) =
      _$InstItemCopyWithImpl<$Res, InstItem>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? instKindNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? crtDt,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? deptCnt});
}

/// @nodoc
class _$InstItemCopyWithImpl<$Res, $Val extends InstItem>
    implements $InstItemCopyWith<$Res> {
  _$InstItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? no = freezed,
    Object? instNm = freezed,
    Object? instKindNm = freezed,
    Object? crtDt = freezed,
    Object? deptCnt = freezed,
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
      instKindNm: freezed == instKindNm
          ? _value.instKindNm
          : instKindNm // ignore: cast_nullable_to_non_nullable
              as String?,
      crtDt: freezed == crtDt
          ? _value.crtDt
          : crtDt // ignore: cast_nullable_to_non_nullable
              as String?,
      deptCnt: freezed == deptCnt
          ? _value.deptCnt
          : deptCnt // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstItemImplCopyWith<$Res>
    implements $InstItemCopyWith<$Res> {
  factory _$$InstItemImplCopyWith(
          _$InstItemImpl value, $Res Function(_$InstItemImpl) then) =
      __$$InstItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? instKindNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? crtDt,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? deptCnt});
}

/// @nodoc
class __$$InstItemImplCopyWithImpl<$Res>
    extends _$InstItemCopyWithImpl<$Res, _$InstItemImpl>
    implements _$$InstItemImplCopyWith<$Res> {
  __$$InstItemImplCopyWithImpl(
      _$InstItemImpl _value, $Res Function(_$InstItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of InstItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? no = freezed,
    Object? instNm = freezed,
    Object? instKindNm = freezed,
    Object? crtDt = freezed,
    Object? deptCnt = freezed,
  }) {
    return _then(_$InstItemImpl(
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      instNm: freezed == instNm
          ? _value.instNm
          : instNm // ignore: cast_nullable_to_non_nullable
              as String?,
      instKindNm: freezed == instKindNm
          ? _value.instKindNm
          : instKindNm // ignore: cast_nullable_to_non_nullable
              as String?,
      crtDt: freezed == crtDt
          ? _value.crtDt
          : crtDt // ignore: cast_nullable_to_non_nullable
              as String?,
      deptCnt: freezed == deptCnt
          ? _value.deptCnt
          : deptCnt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstItemImpl implements _InstItem {
  const _$InstItemImpl(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.instKindNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.crtDt,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.deptCnt});

  factory _$InstItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstItemImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? no;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? instNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? instKindNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? crtDt;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? deptCnt;

  @override
  String toString() {
    return 'InstItem(no: $no, instNm: $instNm, instKindNm: $instKindNm, crtDt: $crtDt, deptCnt: $deptCnt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstItemImpl &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.instNm, instNm) || other.instNm == instNm) &&
            (identical(other.instKindNm, instKindNm) ||
                other.instKindNm == instKindNm) &&
            (identical(other.crtDt, crtDt) || other.crtDt == crtDt) &&
            (identical(other.deptCnt, deptCnt) || other.deptCnt == deptCnt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, no, instNm, instKindNm, crtDt, deptCnt);

  /// Create a copy of InstItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstItemImplCopyWith<_$InstItemImpl> get copyWith =>
      __$$InstItemImplCopyWithImpl<_$InstItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstItemImplToJson(
      this,
    );
  }
}

abstract class _InstItem implements InstItem {
  const factory _InstItem(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? instNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? instKindNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? crtDt,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? deptCnt}) = _$InstItemImpl;

  factory _InstItem.fromJson(Map<String, dynamic> json) =
      _$InstItemImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get no;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get instKindNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get crtDt;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get deptCnt;

  /// Create a copy of InstItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstItemImplCopyWith<_$InstItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
