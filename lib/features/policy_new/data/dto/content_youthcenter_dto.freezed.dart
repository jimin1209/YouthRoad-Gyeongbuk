// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_youthcenter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentYouthcenterDto _$ContentYouthcenterDtoFromJson(
    Map<String, dynamic> json) {
  return _ContentYouthcenterDto.fromJson(json);
}

/// @nodoc
mixin _$ContentYouthcenterDto {
  int? get resultCode => throw _privateConstructorUsedError;
  String? get resultMessage => throw _privateConstructorUsedError;
  ContentYouthcenterResultDto? get result => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentYouthcenterDtoCopyWith<ContentYouthcenterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentYouthcenterDtoCopyWith<$Res> {
  factory $ContentYouthcenterDtoCopyWith(ContentYouthcenterDto value,
          $Res Function(ContentYouthcenterDto) then) =
      _$ContentYouthcenterDtoCopyWithImpl<$Res, ContentYouthcenterDto>;
  @useResult
  $Res call(
      {int? resultCode,
      String? resultMessage,
      ContentYouthcenterResultDto? result});

  $ContentYouthcenterResultDtoCopyWith<$Res>? get result;
}

/// @nodoc
class _$ContentYouthcenterDtoCopyWithImpl<$Res,
        $Val extends ContentYouthcenterDto>
    implements $ContentYouthcenterDtoCopyWith<$Res> {
  _$ContentYouthcenterDtoCopyWithImpl(this._value, this._then);

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
              as ContentYouthcenterResultDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContentYouthcenterResultDtoCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $ContentYouthcenterResultDtoCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContentYouthcenterDtoImplCopyWith<$Res>
    implements $ContentYouthcenterDtoCopyWith<$Res> {
  factory _$$ContentYouthcenterDtoImplCopyWith(
          _$ContentYouthcenterDtoImpl value,
          $Res Function(_$ContentYouthcenterDtoImpl) then) =
      __$$ContentYouthcenterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? resultCode,
      String? resultMessage,
      ContentYouthcenterResultDto? result});

  @override
  $ContentYouthcenterResultDtoCopyWith<$Res>? get result;
}

/// @nodoc
class __$$ContentYouthcenterDtoImplCopyWithImpl<$Res>
    extends _$ContentYouthcenterDtoCopyWithImpl<$Res,
        _$ContentYouthcenterDtoImpl>
    implements _$$ContentYouthcenterDtoImplCopyWith<$Res> {
  __$$ContentYouthcenterDtoImplCopyWithImpl(_$ContentYouthcenterDtoImpl _value,
      $Res Function(_$ContentYouthcenterDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultCode = freezed,
    Object? resultMessage = freezed,
    Object? result = freezed,
  }) {
    return _then(_$ContentYouthcenterDtoImpl(
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
              as ContentYouthcenterResultDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentYouthcenterDtoImpl implements _ContentYouthcenterDto {
  const _$ContentYouthcenterDtoImpl(
      {this.resultCode, this.resultMessage, this.result});

  factory _$ContentYouthcenterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentYouthcenterDtoImplFromJson(json);

  @override
  final int? resultCode;
  @override
  final String? resultMessage;
  @override
  final ContentYouthcenterResultDto? result;

  @override
  String toString() {
    return 'ContentYouthcenterDto(resultCode: $resultCode, resultMessage: $resultMessage, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentYouthcenterDtoImpl &&
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
  _$$ContentYouthcenterDtoImplCopyWith<_$ContentYouthcenterDtoImpl>
      get copyWith => __$$ContentYouthcenterDtoImplCopyWithImpl<
          _$ContentYouthcenterDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentYouthcenterDtoImplToJson(
      this,
    );
  }
}

abstract class _ContentYouthcenterDto implements ContentYouthcenterDto {
  const factory _ContentYouthcenterDto(
      {final int? resultCode,
      final String? resultMessage,
      final ContentYouthcenterResultDto? result}) = _$ContentYouthcenterDtoImpl;

  factory _ContentYouthcenterDto.fromJson(Map<String, dynamic> json) =
      _$ContentYouthcenterDtoImpl.fromJson;

  @override
  int? get resultCode;
  @override
  String? get resultMessage;
  @override
  ContentYouthcenterResultDto? get result;
  @override
  @JsonKey(ignore: true)
  _$$ContentYouthcenterDtoImplCopyWith<_$ContentYouthcenterDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContentYouthcenterResultDto _$ContentYouthcenterResultDtoFromJson(
    Map<String, dynamic> json) {
  return _ContentYouthcenterResultDto.fromJson(json);
}

/// @nodoc
mixin _$ContentYouthcenterResultDto {
  ContentYouthcenterPaggingDto? get pagging =>
      throw _privateConstructorUsedError;
  List<ContentYouthcenterItemDto>? get youthPolicyList =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentYouthcenterResultDtoCopyWith<ContentYouthcenterResultDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentYouthcenterResultDtoCopyWith<$Res> {
  factory $ContentYouthcenterResultDtoCopyWith(
          ContentYouthcenterResultDto value,
          $Res Function(ContentYouthcenterResultDto) then) =
      _$ContentYouthcenterResultDtoCopyWithImpl<$Res,
          ContentYouthcenterResultDto>;
  @useResult
  $Res call(
      {ContentYouthcenterPaggingDto? pagging,
      List<ContentYouthcenterItemDto>? youthPolicyList});

  $ContentYouthcenterPaggingDtoCopyWith<$Res>? get pagging;
}

/// @nodoc
class _$ContentYouthcenterResultDtoCopyWithImpl<$Res,
        $Val extends ContentYouthcenterResultDto>
    implements $ContentYouthcenterResultDtoCopyWith<$Res> {
  _$ContentYouthcenterResultDtoCopyWithImpl(this._value, this._then);

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
              as ContentYouthcenterPaggingDto?,
      youthPolicyList: freezed == youthPolicyList
          ? _value.youthPolicyList
          : youthPolicyList // ignore: cast_nullable_to_non_nullable
              as List<ContentYouthcenterItemDto>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContentYouthcenterPaggingDtoCopyWith<$Res>? get pagging {
    if (_value.pagging == null) {
      return null;
    }

    return $ContentYouthcenterPaggingDtoCopyWith<$Res>(_value.pagging!,
        (value) {
      return _then(_value.copyWith(pagging: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContentYouthcenterResultDtoImplCopyWith<$Res>
    implements $ContentYouthcenterResultDtoCopyWith<$Res> {
  factory _$$ContentYouthcenterResultDtoImplCopyWith(
          _$ContentYouthcenterResultDtoImpl value,
          $Res Function(_$ContentYouthcenterResultDtoImpl) then) =
      __$$ContentYouthcenterResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ContentYouthcenterPaggingDto? pagging,
      List<ContentYouthcenterItemDto>? youthPolicyList});

  @override
  $ContentYouthcenterPaggingDtoCopyWith<$Res>? get pagging;
}

/// @nodoc
class __$$ContentYouthcenterResultDtoImplCopyWithImpl<$Res>
    extends _$ContentYouthcenterResultDtoCopyWithImpl<$Res,
        _$ContentYouthcenterResultDtoImpl>
    implements _$$ContentYouthcenterResultDtoImplCopyWith<$Res> {
  __$$ContentYouthcenterResultDtoImplCopyWithImpl(
      _$ContentYouthcenterResultDtoImpl _value,
      $Res Function(_$ContentYouthcenterResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagging = freezed,
    Object? youthPolicyList = freezed,
  }) {
    return _then(_$ContentYouthcenterResultDtoImpl(
      pagging: freezed == pagging
          ? _value.pagging
          : pagging // ignore: cast_nullable_to_non_nullable
              as ContentYouthcenterPaggingDto?,
      youthPolicyList: freezed == youthPolicyList
          ? _value._youthPolicyList
          : youthPolicyList // ignore: cast_nullable_to_non_nullable
              as List<ContentYouthcenterItemDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentYouthcenterResultDtoImpl
    implements _ContentYouthcenterResultDto {
  const _$ContentYouthcenterResultDtoImpl(
      {this.pagging, final List<ContentYouthcenterItemDto>? youthPolicyList})
      : _youthPolicyList = youthPolicyList;

  factory _$ContentYouthcenterResultDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ContentYouthcenterResultDtoImplFromJson(json);

  @override
  final ContentYouthcenterPaggingDto? pagging;
  final List<ContentYouthcenterItemDto>? _youthPolicyList;
  @override
  List<ContentYouthcenterItemDto>? get youthPolicyList {
    final value = _youthPolicyList;
    if (value == null) return null;
    if (_youthPolicyList is EqualUnmodifiableListView) return _youthPolicyList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ContentYouthcenterResultDto(pagging: $pagging, youthPolicyList: $youthPolicyList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentYouthcenterResultDtoImpl &&
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
  _$$ContentYouthcenterResultDtoImplCopyWith<_$ContentYouthcenterResultDtoImpl>
      get copyWith => __$$ContentYouthcenterResultDtoImplCopyWithImpl<
          _$ContentYouthcenterResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentYouthcenterResultDtoImplToJson(
      this,
    );
  }
}

abstract class _ContentYouthcenterResultDto
    implements ContentYouthcenterResultDto {
  const factory _ContentYouthcenterResultDto(
          {final ContentYouthcenterPaggingDto? pagging,
          final List<ContentYouthcenterItemDto>? youthPolicyList}) =
      _$ContentYouthcenterResultDtoImpl;

  factory _ContentYouthcenterResultDto.fromJson(Map<String, dynamic> json) =
      _$ContentYouthcenterResultDtoImpl.fromJson;

  @override
  ContentYouthcenterPaggingDto? get pagging;
  @override
  List<ContentYouthcenterItemDto>? get youthPolicyList;
  @override
  @JsonKey(ignore: true)
  _$$ContentYouthcenterResultDtoImplCopyWith<_$ContentYouthcenterResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContentYouthcenterPaggingDto _$ContentYouthcenterPaggingDtoFromJson(
    Map<String, dynamic> json) {
  return _ContentYouthcenterPaggingDto.fromJson(json);
}

/// @nodoc
mixin _$ContentYouthcenterPaggingDto {
  int? get totCount => throw _privateConstructorUsedError;
  int? get pageNum => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentYouthcenterPaggingDtoCopyWith<ContentYouthcenterPaggingDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentYouthcenterPaggingDtoCopyWith<$Res> {
  factory $ContentYouthcenterPaggingDtoCopyWith(
          ContentYouthcenterPaggingDto value,
          $Res Function(ContentYouthcenterPaggingDto) then) =
      _$ContentYouthcenterPaggingDtoCopyWithImpl<$Res,
          ContentYouthcenterPaggingDto>;
  @useResult
  $Res call({int? totCount, int? pageNum, int? pageSize});
}

/// @nodoc
class _$ContentYouthcenterPaggingDtoCopyWithImpl<$Res,
        $Val extends ContentYouthcenterPaggingDto>
    implements $ContentYouthcenterPaggingDtoCopyWith<$Res> {
  _$ContentYouthcenterPaggingDtoCopyWithImpl(this._value, this._then);

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
abstract class _$$ContentYouthcenterPaggingDtoImplCopyWith<$Res>
    implements $ContentYouthcenterPaggingDtoCopyWith<$Res> {
  factory _$$ContentYouthcenterPaggingDtoImplCopyWith(
          _$ContentYouthcenterPaggingDtoImpl value,
          $Res Function(_$ContentYouthcenterPaggingDtoImpl) then) =
      __$$ContentYouthcenterPaggingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? totCount, int? pageNum, int? pageSize});
}

/// @nodoc
class __$$ContentYouthcenterPaggingDtoImplCopyWithImpl<$Res>
    extends _$ContentYouthcenterPaggingDtoCopyWithImpl<$Res,
        _$ContentYouthcenterPaggingDtoImpl>
    implements _$$ContentYouthcenterPaggingDtoImplCopyWith<$Res> {
  __$$ContentYouthcenterPaggingDtoImplCopyWithImpl(
      _$ContentYouthcenterPaggingDtoImpl _value,
      $Res Function(_$ContentYouthcenterPaggingDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totCount = freezed,
    Object? pageNum = freezed,
    Object? pageSize = freezed,
  }) {
    return _then(_$ContentYouthcenterPaggingDtoImpl(
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
class _$ContentYouthcenterPaggingDtoImpl
    implements _ContentYouthcenterPaggingDto {
  const _$ContentYouthcenterPaggingDtoImpl(
      {this.totCount, this.pageNum, this.pageSize});

  factory _$ContentYouthcenterPaggingDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ContentYouthcenterPaggingDtoImplFromJson(json);

  @override
  final int? totCount;
  @override
  final int? pageNum;
  @override
  final int? pageSize;

  @override
  String toString() {
    return 'ContentYouthcenterPaggingDto(totCount: $totCount, pageNum: $pageNum, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentYouthcenterPaggingDtoImpl &&
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
  _$$ContentYouthcenterPaggingDtoImplCopyWith<
          _$ContentYouthcenterPaggingDtoImpl>
      get copyWith => __$$ContentYouthcenterPaggingDtoImplCopyWithImpl<
          _$ContentYouthcenterPaggingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentYouthcenterPaggingDtoImplToJson(
      this,
    );
  }
}

abstract class _ContentYouthcenterPaggingDto
    implements ContentYouthcenterPaggingDto {
  const factory _ContentYouthcenterPaggingDto(
      {final int? totCount,
      final int? pageNum,
      final int? pageSize}) = _$ContentYouthcenterPaggingDtoImpl;

  factory _ContentYouthcenterPaggingDto.fromJson(Map<String, dynamic> json) =
      _$ContentYouthcenterPaggingDtoImpl.fromJson;

  @override
  int? get totCount;
  @override
  int? get pageNum;
  @override
  int? get pageSize;
  @override
  @JsonKey(ignore: true)
  _$$ContentYouthcenterPaggingDtoImplCopyWith<
          _$ContentYouthcenterPaggingDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContentYouthcenterItemDto _$ContentYouthcenterItemDtoFromJson(
    Map<String, dynamic> json) {
  return _ContentYouthcenterItemDto.fromJson(json);
}

/// @nodoc
mixin _$ContentYouthcenterItemDto {
  String? get bbsSn => throw _privateConstructorUsedError;
  String? get pstSn => throw _privateConstructorUsedError;
  String? get pstSeSn => throw _privateConstructorUsedError;
  String? get pstSeNm => throw _privateConstructorUsedError;
  String? get pstTtl => throw _privateConstructorUsedError;
  String? get pstWholCn => throw _privateConstructorUsedError;
  String? get pstUrlAddr => throw _privateConstructorUsedError;
  String? get atchFile => throw _privateConstructorUsedError;
  String? get pstInqCnt => throw _privateConstructorUsedError;
  String? get frstRegDt => throw _privateConstructorUsedError;
  String? get frstRgtrNm => throw _privateConstructorUsedError;
  String? get lastMdfcnDt => throw _privateConstructorUsedError;
  String? get lastMdfrNm => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentYouthcenterItemDtoCopyWith<ContentYouthcenterItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentYouthcenterItemDtoCopyWith<$Res> {
  factory $ContentYouthcenterItemDtoCopyWith(ContentYouthcenterItemDto value,
          $Res Function(ContentYouthcenterItemDto) then) =
      _$ContentYouthcenterItemDtoCopyWithImpl<$Res, ContentYouthcenterItemDto>;
  @useResult
  $Res call(
      {String? bbsSn,
      String? pstSn,
      String? pstSeSn,
      String? pstSeNm,
      String? pstTtl,
      String? pstWholCn,
      String? pstUrlAddr,
      String? atchFile,
      String? pstInqCnt,
      String? frstRegDt,
      String? frstRgtrNm,
      String? lastMdfcnDt,
      String? lastMdfrNm});
}

/// @nodoc
class _$ContentYouthcenterItemDtoCopyWithImpl<$Res,
        $Val extends ContentYouthcenterItemDto>
    implements $ContentYouthcenterItemDtoCopyWith<$Res> {
  _$ContentYouthcenterItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbsSn = freezed,
    Object? pstSn = freezed,
    Object? pstSeSn = freezed,
    Object? pstSeNm = freezed,
    Object? pstTtl = freezed,
    Object? pstWholCn = freezed,
    Object? pstUrlAddr = freezed,
    Object? atchFile = freezed,
    Object? pstInqCnt = freezed,
    Object? frstRegDt = freezed,
    Object? frstRgtrNm = freezed,
    Object? lastMdfcnDt = freezed,
    Object? lastMdfrNm = freezed,
  }) {
    return _then(_value.copyWith(
      bbsSn: freezed == bbsSn
          ? _value.bbsSn
          : bbsSn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstSn: freezed == pstSn
          ? _value.pstSn
          : pstSn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstSeSn: freezed == pstSeSn
          ? _value.pstSeSn
          : pstSeSn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstSeNm: freezed == pstSeNm
          ? _value.pstSeNm
          : pstSeNm // ignore: cast_nullable_to_non_nullable
              as String?,
      pstTtl: freezed == pstTtl
          ? _value.pstTtl
          : pstTtl // ignore: cast_nullable_to_non_nullable
              as String?,
      pstWholCn: freezed == pstWholCn
          ? _value.pstWholCn
          : pstWholCn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstUrlAddr: freezed == pstUrlAddr
          ? _value.pstUrlAddr
          : pstUrlAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      atchFile: freezed == atchFile
          ? _value.atchFile
          : atchFile // ignore: cast_nullable_to_non_nullable
              as String?,
      pstInqCnt: freezed == pstInqCnt
          ? _value.pstInqCnt
          : pstInqCnt // ignore: cast_nullable_to_non_nullable
              as String?,
      frstRegDt: freezed == frstRegDt
          ? _value.frstRegDt
          : frstRegDt // ignore: cast_nullable_to_non_nullable
              as String?,
      frstRgtrNm: freezed == frstRgtrNm
          ? _value.frstRgtrNm
          : frstRgtrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMdfcnDt: freezed == lastMdfcnDt
          ? _value.lastMdfcnDt
          : lastMdfcnDt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMdfrNm: freezed == lastMdfrNm
          ? _value.lastMdfrNm
          : lastMdfrNm // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentYouthcenterItemDtoImplCopyWith<$Res>
    implements $ContentYouthcenterItemDtoCopyWith<$Res> {
  factory _$$ContentYouthcenterItemDtoImplCopyWith(
          _$ContentYouthcenterItemDtoImpl value,
          $Res Function(_$ContentYouthcenterItemDtoImpl) then) =
      __$$ContentYouthcenterItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? bbsSn,
      String? pstSn,
      String? pstSeSn,
      String? pstSeNm,
      String? pstTtl,
      String? pstWholCn,
      String? pstUrlAddr,
      String? atchFile,
      String? pstInqCnt,
      String? frstRegDt,
      String? frstRgtrNm,
      String? lastMdfcnDt,
      String? lastMdfrNm});
}

/// @nodoc
class __$$ContentYouthcenterItemDtoImplCopyWithImpl<$Res>
    extends _$ContentYouthcenterItemDtoCopyWithImpl<$Res,
        _$ContentYouthcenterItemDtoImpl>
    implements _$$ContentYouthcenterItemDtoImplCopyWith<$Res> {
  __$$ContentYouthcenterItemDtoImplCopyWithImpl(
      _$ContentYouthcenterItemDtoImpl _value,
      $Res Function(_$ContentYouthcenterItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbsSn = freezed,
    Object? pstSn = freezed,
    Object? pstSeSn = freezed,
    Object? pstSeNm = freezed,
    Object? pstTtl = freezed,
    Object? pstWholCn = freezed,
    Object? pstUrlAddr = freezed,
    Object? atchFile = freezed,
    Object? pstInqCnt = freezed,
    Object? frstRegDt = freezed,
    Object? frstRgtrNm = freezed,
    Object? lastMdfcnDt = freezed,
    Object? lastMdfrNm = freezed,
  }) {
    return _then(_$ContentYouthcenterItemDtoImpl(
      bbsSn: freezed == bbsSn
          ? _value.bbsSn
          : bbsSn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstSn: freezed == pstSn
          ? _value.pstSn
          : pstSn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstSeSn: freezed == pstSeSn
          ? _value.pstSeSn
          : pstSeSn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstSeNm: freezed == pstSeNm
          ? _value.pstSeNm
          : pstSeNm // ignore: cast_nullable_to_non_nullable
              as String?,
      pstTtl: freezed == pstTtl
          ? _value.pstTtl
          : pstTtl // ignore: cast_nullable_to_non_nullable
              as String?,
      pstWholCn: freezed == pstWholCn
          ? _value.pstWholCn
          : pstWholCn // ignore: cast_nullable_to_non_nullable
              as String?,
      pstUrlAddr: freezed == pstUrlAddr
          ? _value.pstUrlAddr
          : pstUrlAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      atchFile: freezed == atchFile
          ? _value.atchFile
          : atchFile // ignore: cast_nullable_to_non_nullable
              as String?,
      pstInqCnt: freezed == pstInqCnt
          ? _value.pstInqCnt
          : pstInqCnt // ignore: cast_nullable_to_non_nullable
              as String?,
      frstRegDt: freezed == frstRegDt
          ? _value.frstRegDt
          : frstRegDt // ignore: cast_nullable_to_non_nullable
              as String?,
      frstRgtrNm: freezed == frstRgtrNm
          ? _value.frstRgtrNm
          : frstRgtrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMdfcnDt: freezed == lastMdfcnDt
          ? _value.lastMdfcnDt
          : lastMdfcnDt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMdfrNm: freezed == lastMdfrNm
          ? _value.lastMdfrNm
          : lastMdfrNm // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentYouthcenterItemDtoImpl implements _ContentYouthcenterItemDto {
  const _$ContentYouthcenterItemDtoImpl(
      {this.bbsSn,
      this.pstSn,
      this.pstSeSn,
      this.pstSeNm,
      this.pstTtl,
      this.pstWholCn,
      this.pstUrlAddr,
      this.atchFile,
      this.pstInqCnt,
      this.frstRegDt,
      this.frstRgtrNm,
      this.lastMdfcnDt,
      this.lastMdfrNm});

  factory _$ContentYouthcenterItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentYouthcenterItemDtoImplFromJson(json);

  @override
  final String? bbsSn;
  @override
  final String? pstSn;
  @override
  final String? pstSeSn;
  @override
  final String? pstSeNm;
  @override
  final String? pstTtl;
  @override
  final String? pstWholCn;
  @override
  final String? pstUrlAddr;
  @override
  final String? atchFile;
  @override
  final String? pstInqCnt;
  @override
  final String? frstRegDt;
  @override
  final String? frstRgtrNm;
  @override
  final String? lastMdfcnDt;
  @override
  final String? lastMdfrNm;

  @override
  String toString() {
    return 'ContentYouthcenterItemDto(bbsSn: $bbsSn, pstSn: $pstSn, pstSeSn: $pstSeSn, pstSeNm: $pstSeNm, pstTtl: $pstTtl, pstWholCn: $pstWholCn, pstUrlAddr: $pstUrlAddr, atchFile: $atchFile, pstInqCnt: $pstInqCnt, frstRegDt: $frstRegDt, frstRgtrNm: $frstRgtrNm, lastMdfcnDt: $lastMdfcnDt, lastMdfrNm: $lastMdfrNm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentYouthcenterItemDtoImpl &&
            (identical(other.bbsSn, bbsSn) || other.bbsSn == bbsSn) &&
            (identical(other.pstSn, pstSn) || other.pstSn == pstSn) &&
            (identical(other.pstSeSn, pstSeSn) || other.pstSeSn == pstSeSn) &&
            (identical(other.pstSeNm, pstSeNm) || other.pstSeNm == pstSeNm) &&
            (identical(other.pstTtl, pstTtl) || other.pstTtl == pstTtl) &&
            (identical(other.pstWholCn, pstWholCn) ||
                other.pstWholCn == pstWholCn) &&
            (identical(other.pstUrlAddr, pstUrlAddr) ||
                other.pstUrlAddr == pstUrlAddr) &&
            (identical(other.atchFile, atchFile) ||
                other.atchFile == atchFile) &&
            (identical(other.pstInqCnt, pstInqCnt) ||
                other.pstInqCnt == pstInqCnt) &&
            (identical(other.frstRegDt, frstRegDt) ||
                other.frstRegDt == frstRegDt) &&
            (identical(other.frstRgtrNm, frstRgtrNm) ||
                other.frstRgtrNm == frstRgtrNm) &&
            (identical(other.lastMdfcnDt, lastMdfcnDt) ||
                other.lastMdfcnDt == lastMdfcnDt) &&
            (identical(other.lastMdfrNm, lastMdfrNm) ||
                other.lastMdfrNm == lastMdfrNm));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bbsSn,
      pstSn,
      pstSeSn,
      pstSeNm,
      pstTtl,
      pstWholCn,
      pstUrlAddr,
      atchFile,
      pstInqCnt,
      frstRegDt,
      frstRgtrNm,
      lastMdfcnDt,
      lastMdfrNm);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentYouthcenterItemDtoImplCopyWith<_$ContentYouthcenterItemDtoImpl>
      get copyWith => __$$ContentYouthcenterItemDtoImplCopyWithImpl<
          _$ContentYouthcenterItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentYouthcenterItemDtoImplToJson(
      this,
    );
  }
}

abstract class _ContentYouthcenterItemDto implements ContentYouthcenterItemDto {
  const factory _ContentYouthcenterItemDto(
      {final String? bbsSn,
      final String? pstSn,
      final String? pstSeSn,
      final String? pstSeNm,
      final String? pstTtl,
      final String? pstWholCn,
      final String? pstUrlAddr,
      final String? atchFile,
      final String? pstInqCnt,
      final String? frstRegDt,
      final String? frstRgtrNm,
      final String? lastMdfcnDt,
      final String? lastMdfrNm}) = _$ContentYouthcenterItemDtoImpl;

  factory _ContentYouthcenterItemDto.fromJson(Map<String, dynamic> json) =
      _$ContentYouthcenterItemDtoImpl.fromJson;

  @override
  String? get bbsSn;
  @override
  String? get pstSn;
  @override
  String? get pstSeSn;
  @override
  String? get pstSeNm;
  @override
  String? get pstTtl;
  @override
  String? get pstWholCn;
  @override
  String? get pstUrlAddr;
  @override
  String? get atchFile;
  @override
  String? get pstInqCnt;
  @override
  String? get frstRegDt;
  @override
  String? get frstRgtrNm;
  @override
  String? get lastMdfcnDt;
  @override
  String? get lastMdfrNm;
  @override
  @JsonKey(ignore: true)
  _$$ContentYouthcenterItemDtoImplCopyWith<_$ContentYouthcenterItemDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
