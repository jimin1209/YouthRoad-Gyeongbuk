// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'policy_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PolicyListResponse _$PolicyListResponseFromJson(Map<String, dynamic> json) {
  return _PolicyListResponse.fromJson(json);
}

/// @nodoc
mixin _$PolicyListResponse {
  bool get success => throw _privateConstructorUsedError;
  String get msg => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<PolicyItem> get resultList => throw _privateConstructorUsedError;
  PaginationInfo? get paginationInfo => throw _privateConstructorUsedError;

  /// Serializes this PolicyListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PolicyListResponseCopyWith<PolicyListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyListResponseCopyWith<$Res> {
  factory $PolicyListResponseCopyWith(
          PolicyListResponse value, $Res Function(PolicyListResponse) then) =
      _$PolicyListResponseCopyWithImpl<$Res, PolicyListResponse>;
  @useResult
  $Res call(
      {bool success,
      String msg,
      @JsonKey(defaultValue: []) List<PolicyItem> resultList,
      PaginationInfo? paginationInfo});

  $PaginationInfoCopyWith<$Res>? get paginationInfo;
}

/// @nodoc
class _$PolicyListResponseCopyWithImpl<$Res, $Val extends PolicyListResponse>
    implements $PolicyListResponseCopyWith<$Res> {
  _$PolicyListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = null,
    Object? resultList = null,
    Object? paginationInfo = freezed,
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
              as List<PolicyItem>,
      paginationInfo: freezed == paginationInfo
          ? _value.paginationInfo
          : paginationInfo // ignore: cast_nullable_to_non_nullable
              as PaginationInfo?,
    ) as $Val);
  }

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res>? get paginationInfo {
    if (_value.paginationInfo == null) {
      return null;
    }

    return $PaginationInfoCopyWith<$Res>(_value.paginationInfo!, (value) {
      return _then(_value.copyWith(paginationInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PolicyListResponseImplCopyWith<$Res>
    implements $PolicyListResponseCopyWith<$Res> {
  factory _$$PolicyListResponseImplCopyWith(_$PolicyListResponseImpl value,
          $Res Function(_$PolicyListResponseImpl) then) =
      __$$PolicyListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String msg,
      @JsonKey(defaultValue: []) List<PolicyItem> resultList,
      PaginationInfo? paginationInfo});

  @override
  $PaginationInfoCopyWith<$Res>? get paginationInfo;
}

/// @nodoc
class __$$PolicyListResponseImplCopyWithImpl<$Res>
    extends _$PolicyListResponseCopyWithImpl<$Res, _$PolicyListResponseImpl>
    implements _$$PolicyListResponseImplCopyWith<$Res> {
  __$$PolicyListResponseImplCopyWithImpl(_$PolicyListResponseImpl _value,
      $Res Function(_$PolicyListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = null,
    Object? resultList = null,
    Object? paginationInfo = freezed,
  }) {
    return _then(_$PolicyListResponseImpl(
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
              as List<PolicyItem>,
      paginationInfo: freezed == paginationInfo
          ? _value.paginationInfo
          : paginationInfo // ignore: cast_nullable_to_non_nullable
              as PaginationInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyListResponseImpl implements _PolicyListResponse {
  const _$PolicyListResponseImpl(
      {required this.success,
      required this.msg,
      @JsonKey(defaultValue: []) required final List<PolicyItem> resultList,
      this.paginationInfo})
      : _resultList = resultList;

  factory _$PolicyListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String msg;
  final List<PolicyItem> _resultList;
  @override
  @JsonKey(defaultValue: [])
  List<PolicyItem> get resultList {
    if (_resultList is EqualUnmodifiableListView) return _resultList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resultList);
  }

  @override
  final PaginationInfo? paginationInfo;

  @override
  String toString() {
    return 'PolicyListResponse(success: $success, msg: $msg, resultList: $resultList, paginationInfo: $paginationInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyListResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            const DeepCollectionEquality()
                .equals(other._resultList, _resultList) &&
            (identical(other.paginationInfo, paginationInfo) ||
                other.paginationInfo == paginationInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, msg,
      const DeepCollectionEquality().hash(_resultList), paginationInfo);

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PolicyListResponseImplCopyWith<_$PolicyListResponseImpl> get copyWith =>
      __$$PolicyListResponseImplCopyWithImpl<_$PolicyListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicyListResponseImplToJson(
      this,
    );
  }
}

abstract class _PolicyListResponse implements PolicyListResponse {
  const factory _PolicyListResponse(
      {required final bool success,
      required final String msg,
      @JsonKey(defaultValue: []) required final List<PolicyItem> resultList,
      final PaginationInfo? paginationInfo}) = _$PolicyListResponseImpl;

  factory _PolicyListResponse.fromJson(Map<String, dynamic> json) =
      _$PolicyListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get msg;
  @override
  @JsonKey(defaultValue: [])
  List<PolicyItem> get resultList;
  @override
  PaginationInfo? get paginationInfo;

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolicyListResponseImplCopyWith<_$PolicyListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PolicyItem _$PolicyItemFromJson(Map<String, dynamic> json) {
  return _PolicyItem.fromJson(json);
}

/// @nodoc
mixin _$PolicyItem {
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get no => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyYr => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get rgnSeNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyTypeNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get sprvsnInstNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get operInstNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyNm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyBgngYmd => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyEndYmd => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyScl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyCn => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyEnq => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyYn => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyBgngDt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyEndDt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyPsbltyYn => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get dtlLinkUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get dsplyYn => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get crtDt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get updtDt => throw _privateConstructorUsedError;

  /// Serializes this PolicyItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PolicyItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PolicyItemCopyWith<PolicyItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyItemCopyWith<$Res> {
  factory $PolicyItemCopyWith(
          PolicyItem value, $Res Function(PolicyItem) then) =
      _$PolicyItemCopyWithImpl<$Res, PolicyItem>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyYr,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? rgnSeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyTypeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? sprvsnInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? operInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyBgngYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyEndYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyScl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyCn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyEnq,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? aplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? aplyBgngDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? aplyEndDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? aplyPsbltyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? dtlLinkUrl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? dsplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? crtDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? updtDt});
}

/// @nodoc
class _$PolicyItemCopyWithImpl<$Res, $Val extends PolicyItem>
    implements $PolicyItemCopyWith<$Res> {
  _$PolicyItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PolicyItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? no = freezed,
    Object? policyYr = freezed,
    Object? rgnSeNm = freezed,
    Object? policyTypeNm = freezed,
    Object? sprvsnInstNm = freezed,
    Object? operInstNm = freezed,
    Object? policyNm = freezed,
    Object? policyBgngYmd = freezed,
    Object? policyEndYmd = freezed,
    Object? policyScl = freezed,
    Object? policyCn = freezed,
    Object? policyEnq = freezed,
    Object? aplyYn = freezed,
    Object? aplyBgngDt = freezed,
    Object? aplyEndDt = freezed,
    Object? aplyPsbltyYn = freezed,
    Object? dtlLinkUrl = freezed,
    Object? dsplyYn = freezed,
    Object? crtDt = freezed,
    Object? updtDt = freezed,
  }) {
    return _then(_value.copyWith(
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      policyYr: freezed == policyYr
          ? _value.policyYr
          : policyYr // ignore: cast_nullable_to_non_nullable
              as String?,
      rgnSeNm: freezed == rgnSeNm
          ? _value.rgnSeNm
          : rgnSeNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyTypeNm: freezed == policyTypeNm
          ? _value.policyTypeNm
          : policyTypeNm // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstNm: freezed == sprvsnInstNm
          ? _value.sprvsnInstNm
          : sprvsnInstNm // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstNm: freezed == operInstNm
          ? _value.operInstNm
          : operInstNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyNm: freezed == policyNm
          ? _value.policyNm
          : policyNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyBgngYmd: freezed == policyBgngYmd
          ? _value.policyBgngYmd
          : policyBgngYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      policyEndYmd: freezed == policyEndYmd
          ? _value.policyEndYmd
          : policyEndYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      policyScl: freezed == policyScl
          ? _value.policyScl
          : policyScl // ignore: cast_nullable_to_non_nullable
              as String?,
      policyCn: freezed == policyCn
          ? _value.policyCn
          : policyCn // ignore: cast_nullable_to_non_nullable
              as String?,
      policyEnq: freezed == policyEnq
          ? _value.policyEnq
          : policyEnq // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyYn: freezed == aplyYn
          ? _value.aplyYn
          : aplyYn // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyBgngDt: freezed == aplyBgngDt
          ? _value.aplyBgngDt
          : aplyBgngDt // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyEndDt: freezed == aplyEndDt
          ? _value.aplyEndDt
          : aplyEndDt // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyPsbltyYn: freezed == aplyPsbltyYn
          ? _value.aplyPsbltyYn
          : aplyPsbltyYn // ignore: cast_nullable_to_non_nullable
              as String?,
      dtlLinkUrl: freezed == dtlLinkUrl
          ? _value.dtlLinkUrl
          : dtlLinkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dsplyYn: freezed == dsplyYn
          ? _value.dsplyYn
          : dsplyYn // ignore: cast_nullable_to_non_nullable
              as String?,
      crtDt: freezed == crtDt
          ? _value.crtDt
          : crtDt // ignore: cast_nullable_to_non_nullable
              as String?,
      updtDt: freezed == updtDt
          ? _value.updtDt
          : updtDt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PolicyItemImplCopyWith<$Res>
    implements $PolicyItemCopyWith<$Res> {
  factory _$$PolicyItemImplCopyWith(
          _$PolicyItemImpl value, $Res Function(_$PolicyItemImpl) then) =
      __$$PolicyItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyYr,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? rgnSeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyTypeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? sprvsnInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? operInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyBgngYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyEndYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyScl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyCn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? policyEnq,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? aplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? aplyBgngDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? aplyEndDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? aplyPsbltyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? dtlLinkUrl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? dsplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? crtDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      String? updtDt});
}

/// @nodoc
class __$$PolicyItemImplCopyWithImpl<$Res>
    extends _$PolicyItemCopyWithImpl<$Res, _$PolicyItemImpl>
    implements _$$PolicyItemImplCopyWith<$Res> {
  __$$PolicyItemImplCopyWithImpl(
      _$PolicyItemImpl _value, $Res Function(_$PolicyItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PolicyItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? no = freezed,
    Object? policyYr = freezed,
    Object? rgnSeNm = freezed,
    Object? policyTypeNm = freezed,
    Object? sprvsnInstNm = freezed,
    Object? operInstNm = freezed,
    Object? policyNm = freezed,
    Object? policyBgngYmd = freezed,
    Object? policyEndYmd = freezed,
    Object? policyScl = freezed,
    Object? policyCn = freezed,
    Object? policyEnq = freezed,
    Object? aplyYn = freezed,
    Object? aplyBgngDt = freezed,
    Object? aplyEndDt = freezed,
    Object? aplyPsbltyYn = freezed,
    Object? dtlLinkUrl = freezed,
    Object? dsplyYn = freezed,
    Object? crtDt = freezed,
    Object? updtDt = freezed,
  }) {
    return _then(_$PolicyItemImpl(
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      policyYr: freezed == policyYr
          ? _value.policyYr
          : policyYr // ignore: cast_nullable_to_non_nullable
              as String?,
      rgnSeNm: freezed == rgnSeNm
          ? _value.rgnSeNm
          : rgnSeNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyTypeNm: freezed == policyTypeNm
          ? _value.policyTypeNm
          : policyTypeNm // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstNm: freezed == sprvsnInstNm
          ? _value.sprvsnInstNm
          : sprvsnInstNm // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstNm: freezed == operInstNm
          ? _value.operInstNm
          : operInstNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyNm: freezed == policyNm
          ? _value.policyNm
          : policyNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyBgngYmd: freezed == policyBgngYmd
          ? _value.policyBgngYmd
          : policyBgngYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      policyEndYmd: freezed == policyEndYmd
          ? _value.policyEndYmd
          : policyEndYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      policyScl: freezed == policyScl
          ? _value.policyScl
          : policyScl // ignore: cast_nullable_to_non_nullable
              as String?,
      policyCn: freezed == policyCn
          ? _value.policyCn
          : policyCn // ignore: cast_nullable_to_non_nullable
              as String?,
      policyEnq: freezed == policyEnq
          ? _value.policyEnq
          : policyEnq // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyYn: freezed == aplyYn
          ? _value.aplyYn
          : aplyYn // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyBgngDt: freezed == aplyBgngDt
          ? _value.aplyBgngDt
          : aplyBgngDt // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyEndDt: freezed == aplyEndDt
          ? _value.aplyEndDt
          : aplyEndDt // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyPsbltyYn: freezed == aplyPsbltyYn
          ? _value.aplyPsbltyYn
          : aplyPsbltyYn // ignore: cast_nullable_to_non_nullable
              as String?,
      dtlLinkUrl: freezed == dtlLinkUrl
          ? _value.dtlLinkUrl
          : dtlLinkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dsplyYn: freezed == dsplyYn
          ? _value.dsplyYn
          : dsplyYn // ignore: cast_nullable_to_non_nullable
              as String?,
      crtDt: freezed == crtDt
          ? _value.crtDt
          : crtDt // ignore: cast_nullable_to_non_nullable
              as String?,
      updtDt: freezed == updtDt
          ? _value.updtDt
          : updtDt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyItemImpl implements _PolicyItem {
  const _$PolicyItemImpl(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.policyYr,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.rgnSeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.policyTypeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.sprvsnInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.operInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.policyNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.policyBgngYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.policyEndYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.policyScl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.policyCn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.policyEnq,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.aplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.aplyBgngDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.aplyEndDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.aplyPsbltyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      this.dtlLinkUrl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.dsplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.crtDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) this.updtDt});

  factory _$PolicyItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyItemImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? no;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyYr;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? rgnSeNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyTypeNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? sprvsnInstNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? operInstNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyBgngYmd;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyEndYmd;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyScl;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyCn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? policyEnq;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? aplyYn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? aplyBgngDt;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? aplyEndDt;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? aplyPsbltyYn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? dtlLinkUrl;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? dsplyYn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? crtDt;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  final String? updtDt;

  @override
  String toString() {
    return 'PolicyItem(no: $no, policyYr: $policyYr, rgnSeNm: $rgnSeNm, policyTypeNm: $policyTypeNm, sprvsnInstNm: $sprvsnInstNm, operInstNm: $operInstNm, policyNm: $policyNm, policyBgngYmd: $policyBgngYmd, policyEndYmd: $policyEndYmd, policyScl: $policyScl, policyCn: $policyCn, policyEnq: $policyEnq, aplyYn: $aplyYn, aplyBgngDt: $aplyBgngDt, aplyEndDt: $aplyEndDt, aplyPsbltyYn: $aplyPsbltyYn, dtlLinkUrl: $dtlLinkUrl, dsplyYn: $dsplyYn, crtDt: $crtDt, updtDt: $updtDt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyItemImpl &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.policyYr, policyYr) ||
                other.policyYr == policyYr) &&
            (identical(other.rgnSeNm, rgnSeNm) || other.rgnSeNm == rgnSeNm) &&
            (identical(other.policyTypeNm, policyTypeNm) ||
                other.policyTypeNm == policyTypeNm) &&
            (identical(other.sprvsnInstNm, sprvsnInstNm) ||
                other.sprvsnInstNm == sprvsnInstNm) &&
            (identical(other.operInstNm, operInstNm) ||
                other.operInstNm == operInstNm) &&
            (identical(other.policyNm, policyNm) ||
                other.policyNm == policyNm) &&
            (identical(other.policyBgngYmd, policyBgngYmd) ||
                other.policyBgngYmd == policyBgngYmd) &&
            (identical(other.policyEndYmd, policyEndYmd) ||
                other.policyEndYmd == policyEndYmd) &&
            (identical(other.policyScl, policyScl) ||
                other.policyScl == policyScl) &&
            (identical(other.policyCn, policyCn) ||
                other.policyCn == policyCn) &&
            (identical(other.policyEnq, policyEnq) ||
                other.policyEnq == policyEnq) &&
            (identical(other.aplyYn, aplyYn) || other.aplyYn == aplyYn) &&
            (identical(other.aplyBgngDt, aplyBgngDt) ||
                other.aplyBgngDt == aplyBgngDt) &&
            (identical(other.aplyEndDt, aplyEndDt) ||
                other.aplyEndDt == aplyEndDt) &&
            (identical(other.aplyPsbltyYn, aplyPsbltyYn) ||
                other.aplyPsbltyYn == aplyPsbltyYn) &&
            (identical(other.dtlLinkUrl, dtlLinkUrl) ||
                other.dtlLinkUrl == dtlLinkUrl) &&
            (identical(other.dsplyYn, dsplyYn) || other.dsplyYn == dsplyYn) &&
            (identical(other.crtDt, crtDt) || other.crtDt == crtDt) &&
            (identical(other.updtDt, updtDt) || other.updtDt == updtDt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        no,
        policyYr,
        rgnSeNm,
        policyTypeNm,
        sprvsnInstNm,
        operInstNm,
        policyNm,
        policyBgngYmd,
        policyEndYmd,
        policyScl,
        policyCn,
        policyEnq,
        aplyYn,
        aplyBgngDt,
        aplyEndDt,
        aplyPsbltyYn,
        dtlLinkUrl,
        dsplyYn,
        crtDt,
        updtDt
      ]);

  /// Create a copy of PolicyItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PolicyItemImplCopyWith<_$PolicyItemImpl> get copyWith =>
      __$$PolicyItemImplCopyWithImpl<_$PolicyItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicyItemImplToJson(
      this,
    );
  }
}

abstract class _PolicyItem implements PolicyItem {
  const factory _PolicyItem(
      {@JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? no,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyYr,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? rgnSeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyTypeNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? sprvsnInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? operInstNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyNm,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyBgngYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyEndYmd,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyScl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyCn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? policyEnq,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? aplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? aplyBgngDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? aplyEndDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? aplyPsbltyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? dtlLinkUrl,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? dsplyYn,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? crtDt,
      @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
      final String? updtDt}) = _$PolicyItemImpl;

  factory _PolicyItem.fromJson(Map<String, dynamic> json) =
      _$PolicyItemImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get no;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyYr;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get rgnSeNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyTypeNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get sprvsnInstNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get operInstNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyNm;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyBgngYmd;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyEndYmd;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyScl;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyCn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get policyEnq;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyYn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyBgngDt;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyEndDt;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get aplyPsbltyYn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get dtlLinkUrl;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get dsplyYn;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get crtDt;
  @override
  @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson)
  String? get updtDt;

  /// Create a copy of PolicyItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolicyItemImplCopyWith<_$PolicyItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) {
  return _PaginationInfo.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfo {
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get currentPageNo => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get recordCountPerPage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get pageSize => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get totalRecordCount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get totalPageCount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get firstPageNo => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get lastPageNo => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get firstPageNoOnPageList => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get lastPageNoOnPageList => throw _privateConstructorUsedError;

  /// Serializes this PaginationInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationInfoCopyWith<PaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoCopyWith<$Res> {
  factory $PaginationInfoCopyWith(
          PaginationInfo value, $Res Function(PaginationInfo) then) =
      _$PaginationInfoCopyWithImpl<$Res, PaginationInfo>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? currentPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? recordCountPerPage,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? pageSize,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? totalRecordCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? totalPageCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? firstPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? lastPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? firstPageNoOnPageList,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? lastPageNoOnPageList});
}

/// @nodoc
class _$PaginationInfoCopyWithImpl<$Res, $Val extends PaginationInfo>
    implements $PaginationInfoCopyWith<$Res> {
  _$PaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPageNo = freezed,
    Object? recordCountPerPage = freezed,
    Object? pageSize = freezed,
    Object? totalRecordCount = freezed,
    Object? totalPageCount = freezed,
    Object? firstPageNo = freezed,
    Object? lastPageNo = freezed,
    Object? firstPageNoOnPageList = freezed,
    Object? lastPageNoOnPageList = freezed,
  }) {
    return _then(_value.copyWith(
      currentPageNo: freezed == currentPageNo
          ? _value.currentPageNo
          : currentPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      recordCountPerPage: freezed == recordCountPerPage
          ? _value.recordCountPerPage
          : recordCountPerPage // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRecordCount: freezed == totalRecordCount
          ? _value.totalRecordCount
          : totalRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPageCount: freezed == totalPageCount
          ? _value.totalPageCount
          : totalPageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      firstPageNo: freezed == firstPageNo
          ? _value.firstPageNo
          : firstPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPageNo: freezed == lastPageNo
          ? _value.lastPageNo
          : lastPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      firstPageNoOnPageList: freezed == firstPageNoOnPageList
          ? _value.firstPageNoOnPageList
          : firstPageNoOnPageList // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPageNoOnPageList: freezed == lastPageNoOnPageList
          ? _value.lastPageNoOnPageList
          : lastPageNoOnPageList // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoImplCopyWith<$Res>
    implements $PaginationInfoCopyWith<$Res> {
  factory _$$PaginationInfoImplCopyWith(_$PaginationInfoImpl value,
          $Res Function(_$PaginationInfoImpl) then) =
      __$$PaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? currentPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? recordCountPerPage,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? pageSize,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? totalRecordCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? totalPageCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? firstPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? lastPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? firstPageNoOnPageList,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      int? lastPageNoOnPageList});
}

/// @nodoc
class __$$PaginationInfoImplCopyWithImpl<$Res>
    extends _$PaginationInfoCopyWithImpl<$Res, _$PaginationInfoImpl>
    implements _$$PaginationInfoImplCopyWith<$Res> {
  __$$PaginationInfoImplCopyWithImpl(
      _$PaginationInfoImpl _value, $Res Function(_$PaginationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPageNo = freezed,
    Object? recordCountPerPage = freezed,
    Object? pageSize = freezed,
    Object? totalRecordCount = freezed,
    Object? totalPageCount = freezed,
    Object? firstPageNo = freezed,
    Object? lastPageNo = freezed,
    Object? firstPageNoOnPageList = freezed,
    Object? lastPageNoOnPageList = freezed,
  }) {
    return _then(_$PaginationInfoImpl(
      currentPageNo: freezed == currentPageNo
          ? _value.currentPageNo
          : currentPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      recordCountPerPage: freezed == recordCountPerPage
          ? _value.recordCountPerPage
          : recordCountPerPage // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRecordCount: freezed == totalRecordCount
          ? _value.totalRecordCount
          : totalRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPageCount: freezed == totalPageCount
          ? _value.totalPageCount
          : totalPageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      firstPageNo: freezed == firstPageNo
          ? _value.firstPageNo
          : firstPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPageNo: freezed == lastPageNo
          ? _value.lastPageNo
          : lastPageNo // ignore: cast_nullable_to_non_nullable
              as int?,
      firstPageNoOnPageList: freezed == firstPageNoOnPageList
          ? _value.firstPageNoOnPageList
          : firstPageNoOnPageList // ignore: cast_nullable_to_non_nullable
              as int?,
      lastPageNoOnPageList: freezed == lastPageNoOnPageList
          ? _value.lastPageNoOnPageList
          : lastPageNoOnPageList // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoImpl implements _PaginationInfo {
  const _$PaginationInfoImpl(
      {@JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.currentPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      this.recordCountPerPage,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.pageSize,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      this.totalRecordCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.totalPageCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.firstPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.lastPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      this.firstPageNoOnPageList,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      this.lastPageNoOnPageList});

  factory _$PaginationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? currentPageNo;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? recordCountPerPage;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? pageSize;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? totalRecordCount;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? totalPageCount;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? firstPageNo;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? lastPageNo;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? firstPageNoOnPageList;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? lastPageNoOnPageList;

  @override
  String toString() {
    return 'PaginationInfo(currentPageNo: $currentPageNo, recordCountPerPage: $recordCountPerPage, pageSize: $pageSize, totalRecordCount: $totalRecordCount, totalPageCount: $totalPageCount, firstPageNo: $firstPageNo, lastPageNo: $lastPageNo, firstPageNoOnPageList: $firstPageNoOnPageList, lastPageNoOnPageList: $lastPageNoOnPageList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoImpl &&
            (identical(other.currentPageNo, currentPageNo) ||
                other.currentPageNo == currentPageNo) &&
            (identical(other.recordCountPerPage, recordCountPerPage) ||
                other.recordCountPerPage == recordCountPerPage) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalRecordCount, totalRecordCount) ||
                other.totalRecordCount == totalRecordCount) &&
            (identical(other.totalPageCount, totalPageCount) ||
                other.totalPageCount == totalPageCount) &&
            (identical(other.firstPageNo, firstPageNo) ||
                other.firstPageNo == firstPageNo) &&
            (identical(other.lastPageNo, lastPageNo) ||
                other.lastPageNo == lastPageNo) &&
            (identical(other.firstPageNoOnPageList, firstPageNoOnPageList) ||
                other.firstPageNoOnPageList == firstPageNoOnPageList) &&
            (identical(other.lastPageNoOnPageList, lastPageNoOnPageList) ||
                other.lastPageNoOnPageList == lastPageNoOnPageList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentPageNo,
      recordCountPerPage,
      pageSize,
      totalRecordCount,
      totalPageCount,
      firstPageNo,
      lastPageNo,
      firstPageNoOnPageList,
      lastPageNoOnPageList);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      __$$PaginationInfoImplCopyWithImpl<_$PaginationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfo implements PaginationInfo {
  const factory _PaginationInfo(
      {@JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? currentPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? recordCountPerPage,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson) final int? pageSize,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? totalRecordCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? totalPageCount,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? firstPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? lastPageNo,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? firstPageNoOnPageList,
      @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
      final int? lastPageNoOnPageList}) = _$PaginationInfoImpl;

  factory _PaginationInfo.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get currentPageNo;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get recordCountPerPage;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get pageSize;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get totalRecordCount;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get totalPageCount;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get firstPageNo;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get lastPageNo;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get firstPageNoOnPageList;
  @override
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  int? get lastPageNoOnPageList;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
