// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'policy_list_response.dart';

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
  String? get msg => throw _privateConstructorUsedError;
  List<Policy>? get resultList => throw _privateConstructorUsedError;
  Map<String, dynamic>? get paginationInfo =>
      throw _privateConstructorUsedError;

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
      String? msg,
      List<Policy>? resultList,
      Map<String, dynamic>? paginationInfo});
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
    Object? msg = freezed,
    Object? resultList = freezed,
    Object? paginationInfo = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      resultList: freezed == resultList
          ? _value.resultList
          : resultList // ignore: cast_nullable_to_non_nullable
              as List<Policy>?,
      paginationInfo: freezed == paginationInfo
          ? _value.paginationInfo
          : paginationInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
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
      String? msg,
      List<Policy>? resultList,
      Map<String, dynamic>? paginationInfo});
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
    Object? msg = freezed,
    Object? resultList = freezed,
    Object? paginationInfo = freezed,
  }) {
    return _then(_$PolicyListResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      resultList: freezed == resultList
          ? _value._resultList
          : resultList // ignore: cast_nullable_to_non_nullable
              as List<Policy>?,
      paginationInfo: freezed == paginationInfo
          ? _value._paginationInfo
          : paginationInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyListResponseImpl implements _PolicyListResponse {
  const _$PolicyListResponseImpl(
      {required this.success,
      this.msg,
      final List<Policy>? resultList,
      final Map<String, dynamic>? paginationInfo})
      : _resultList = resultList,
        _paginationInfo = paginationInfo;

  factory _$PolicyListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? msg;
  final List<Policy>? _resultList;
  @override
  List<Policy>? get resultList {
    final value = _resultList;
    if (value == null) return null;
    if (_resultList is EqualUnmodifiableListView) return _resultList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _paginationInfo;
  @override
  Map<String, dynamic>? get paginationInfo {
    final value = _paginationInfo;
    if (value == null) return null;
    if (_paginationInfo is EqualUnmodifiableMapView) return _paginationInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

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
            const DeepCollectionEquality()
                .equals(other._paginationInfo, _paginationInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      msg,
      const DeepCollectionEquality().hash(_resultList),
      const DeepCollectionEquality().hash(_paginationInfo));

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
      final String? msg,
      final List<Policy>? resultList,
      final Map<String, dynamic>? paginationInfo}) = _$PolicyListResponseImpl;

  factory _PolicyListResponse.fromJson(Map<String, dynamic> json) =
      _$PolicyListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get msg;
  @override
  List<Policy>? get resultList;
  @override
  Map<String, dynamic>? get paginationInfo;

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolicyListResponseImplCopyWith<_$PolicyListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
