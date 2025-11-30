// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institution_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InstitutionListResponse _$InstitutionListResponseFromJson(
    Map<String, dynamic> json) {
  return _InstitutionListResponse.fromJson(json);
}

/// @nodoc
mixin _$InstitutionListResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  List<Institution>? get resultList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InstitutionListResponseCopyWith<InstitutionListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstitutionListResponseCopyWith<$Res> {
  factory $InstitutionListResponseCopyWith(InstitutionListResponse value,
          $Res Function(InstitutionListResponse) then) =
      _$InstitutionListResponseCopyWithImpl<$Res, InstitutionListResponse>;
  @useResult
  $Res call({bool success, String? msg, List<Institution>? resultList});
}

/// @nodoc
class _$InstitutionListResponseCopyWithImpl<$Res,
        $Val extends InstitutionListResponse>
    implements $InstitutionListResponseCopyWith<$Res> {
  _$InstitutionListResponseCopyWithImpl(this._value, this._then);

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
              as List<Institution>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstitutionListResponseImplCopyWith<$Res>
    implements $InstitutionListResponseCopyWith<$Res> {
  factory _$$InstitutionListResponseImplCopyWith(
          _$InstitutionListResponseImpl value,
          $Res Function(_$InstitutionListResponseImpl) then) =
      __$$InstitutionListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? msg, List<Institution>? resultList});
}

/// @nodoc
class __$$InstitutionListResponseImplCopyWithImpl<$Res>
    extends _$InstitutionListResponseCopyWithImpl<$Res,
        _$InstitutionListResponseImpl>
    implements _$$InstitutionListResponseImplCopyWith<$Res> {
  __$$InstitutionListResponseImplCopyWithImpl(
      _$InstitutionListResponseImpl _value,
      $Res Function(_$InstitutionListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? msg = freezed,
    Object? resultList = freezed,
  }) {
    return _then(_$InstitutionListResponseImpl(
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
              as List<Institution>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstitutionListResponseImpl implements _InstitutionListResponse {
  const _$InstitutionListResponseImpl(
      {required this.success, this.msg, final List<Institution>? resultList})
      : _resultList = resultList;

  factory _$InstitutionListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstitutionListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? msg;
  final List<Institution>? _resultList;
  @override
  List<Institution>? get resultList {
    final value = _resultList;
    if (value == null) return null;
    if (_resultList is EqualUnmodifiableListView) return _resultList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'InstitutionListResponse(success: $success, msg: $msg, resultList: $resultList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstitutionListResponseImpl &&
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
  _$$InstitutionListResponseImplCopyWith<_$InstitutionListResponseImpl>
      get copyWith => __$$InstitutionListResponseImplCopyWithImpl<
          _$InstitutionListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstitutionListResponseImplToJson(
      this,
    );
  }
}

abstract class _InstitutionListResponse implements InstitutionListResponse {
  const factory _InstitutionListResponse(
      {required final bool success,
      final String? msg,
      final List<Institution>? resultList}) = _$InstitutionListResponseImpl;

  factory _InstitutionListResponse.fromJson(Map<String, dynamic> json) =
      _$InstitutionListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get msg;
  @override
  List<Institution>? get resultList;
  @override
  @JsonKey(ignore: true)
  _$$InstitutionListResponseImplCopyWith<_$InstitutionListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
