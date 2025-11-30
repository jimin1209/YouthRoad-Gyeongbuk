// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DepartmentListResponse _$DepartmentListResponseFromJson(
    Map<String, dynamic> json) {
  return _DepartmentListResponse.fromJson(json);
}

/// @nodoc
mixin _$DepartmentListResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  List<Department>? get resultList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DepartmentListResponseCopyWith<DepartmentListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepartmentListResponseCopyWith<$Res> {
  factory $DepartmentListResponseCopyWith(DepartmentListResponse value,
          $Res Function(DepartmentListResponse) then) =
      _$DepartmentListResponseCopyWithImpl<$Res, DepartmentListResponse>;
  @useResult
  $Res call({bool success, String? msg, List<Department>? resultList});
}

/// @nodoc
class _$DepartmentListResponseCopyWithImpl<$Res,
        $Val extends DepartmentListResponse>
    implements $DepartmentListResponseCopyWith<$Res> {
  _$DepartmentListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = freezed,
    Object? resultList = freezed,
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
              as List<Department>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DepartmentListResponseImplCopyWith<$Res>
    implements $DepartmentListResponseCopyWith<$Res> {
  factory _$$DepartmentListResponseImplCopyWith(
          _$DepartmentListResponseImpl value,
          $Res Function(_$DepartmentListResponseImpl) then) =
      __$$DepartmentListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? msg, List<Department>? resultList});
}

/// @nodoc
class __$$DepartmentListResponseImplCopyWithImpl<$Res>
    extends _$DepartmentListResponseCopyWithImpl<$Res,
        _$DepartmentListResponseImpl>
    implements _$$DepartmentListResponseImplCopyWith<$Res> {
  __$$DepartmentListResponseImplCopyWithImpl(
      _$DepartmentListResponseImpl _value,
      $Res Function(_$DepartmentListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = freezed,
    Object? resultList = freezed,
  }) {
    return _then(_$DepartmentListResponseImpl(
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
              as List<Department>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DepartmentListResponseImpl implements _DepartmentListResponse {
  const _$DepartmentListResponseImpl(
      {required this.success, this.msg, final List<Department>? resultList})
      : _resultList = resultList;

  factory _$DepartmentListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepartmentListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? msg;
  final List<Department>? _resultList;
  @override
  List<Department>? get resultList {
    final value = _resultList;
    if (value == null) return null;
    if (_resultList is EqualUnmodifiableListView) return _resultList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'DepartmentListResponse(success: $success, msg: $msg, resultList: $resultList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepartmentListResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            const DeepCollectionEquality()
                .equals(other._resultList, _resultList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, msg,
      const DeepCollectionEquality().hash(_resultList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DepartmentListResponseImplCopyWith<_$DepartmentListResponseImpl>
      get copyWith => __$$DepartmentListResponseImplCopyWithImpl<
          _$DepartmentListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DepartmentListResponseImplToJson(
      this,
    );
  }
}

abstract class _DepartmentListResponse implements DepartmentListResponse {
  const factory _DepartmentListResponse(
      {required final bool success,
      final String? msg,
      final List<Department>? resultList}) = _$DepartmentListResponseImpl;

  factory _DepartmentListResponse.fromJson(Map<String, dynamic> json) =
      _$DepartmentListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get msg;
  @override
  List<Department>? get resultList;
  @override
  @JsonKey(ignore: true)
  _$$DepartmentListResponseImplCopyWith<_$DepartmentListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
