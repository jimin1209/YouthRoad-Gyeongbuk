// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'center_youthcenter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CenterYouthcenterDto _$CenterYouthcenterDtoFromJson(Map<String, dynamic> json) {
  return _CenterYouthcenterDto.fromJson(json);
}

/// @nodoc
mixin _$CenterYouthcenterDto {
  int? get resultCode => throw _privateConstructorUsedError;
  String? get resultMessage => throw _privateConstructorUsedError;
  CenterYouthcenterResultDto? get result => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CenterYouthcenterDtoCopyWith<CenterYouthcenterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CenterYouthcenterDtoCopyWith<$Res> {
  factory $CenterYouthcenterDtoCopyWith(CenterYouthcenterDto value,
          $Res Function(CenterYouthcenterDto) then) =
      _$CenterYouthcenterDtoCopyWithImpl<$Res, CenterYouthcenterDto>;
  @useResult
  $Res call(
      {int? resultCode,
      String? resultMessage,
      CenterYouthcenterResultDto? result});

  $CenterYouthcenterResultDtoCopyWith<$Res>? get result;
}

/// @nodoc
class _$CenterYouthcenterDtoCopyWithImpl<$Res,
        $Val extends CenterYouthcenterDto>
    implements $CenterYouthcenterDtoCopyWith<$Res> {
  _$CenterYouthcenterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultCode = freezed,
    Object? resultMessage = freezed,
    Object? result = freezed,
  }) {
    return _then(_value.copyWith(
      resultCode: freezed == resultCode
          ? _value.resultCode
          : resultCode // ignore: cast_nullable_to_non_nullable
              as int?,
      resultMessage: freezed == resultMessage
          ? _value.resultMessage
          : resultMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as CenterYouthcenterResultDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CenterYouthcenterResultDtoCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $CenterYouthcenterResultDtoCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CenterYouthcenterDtoImplCopyWith<$Res>
    implements $CenterYouthcenterDtoCopyWith<$Res> {
  factory _$$CenterYouthcenterDtoImplCopyWith(_$CenterYouthcenterDtoImpl value,
          $Res Function(_$CenterYouthcenterDtoImpl) then) =
      __$$CenterYouthcenterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? resultCode,
      String? resultMessage,
      CenterYouthcenterResultDto? result});

  @override
  $CenterYouthcenterResultDtoCopyWith<$Res>? get result;
}

/// @nodoc
class __$$CenterYouthcenterDtoImplCopyWithImpl<$Res>
    extends _$CenterYouthcenterDtoCopyWithImpl<$Res, _$CenterYouthcenterDtoImpl>
    implements _$$CenterYouthcenterDtoImplCopyWith<$Res> {
  __$$CenterYouthcenterDtoImplCopyWithImpl(_$CenterYouthcenterDtoImpl _value,
      $Res Function(_$CenterYouthcenterDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultCode = freezed,
    Object? resultMessage = freezed,
    Object? result = freezed,
  }) {
    return _then(_$CenterYouthcenterDtoImpl(
      resultCode: freezed == resultCode
          ? _value.resultCode
          : resultCode // ignore: cast_nullable_to_non_nullable
              as int?,
      resultMessage: freezed == resultMessage
          ? _value.resultMessage
          : resultMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as CenterYouthcenterResultDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CenterYouthcenterDtoImpl implements _CenterYouthcenterDto {
  const _$CenterYouthcenterDtoImpl(
      {this.resultCode, this.resultMessage, this.result});

  factory _$CenterYouthcenterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CenterYouthcenterDtoImplFromJson(json);

  @override
  final int? resultCode;
  @override
  final String? resultMessage;
  @override
  final CenterYouthcenterResultDto? result;

  @override
  String toString() {
    return 'CenterYouthcenterDto(resultCode: $resultCode, resultMessage: $resultMessage, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CenterYouthcenterDtoImpl &&
            (identical(other.resultCode, resultCode) ||
                other.resultCode == resultCode) &&
            (identical(other.resultMessage, resultMessage) ||
                other.resultMessage == resultMessage) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, resultCode, resultMessage, result);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CenterYouthcenterDtoImplCopyWith<_$CenterYouthcenterDtoImpl>
      get copyWith =>
          __$$CenterYouthcenterDtoImplCopyWithImpl<_$CenterYouthcenterDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CenterYouthcenterDtoImplToJson(
      this,
    );
  }
}

abstract class _CenterYouthcenterDto implements CenterYouthcenterDto {
  const factory _CenterYouthcenterDto(
      {final int? resultCode,
      final String? resultMessage,
      final CenterYouthcenterResultDto? result}) = _$CenterYouthcenterDtoImpl;

  factory _CenterYouthcenterDto.fromJson(Map<String, dynamic> json) =
      _$CenterYouthcenterDtoImpl.fromJson;

  @override
  int? get resultCode;
  @override
  String? get resultMessage;
  @override
  CenterYouthcenterResultDto? get result;
  @override
  @JsonKey(ignore: true)
  _$$CenterYouthcenterDtoImplCopyWith<_$CenterYouthcenterDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CenterYouthcenterResultDto _$CenterYouthcenterResultDtoFromJson(
    Map<String, dynamic> json) {
  return _CenterYouthcenterResultDto.fromJson(json);
}

/// @nodoc
mixin _$CenterYouthcenterResultDto {
  CenterYouthcenterPaggingDto? get pagging =>
      throw _privateConstructorUsedError;
  List<CenterYouthcenterItemDto>? get youthPolicyList =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CenterYouthcenterResultDtoCopyWith<CenterYouthcenterResultDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CenterYouthcenterResultDtoCopyWith<$Res> {
  factory $CenterYouthcenterResultDtoCopyWith(CenterYouthcenterResultDto value,
          $Res Function(CenterYouthcenterResultDto) then) =
      _$CenterYouthcenterResultDtoCopyWithImpl<$Res,
          CenterYouthcenterResultDto>;
  @useResult
  $Res call(
      {CenterYouthcenterPaggingDto? pagging,
      List<CenterYouthcenterItemDto>? youthPolicyList});

  $CenterYouthcenterPaggingDtoCopyWith<$Res>? get pagging;
}

/// @nodoc
class _$CenterYouthcenterResultDtoCopyWithImpl<$Res,
        $Val extends CenterYouthcenterResultDto>
    implements $CenterYouthcenterResultDtoCopyWith<$Res> {
  _$CenterYouthcenterResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagging = freezed,
    Object? youthPolicyList = freezed,
  }) {
    return _then(_value.copyWith(
      pagging: freezed == pagging
          ? _value.pagging
          : pagging // ignore: cast_nullable_to_non_nullable
              as CenterYouthcenterPaggingDto?,
      youthPolicyList: freezed == youthPolicyList
          ? _value.youthPolicyList
          : youthPolicyList // ignore: cast_nullable_to_non_nullable
              as List<CenterYouthcenterItemDto>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CenterYouthcenterPaggingDtoCopyWith<$Res>? get pagging {
    if (_value.pagging == null) {
      return null;
    }

    return $CenterYouthcenterPaggingDtoCopyWith<$Res>(_value.pagging!, (value) {
      return _then(_value.copyWith(pagging: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CenterYouthcenterResultDtoImplCopyWith<$Res>
    implements $CenterYouthcenterResultDtoCopyWith<$Res> {
  factory _$$CenterYouthcenterResultDtoImplCopyWith(
          _$CenterYouthcenterResultDtoImpl value,
          $Res Function(_$CenterYouthcenterResultDtoImpl) then) =
      __$$CenterYouthcenterResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CenterYouthcenterPaggingDto? pagging,
      List<CenterYouthcenterItemDto>? youthPolicyList});

  @override
  $CenterYouthcenterPaggingDtoCopyWith<$Res>? get pagging;
}

/// @nodoc
class __$$CenterYouthcenterResultDtoImplCopyWithImpl<$Res>
    extends _$CenterYouthcenterResultDtoCopyWithImpl<$Res,
        _$CenterYouthcenterResultDtoImpl>
    implements _$$CenterYouthcenterResultDtoImplCopyWith<$Res> {
  __$$CenterYouthcenterResultDtoImplCopyWithImpl(
      _$CenterYouthcenterResultDtoImpl _value,
      $Res Function(_$CenterYouthcenterResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagging = freezed,
    Object? youthPolicyList = freezed,
  }) {
    return _then(_$CenterYouthcenterResultDtoImpl(
      pagging: freezed == pagging
          ? _value.pagging
          : pagging // ignore: cast_nullable_to_non_nullable
              as CenterYouthcenterPaggingDto?,
      youthPolicyList: freezed == youthPolicyList
          ? _value._youthPolicyList
          : youthPolicyList // ignore: cast_nullable_to_non_nullable
              as List<CenterYouthcenterItemDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CenterYouthcenterResultDtoImpl implements _CenterYouthcenterResultDto {
  const _$CenterYouthcenterResultDtoImpl(
      {this.pagging, final List<CenterYouthcenterItemDto>? youthPolicyList})
      : _youthPolicyList = youthPolicyList;

  factory _$CenterYouthcenterResultDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CenterYouthcenterResultDtoImplFromJson(json);

  @override
  final CenterYouthcenterPaggingDto? pagging;
  final List<CenterYouthcenterItemDto>? _youthPolicyList;
  @override
  List<CenterYouthcenterItemDto>? get youthPolicyList {
    final value = _youthPolicyList;
    if (value == null) return null;
    if (_youthPolicyList is EqualUnmodifiableListView) return _youthPolicyList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CenterYouthcenterResultDto(pagging: $pagging, youthPolicyList: $youthPolicyList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CenterYouthcenterResultDtoImpl &&
            (identical(other.pagging, pagging) || other.pagging == pagging) &&
            const DeepCollectionEquality()
                .equals(other._youthPolicyList, _youthPolicyList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pagging,
      const DeepCollectionEquality().hash(_youthPolicyList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CenterYouthcenterResultDtoImplCopyWith<_$CenterYouthcenterResultDtoImpl>
      get copyWith => __$$CenterYouthcenterResultDtoImplCopyWithImpl<
          _$CenterYouthcenterResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CenterYouthcenterResultDtoImplToJson(
      this,
    );
  }
}

abstract class _CenterYouthcenterResultDto
    implements CenterYouthcenterResultDto {
  const factory _CenterYouthcenterResultDto(
          {final CenterYouthcenterPaggingDto? pagging,
          final List<CenterYouthcenterItemDto>? youthPolicyList}) =
      _$CenterYouthcenterResultDtoImpl;

  factory _CenterYouthcenterResultDto.fromJson(Map<String, dynamic> json) =
      _$CenterYouthcenterResultDtoImpl.fromJson;

  @override
  CenterYouthcenterPaggingDto? get pagging;
  @override
  List<CenterYouthcenterItemDto>? get youthPolicyList;
  @override
  @JsonKey(ignore: true)
  _$$CenterYouthcenterResultDtoImplCopyWith<_$CenterYouthcenterResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CenterYouthcenterPaggingDto _$CenterYouthcenterPaggingDtoFromJson(
    Map<String, dynamic> json) {
  return _CenterYouthcenterPaggingDto.fromJson(json);
}

/// @nodoc
mixin _$CenterYouthcenterPaggingDto {
  int? get totCount => throw _privateConstructorUsedError;
  int? get pageNum => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CenterYouthcenterPaggingDtoCopyWith<CenterYouthcenterPaggingDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CenterYouthcenterPaggingDtoCopyWith<$Res> {
  factory $CenterYouthcenterPaggingDtoCopyWith(
          CenterYouthcenterPaggingDto value,
          $Res Function(CenterYouthcenterPaggingDto) then) =
      _$CenterYouthcenterPaggingDtoCopyWithImpl<$Res,
          CenterYouthcenterPaggingDto>;
  @useResult
  $Res call({int? totCount, int? pageNum, int? pageSize});
}

/// @nodoc
class _$CenterYouthcenterPaggingDtoCopyWithImpl<$Res,
        $Val extends CenterYouthcenterPaggingDto>
    implements $CenterYouthcenterPaggingDtoCopyWith<$Res> {
  _$CenterYouthcenterPaggingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totCount = freezed,
    Object? pageNum = freezed,
    Object? pageSize = freezed,
  }) {
    return _then(_value.copyWith(
      totCount: freezed == totCount
          ? _value.totCount
          : totCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pageNum: freezed == pageNum
          ? _value.pageNum
          : pageNum // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CenterYouthcenterPaggingDtoImplCopyWith<$Res>
    implements $CenterYouthcenterPaggingDtoCopyWith<$Res> {
  factory _$$CenterYouthcenterPaggingDtoImplCopyWith(
          _$CenterYouthcenterPaggingDtoImpl value,
          $Res Function(_$CenterYouthcenterPaggingDtoImpl) then) =
      __$$CenterYouthcenterPaggingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? totCount, int? pageNum, int? pageSize});
}

/// @nodoc
class __$$CenterYouthcenterPaggingDtoImplCopyWithImpl<$Res>
    extends _$CenterYouthcenterPaggingDtoCopyWithImpl<$Res,
        _$CenterYouthcenterPaggingDtoImpl>
    implements _$$CenterYouthcenterPaggingDtoImplCopyWith<$Res> {
  __$$CenterYouthcenterPaggingDtoImplCopyWithImpl(
      _$CenterYouthcenterPaggingDtoImpl _value,
      $Res Function(_$CenterYouthcenterPaggingDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totCount = freezed,
    Object? pageNum = freezed,
    Object? pageSize = freezed,
  }) {
    return _then(_$CenterYouthcenterPaggingDtoImpl(
      totCount: freezed == totCount
          ? _value.totCount
          : totCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pageNum: freezed == pageNum
          ? _value.pageNum
          : pageNum // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CenterYouthcenterPaggingDtoImpl
    implements _CenterYouthcenterPaggingDto {
  const _$CenterYouthcenterPaggingDtoImpl(
      {this.totCount, this.pageNum, this.pageSize});

  factory _$CenterYouthcenterPaggingDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CenterYouthcenterPaggingDtoImplFromJson(json);

  @override
  final int? totCount;
  @override
  final int? pageNum;
  @override
  final int? pageSize;

  @override
  String toString() {
    return 'CenterYouthcenterPaggingDto(totCount: $totCount, pageNum: $pageNum, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CenterYouthcenterPaggingDtoImpl &&
            (identical(other.totCount, totCount) ||
                other.totCount == totCount) &&
            (identical(other.pageNum, pageNum) || other.pageNum == pageNum) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totCount, pageNum, pageSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CenterYouthcenterPaggingDtoImplCopyWith<_$CenterYouthcenterPaggingDtoImpl>
      get copyWith => __$$CenterYouthcenterPaggingDtoImplCopyWithImpl<
          _$CenterYouthcenterPaggingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CenterYouthcenterPaggingDtoImplToJson(
      this,
    );
  }
}

abstract class _CenterYouthcenterPaggingDto
    implements CenterYouthcenterPaggingDto {
  const factory _CenterYouthcenterPaggingDto(
      {final int? totCount,
      final int? pageNum,
      final int? pageSize}) = _$CenterYouthcenterPaggingDtoImpl;

  factory _CenterYouthcenterPaggingDto.fromJson(Map<String, dynamic> json) =
      _$CenterYouthcenterPaggingDtoImpl.fromJson;

  @override
  int? get totCount;
  @override
  int? get pageNum;
  @override
  int? get pageSize;
  @override
  @JsonKey(ignore: true)
  _$$CenterYouthcenterPaggingDtoImplCopyWith<_$CenterYouthcenterPaggingDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CenterYouthcenterItemDto _$CenterYouthcenterItemDtoFromJson(
    Map<String, dynamic> json) {
  return _CenterYouthcenterItemDto.fromJson(json);
}

/// @nodoc
mixin _$CenterYouthcenterItemDto {
  String? get cntrSn => throw _privateConstructorUsedError;
  String? get cntrNm => throw _privateConstructorUsedError;
  String? get cntrAddr => throw _privateConstructorUsedError;
  String? get cntrDaddr => throw _privateConstructorUsedError;
  String? get cntrTelno => throw _privateConstructorUsedError;
  String? get cntrUrlAddr => throw _privateConstructorUsedError;
  String? get stdgCtpvCd => throw _privateConstructorUsedError;
  String? get stdgCtpvCdNm => throw _privateConstructorUsedError;
  String? get stdgSggCd => throw _privateConstructorUsedError;
  String? get stdgSggCdNm => throw _privateConstructorUsedError;
  double? get geocodedLat => throw _privateConstructorUsedError;
  double? get geocodedLng => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CenterYouthcenterItemDtoCopyWith<CenterYouthcenterItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CenterYouthcenterItemDtoCopyWith<$Res> {
  factory $CenterYouthcenterItemDtoCopyWith(CenterYouthcenterItemDto value,
          $Res Function(CenterYouthcenterItemDto) then) =
      _$CenterYouthcenterItemDtoCopyWithImpl<$Res, CenterYouthcenterItemDto>;
  @useResult
  $Res call(
      {String? cntrSn,
      String? cntrNm,
      String? cntrAddr,
      String? cntrDaddr,
      String? cntrTelno,
      String? cntrUrlAddr,
      String? stdgCtpvCd,
      String? stdgCtpvCdNm,
      String? stdgSggCd,
      String? stdgSggCdNm,
      double? geocodedLat,
      double? geocodedLng});
}

/// @nodoc
class _$CenterYouthcenterItemDtoCopyWithImpl<$Res,
        $Val extends CenterYouthcenterItemDto>
    implements $CenterYouthcenterItemDtoCopyWith<$Res> {
  _$CenterYouthcenterItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cntrSn = freezed,
    Object? cntrNm = freezed,
    Object? cntrAddr = freezed,
    Object? cntrDaddr = freezed,
    Object? cntrTelno = freezed,
    Object? cntrUrlAddr = freezed,
    Object? stdgCtpvCd = freezed,
    Object? stdgCtpvCdNm = freezed,
    Object? stdgSggCd = freezed,
    Object? stdgSggCdNm = freezed,
    Object? geocodedLat = freezed,
    Object? geocodedLng = freezed,
  }) {
    return _then(_value.copyWith(
      cntrSn: freezed == cntrSn
          ? _value.cntrSn
          : cntrSn // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrNm: freezed == cntrNm
          ? _value.cntrNm
          : cntrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrAddr: freezed == cntrAddr
          ? _value.cntrAddr
          : cntrAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrDaddr: freezed == cntrDaddr
          ? _value.cntrDaddr
          : cntrDaddr // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrTelno: freezed == cntrTelno
          ? _value.cntrTelno
          : cntrTelno // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrUrlAddr: freezed == cntrUrlAddr
          ? _value.cntrUrlAddr
          : cntrUrlAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgCtpvCd: freezed == stdgCtpvCd
          ? _value.stdgCtpvCd
          : stdgCtpvCd // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgCtpvCdNm: freezed == stdgCtpvCdNm
          ? _value.stdgCtpvCdNm
          : stdgCtpvCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgSggCd: freezed == stdgSggCd
          ? _value.stdgSggCd
          : stdgSggCd // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgSggCdNm: freezed == stdgSggCdNm
          ? _value.stdgSggCdNm
          : stdgSggCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      geocodedLat: freezed == geocodedLat
          ? _value.geocodedLat
          : geocodedLat // ignore: cast_nullable_to_non_nullable
              as double?,
      geocodedLng: freezed == geocodedLng
          ? _value.geocodedLng
          : geocodedLng // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CenterYouthcenterItemDtoImplCopyWith<$Res>
    implements $CenterYouthcenterItemDtoCopyWith<$Res> {
  factory _$$CenterYouthcenterItemDtoImplCopyWith(
          _$CenterYouthcenterItemDtoImpl value,
          $Res Function(_$CenterYouthcenterItemDtoImpl) then) =
      __$$CenterYouthcenterItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? cntrSn,
      String? cntrNm,
      String? cntrAddr,
      String? cntrDaddr,
      String? cntrTelno,
      String? cntrUrlAddr,
      String? stdgCtpvCd,
      String? stdgCtpvCdNm,
      String? stdgSggCd,
      String? stdgSggCdNm,
      double? geocodedLat,
      double? geocodedLng});
}

/// @nodoc
class __$$CenterYouthcenterItemDtoImplCopyWithImpl<$Res>
    extends _$CenterYouthcenterItemDtoCopyWithImpl<$Res,
        _$CenterYouthcenterItemDtoImpl>
    implements _$$CenterYouthcenterItemDtoImplCopyWith<$Res> {
  __$$CenterYouthcenterItemDtoImplCopyWithImpl(
      _$CenterYouthcenterItemDtoImpl _value,
      $Res Function(_$CenterYouthcenterItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cntrSn = freezed,
    Object? cntrNm = freezed,
    Object? cntrAddr = freezed,
    Object? cntrDaddr = freezed,
    Object? cntrTelno = freezed,
    Object? cntrUrlAddr = freezed,
    Object? stdgCtpvCd = freezed,
    Object? stdgCtpvCdNm = freezed,
    Object? stdgSggCd = freezed,
    Object? stdgSggCdNm = freezed,
    Object? geocodedLat = freezed,
    Object? geocodedLng = freezed,
  }) {
    return _then(_$CenterYouthcenterItemDtoImpl(
      cntrSn: freezed == cntrSn
          ? _value.cntrSn
          : cntrSn // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrNm: freezed == cntrNm
          ? _value.cntrNm
          : cntrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrAddr: freezed == cntrAddr
          ? _value.cntrAddr
          : cntrAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrDaddr: freezed == cntrDaddr
          ? _value.cntrDaddr
          : cntrDaddr // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrTelno: freezed == cntrTelno
          ? _value.cntrTelno
          : cntrTelno // ignore: cast_nullable_to_non_nullable
              as String?,
      cntrUrlAddr: freezed == cntrUrlAddr
          ? _value.cntrUrlAddr
          : cntrUrlAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgCtpvCd: freezed == stdgCtpvCd
          ? _value.stdgCtpvCd
          : stdgCtpvCd // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgCtpvCdNm: freezed == stdgCtpvCdNm
          ? _value.stdgCtpvCdNm
          : stdgCtpvCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgSggCd: freezed == stdgSggCd
          ? _value.stdgSggCd
          : stdgSggCd // ignore: cast_nullable_to_non_nullable
              as String?,
      stdgSggCdNm: freezed == stdgSggCdNm
          ? _value.stdgSggCdNm
          : stdgSggCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      geocodedLat: freezed == geocodedLat
          ? _value.geocodedLat
          : geocodedLat // ignore: cast_nullable_to_non_nullable
              as double?,
      geocodedLng: freezed == geocodedLng
          ? _value.geocodedLng
          : geocodedLng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CenterYouthcenterItemDtoImpl implements _CenterYouthcenterItemDto {
  const _$CenterYouthcenterItemDtoImpl(
      {this.cntrSn,
      this.cntrNm,
      this.cntrAddr,
      this.cntrDaddr,
      this.cntrTelno,
      this.cntrUrlAddr,
      this.stdgCtpvCd,
      this.stdgCtpvCdNm,
      this.stdgSggCd,
      this.stdgSggCdNm,
      this.geocodedLat,
      this.geocodedLng});

  factory _$CenterYouthcenterItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CenterYouthcenterItemDtoImplFromJson(json);

  @override
  final String? cntrSn;
  @override
  final String? cntrNm;
  @override
  final String? cntrAddr;
  @override
  final String? cntrDaddr;
  @override
  final String? cntrTelno;
  @override
  final String? cntrUrlAddr;
  @override
  final String? stdgCtpvCd;
  @override
  final String? stdgCtpvCdNm;
  @override
  final String? stdgSggCd;
  @override
  final String? stdgSggCdNm;
  @override
  final double? geocodedLat;
  @override
  final double? geocodedLng;

  @override
  String toString() {
    return 'CenterYouthcenterItemDto(cntrSn: $cntrSn, cntrNm: $cntrNm, cntrAddr: $cntrAddr, cntrDaddr: $cntrDaddr, cntrTelno: $cntrTelno, cntrUrlAddr: $cntrUrlAddr, stdgCtpvCd: $stdgCtpvCd, stdgCtpvCdNm: $stdgCtpvCdNm, stdgSggCd: $stdgSggCd, stdgSggCdNm: $stdgSggCdNm, geocodedLat: $geocodedLat, geocodedLng: $geocodedLng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CenterYouthcenterItemDtoImpl &&
            (identical(other.cntrSn, cntrSn) || other.cntrSn == cntrSn) &&
            (identical(other.cntrNm, cntrNm) || other.cntrNm == cntrNm) &&
            (identical(other.cntrAddr, cntrAddr) ||
                other.cntrAddr == cntrAddr) &&
            (identical(other.cntrDaddr, cntrDaddr) ||
                other.cntrDaddr == cntrDaddr) &&
            (identical(other.cntrTelno, cntrTelno) ||
                other.cntrTelno == cntrTelno) &&
            (identical(other.cntrUrlAddr, cntrUrlAddr) ||
                other.cntrUrlAddr == cntrUrlAddr) &&
            (identical(other.stdgCtpvCd, stdgCtpvCd) ||
                other.stdgCtpvCd == stdgCtpvCd) &&
            (identical(other.stdgCtpvCdNm, stdgCtpvCdNm) ||
                other.stdgCtpvCdNm == stdgCtpvCdNm) &&
            (identical(other.stdgSggCd, stdgSggCd) ||
                other.stdgSggCd == stdgSggCd) &&
            (identical(other.stdgSggCdNm, stdgSggCdNm) ||
                other.stdgSggCdNm == stdgSggCdNm) &&
            (identical(other.geocodedLat, geocodedLat) ||
                other.geocodedLat == geocodedLat) &&
            (identical(other.geocodedLng, geocodedLng) ||
                other.geocodedLng == geocodedLng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cntrSn,
      cntrNm,
      cntrAddr,
      cntrDaddr,
      cntrTelno,
      cntrUrlAddr,
      stdgCtpvCd,
      stdgCtpvCdNm,
      stdgSggCd,
      stdgSggCdNm,
      geocodedLat,
      geocodedLng);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CenterYouthcenterItemDtoImplCopyWith<_$CenterYouthcenterItemDtoImpl>
      get copyWith => __$$CenterYouthcenterItemDtoImplCopyWithImpl<
          _$CenterYouthcenterItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CenterYouthcenterItemDtoImplToJson(
      this,
    );
  }
}

abstract class _CenterYouthcenterItemDto implements CenterYouthcenterItemDto {
  const factory _CenterYouthcenterItemDto(
      {final String? cntrSn,
      final String? cntrNm,
      final String? cntrAddr,
      final String? cntrDaddr,
      final String? cntrTelno,
      final String? cntrUrlAddr,
      final String? stdgCtpvCd,
      final String? stdgCtpvCdNm,
      final String? stdgSggCd,
      final String? stdgSggCdNm,
      final double? geocodedLat,
      final double? geocodedLng}) = _$CenterYouthcenterItemDtoImpl;

  factory _CenterYouthcenterItemDto.fromJson(Map<String, dynamic> json) =
      _$CenterYouthcenterItemDtoImpl.fromJson;

  @override
  String? get cntrSn;
  @override
  String? get cntrNm;
  @override
  String? get cntrAddr;
  @override
  String? get cntrDaddr;
  @override
  String? get cntrTelno;
  @override
  String? get cntrUrlAddr;
  @override
  String? get stdgCtpvCd;
  @override
  String? get stdgCtpvCdNm;
  @override
  String? get stdgSggCd;
  @override
  String? get stdgSggCdNm;
  @override
  double? get geocodedLat;
  @override
  double? get geocodedLng;
  @override
  @JsonKey(ignore: true)
  _$$CenterYouthcenterItemDtoImplCopyWith<_$CenterYouthcenterItemDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
