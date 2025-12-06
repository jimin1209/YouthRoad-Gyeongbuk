// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'policy_youthcenter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PolicyYouthcenterDto _$PolicyYouthcenterDtoFromJson(Map<String, dynamic> json) {
  return _PolicyYouthcenterDto.fromJson(json);
}

/// @nodoc
mixin _$PolicyYouthcenterDto {
  int? get resultCode => throw _privateConstructorUsedError;
  String? get resultMessage => throw _privateConstructorUsedError;
  PolicyYouthcenterResultDto? get result => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PolicyYouthcenterDtoCopyWith<PolicyYouthcenterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyYouthcenterDtoCopyWith<$Res> {
  factory $PolicyYouthcenterDtoCopyWith(PolicyYouthcenterDto value,
          $Res Function(PolicyYouthcenterDto) then) =
      _$PolicyYouthcenterDtoCopyWithImpl<$Res, PolicyYouthcenterDto>;
  @useResult
  $Res call(
      {int? resultCode,
      String? resultMessage,
      PolicyYouthcenterResultDto? result});

  $PolicyYouthcenterResultDtoCopyWith<$Res>? get result;
}

/// @nodoc
class _$PolicyYouthcenterDtoCopyWithImpl<$Res,
        $Val extends PolicyYouthcenterDto>
    implements $PolicyYouthcenterDtoCopyWith<$Res> {
  _$PolicyYouthcenterDtoCopyWithImpl(this._value, this._then);

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
              as PolicyYouthcenterResultDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PolicyYouthcenterResultDtoCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $PolicyYouthcenterResultDtoCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PolicyYouthcenterDtoImplCopyWith<$Res>
    implements $PolicyYouthcenterDtoCopyWith<$Res> {
  factory _$$PolicyYouthcenterDtoImplCopyWith(_$PolicyYouthcenterDtoImpl value,
          $Res Function(_$PolicyYouthcenterDtoImpl) then) =
      __$$PolicyYouthcenterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? resultCode,
      String? resultMessage,
      PolicyYouthcenterResultDto? result});

  @override
  $PolicyYouthcenterResultDtoCopyWith<$Res>? get result;
}

/// @nodoc
class __$$PolicyYouthcenterDtoImplCopyWithImpl<$Res>
    extends _$PolicyYouthcenterDtoCopyWithImpl<$Res, _$PolicyYouthcenterDtoImpl>
    implements _$$PolicyYouthcenterDtoImplCopyWith<$Res> {
  __$$PolicyYouthcenterDtoImplCopyWithImpl(_$PolicyYouthcenterDtoImpl _value,
      $Res Function(_$PolicyYouthcenterDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultCode = freezed,
    Object? resultMessage = freezed,
    Object? result = freezed,
  }) {
    return _then(_$PolicyYouthcenterDtoImpl(
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
              as PolicyYouthcenterResultDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyYouthcenterDtoImpl implements _PolicyYouthcenterDto {
  const _$PolicyYouthcenterDtoImpl(
      {this.resultCode, this.resultMessage, this.result});

  factory _$PolicyYouthcenterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyYouthcenterDtoImplFromJson(json);

  @override
  final int? resultCode;
  @override
  final String? resultMessage;
  @override
  final PolicyYouthcenterResultDto? result;

  @override
  String toString() {
    return 'PolicyYouthcenterDto(resultCode: $resultCode, resultMessage: $resultMessage, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyYouthcenterDtoImpl &&
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
  _$$PolicyYouthcenterDtoImplCopyWith<_$PolicyYouthcenterDtoImpl>
      get copyWith =>
          __$$PolicyYouthcenterDtoImplCopyWithImpl<_$PolicyYouthcenterDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicyYouthcenterDtoImplToJson(
      this,
    );
  }
}

abstract class _PolicyYouthcenterDto implements PolicyYouthcenterDto {
  const factory _PolicyYouthcenterDto(
      {final int? resultCode,
      final String? resultMessage,
      final PolicyYouthcenterResultDto? result}) = _$PolicyYouthcenterDtoImpl;

  factory _PolicyYouthcenterDto.fromJson(Map<String, dynamic> json) =
      _$PolicyYouthcenterDtoImpl.fromJson;

  @override
  int? get resultCode;
  @override
  String? get resultMessage;
  @override
  PolicyYouthcenterResultDto? get result;
  @override
  @JsonKey(ignore: true)
  _$$PolicyYouthcenterDtoImplCopyWith<_$PolicyYouthcenterDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PolicyYouthcenterResultDto _$PolicyYouthcenterResultDtoFromJson(
    Map<String, dynamic> json) {
  return _PolicyYouthcenterResultDto.fromJson(json);
}

/// @nodoc
mixin _$PolicyYouthcenterResultDto {
  PolicyYouthcenterPaggingDto? get pagging =>
      throw _privateConstructorUsedError;
  List<PolicyYouthcenterItemDto>? get youthPolicyList =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PolicyYouthcenterResultDtoCopyWith<PolicyYouthcenterResultDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyYouthcenterResultDtoCopyWith<$Res> {
  factory $PolicyYouthcenterResultDtoCopyWith(PolicyYouthcenterResultDto value,
          $Res Function(PolicyYouthcenterResultDto) then) =
      _$PolicyYouthcenterResultDtoCopyWithImpl<$Res,
          PolicyYouthcenterResultDto>;
  @useResult
  $Res call(
      {PolicyYouthcenterPaggingDto? pagging,
      List<PolicyYouthcenterItemDto>? youthPolicyList});

  $PolicyYouthcenterPaggingDtoCopyWith<$Res>? get pagging;
}

/// @nodoc
class _$PolicyYouthcenterResultDtoCopyWithImpl<$Res,
        $Val extends PolicyYouthcenterResultDto>
    implements $PolicyYouthcenterResultDtoCopyWith<$Res> {
  _$PolicyYouthcenterResultDtoCopyWithImpl(this._value, this._then);

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
              as PolicyYouthcenterPaggingDto?,
      youthPolicyList: freezed == youthPolicyList
          ? _value.youthPolicyList
          : youthPolicyList // ignore: cast_nullable_to_non_nullable
              as List<PolicyYouthcenterItemDto>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PolicyYouthcenterPaggingDtoCopyWith<$Res>? get pagging {
    if (_value.pagging == null) {
      return null;
    }

    return $PolicyYouthcenterPaggingDtoCopyWith<$Res>(_value.pagging!, (value) {
      return _then(_value.copyWith(pagging: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PolicyYouthcenterResultDtoImplCopyWith<$Res>
    implements $PolicyYouthcenterResultDtoCopyWith<$Res> {
  factory _$$PolicyYouthcenterResultDtoImplCopyWith(
          _$PolicyYouthcenterResultDtoImpl value,
          $Res Function(_$PolicyYouthcenterResultDtoImpl) then) =
      __$$PolicyYouthcenterResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PolicyYouthcenterPaggingDto? pagging,
      List<PolicyYouthcenterItemDto>? youthPolicyList});

  @override
  $PolicyYouthcenterPaggingDtoCopyWith<$Res>? get pagging;
}

/// @nodoc
class __$$PolicyYouthcenterResultDtoImplCopyWithImpl<$Res>
    extends _$PolicyYouthcenterResultDtoCopyWithImpl<$Res,
        _$PolicyYouthcenterResultDtoImpl>
    implements _$$PolicyYouthcenterResultDtoImplCopyWith<$Res> {
  __$$PolicyYouthcenterResultDtoImplCopyWithImpl(
      _$PolicyYouthcenterResultDtoImpl _value,
      $Res Function(_$PolicyYouthcenterResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagging = freezed,
    Object? youthPolicyList = freezed,
  }) {
    return _then(_$PolicyYouthcenterResultDtoImpl(
      pagging: freezed == pagging
          ? _value.pagging
          : pagging // ignore: cast_nullable_to_non_nullable
              as PolicyYouthcenterPaggingDto?,
      youthPolicyList: freezed == youthPolicyList
          ? _value._youthPolicyList
          : youthPolicyList // ignore: cast_nullable_to_non_nullable
              as List<PolicyYouthcenterItemDto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyYouthcenterResultDtoImpl implements _PolicyYouthcenterResultDto {
  const _$PolicyYouthcenterResultDtoImpl(
      {this.pagging, final List<PolicyYouthcenterItemDto>? youthPolicyList})
      : _youthPolicyList = youthPolicyList;

  factory _$PolicyYouthcenterResultDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PolicyYouthcenterResultDtoImplFromJson(json);

  @override
  final PolicyYouthcenterPaggingDto? pagging;
  final List<PolicyYouthcenterItemDto>? _youthPolicyList;
  @override
  List<PolicyYouthcenterItemDto>? get youthPolicyList {
    final value = _youthPolicyList;
    if (value == null) return null;
    if (_youthPolicyList is EqualUnmodifiableListView) return _youthPolicyList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PolicyYouthcenterResultDto(pagging: $pagging, youthPolicyList: $youthPolicyList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyYouthcenterResultDtoImpl &&
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
  _$$PolicyYouthcenterResultDtoImplCopyWith<_$PolicyYouthcenterResultDtoImpl>
      get copyWith => __$$PolicyYouthcenterResultDtoImplCopyWithImpl<
          _$PolicyYouthcenterResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicyYouthcenterResultDtoImplToJson(
      this,
    );
  }
}

abstract class _PolicyYouthcenterResultDto
    implements PolicyYouthcenterResultDto {
  const factory _PolicyYouthcenterResultDto(
          {final PolicyYouthcenterPaggingDto? pagging,
          final List<PolicyYouthcenterItemDto>? youthPolicyList}) =
      _$PolicyYouthcenterResultDtoImpl;

  factory _PolicyYouthcenterResultDto.fromJson(Map<String, dynamic> json) =
      _$PolicyYouthcenterResultDtoImpl.fromJson;

  @override
  PolicyYouthcenterPaggingDto? get pagging;
  @override
  List<PolicyYouthcenterItemDto>? get youthPolicyList;
  @override
  @JsonKey(ignore: true)
  _$$PolicyYouthcenterResultDtoImplCopyWith<_$PolicyYouthcenterResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PolicyYouthcenterPaggingDto _$PolicyYouthcenterPaggingDtoFromJson(
    Map<String, dynamic> json) {
  return _PolicyYouthcenterPaggingDto.fromJson(json);
}

/// @nodoc
mixin _$PolicyYouthcenterPaggingDto {
  int? get totCount => throw _privateConstructorUsedError;
  int? get pageNum => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PolicyYouthcenterPaggingDtoCopyWith<PolicyYouthcenterPaggingDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyYouthcenterPaggingDtoCopyWith<$Res> {
  factory $PolicyYouthcenterPaggingDtoCopyWith(
          PolicyYouthcenterPaggingDto value,
          $Res Function(PolicyYouthcenterPaggingDto) then) =
      _$PolicyYouthcenterPaggingDtoCopyWithImpl<$Res,
          PolicyYouthcenterPaggingDto>;
  @useResult
  $Res call({int? totCount, int? pageNum, int? pageSize});
}

/// @nodoc
class _$PolicyYouthcenterPaggingDtoCopyWithImpl<$Res,
        $Val extends PolicyYouthcenterPaggingDto>
    implements $PolicyYouthcenterPaggingDtoCopyWith<$Res> {
  _$PolicyYouthcenterPaggingDtoCopyWithImpl(this._value, this._then);

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
abstract class _$$PolicyYouthcenterPaggingDtoImplCopyWith<$Res>
    implements $PolicyYouthcenterPaggingDtoCopyWith<$Res> {
  factory _$$PolicyYouthcenterPaggingDtoImplCopyWith(
          _$PolicyYouthcenterPaggingDtoImpl value,
          $Res Function(_$PolicyYouthcenterPaggingDtoImpl) then) =
      __$$PolicyYouthcenterPaggingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? totCount, int? pageNum, int? pageSize});
}

/// @nodoc
class __$$PolicyYouthcenterPaggingDtoImplCopyWithImpl<$Res>
    extends _$PolicyYouthcenterPaggingDtoCopyWithImpl<$Res,
        _$PolicyYouthcenterPaggingDtoImpl>
    implements _$$PolicyYouthcenterPaggingDtoImplCopyWith<$Res> {
  __$$PolicyYouthcenterPaggingDtoImplCopyWithImpl(
      _$PolicyYouthcenterPaggingDtoImpl _value,
      $Res Function(_$PolicyYouthcenterPaggingDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totCount = freezed,
    Object? pageNum = freezed,
    Object? pageSize = freezed,
  }) {
    return _then(_$PolicyYouthcenterPaggingDtoImpl(
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
class _$PolicyYouthcenterPaggingDtoImpl
    implements _PolicyYouthcenterPaggingDto {
  const _$PolicyYouthcenterPaggingDtoImpl(
      {this.totCount, this.pageNum, this.pageSize});

  factory _$PolicyYouthcenterPaggingDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PolicyYouthcenterPaggingDtoImplFromJson(json);

  @override
  final int? totCount;
  @override
  final int? pageNum;
  @override
  final int? pageSize;

  @override
  String toString() {
    return 'PolicyYouthcenterPaggingDto(totCount: $totCount, pageNum: $pageNum, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyYouthcenterPaggingDtoImpl &&
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
  _$$PolicyYouthcenterPaggingDtoImplCopyWith<_$PolicyYouthcenterPaggingDtoImpl>
      get copyWith => __$$PolicyYouthcenterPaggingDtoImplCopyWithImpl<
          _$PolicyYouthcenterPaggingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicyYouthcenterPaggingDtoImplToJson(
      this,
    );
  }
}

abstract class _PolicyYouthcenterPaggingDto
    implements PolicyYouthcenterPaggingDto {
  const factory _PolicyYouthcenterPaggingDto(
      {final int? totCount,
      final int? pageNum,
      final int? pageSize}) = _$PolicyYouthcenterPaggingDtoImpl;

  factory _PolicyYouthcenterPaggingDto.fromJson(Map<String, dynamic> json) =
      _$PolicyYouthcenterPaggingDtoImpl.fromJson;

  @override
  int? get totCount;
  @override
  int? get pageNum;
  @override
  int? get pageSize;
  @override
  @JsonKey(ignore: true)
  _$$PolicyYouthcenterPaggingDtoImplCopyWith<_$PolicyYouthcenterPaggingDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PolicyYouthcenterItemDto _$PolicyYouthcenterItemDtoFromJson(
    Map<String, dynamic> json) {
  return _PolicyYouthcenterItemDto.fromJson(json);
}

/// @nodoc
mixin _$PolicyYouthcenterItemDto {
  String? get plcyNo => throw _privateConstructorUsedError;
  String? get bscPlanCycl => throw _privateConstructorUsedError;
  String? get bscPlanPlcyWayNo => throw _privateConstructorUsedError;
  String? get bscPlanFcsAsmtNo => throw _privateConstructorUsedError;
  String? get bscPlanAsmtNo => throw _privateConstructorUsedError;
  String? get pvsnInstGroupCd => throw _privateConstructorUsedError;
  String? get plcyPvsnMthdCd => throw _privateConstructorUsedError;
  String? get plcyAprvSttsCd => throw _privateConstructorUsedError;
  String? get plcyNm => throw _privateConstructorUsedError;
  String? get plcyKywdNm => throw _privateConstructorUsedError;
  String? get plcyExplnCn => throw _privateConstructorUsedError;
  String? get lclsfNm => throw _privateConstructorUsedError;
  String? get mclsfNm => throw _privateConstructorUsedError;
  String? get plcySprtCn => throw _privateConstructorUsedError;
  String? get sprvsnInstCd => throw _privateConstructorUsedError;
  String? get sprvsnInstCdNm => throw _privateConstructorUsedError;
  String? get sprvsnInstPicNm => throw _privateConstructorUsedError;
  String? get operInstCd => throw _privateConstructorUsedError;
  String? get operInstCdNm => throw _privateConstructorUsedError;
  String? get operInstPicNm => throw _privateConstructorUsedError;
  String? get sprtSclLmtYn => throw _privateConstructorUsedError;
  String? get aplyPrdSeCd => throw _privateConstructorUsedError;
  String? get bizPrdSeCd => throw _privateConstructorUsedError;
  String? get bizPrdBgngYmd => throw _privateConstructorUsedError;
  String? get bizPrdEndYmd => throw _privateConstructorUsedError;
  String? get bizPrdEtcCn => throw _privateConstructorUsedError;
  String? get plcyAplyMthdCn => throw _privateConstructorUsedError;
  String? get srngMthdCn => throw _privateConstructorUsedError;
  String? get aplyUrlAddr => throw _privateConstructorUsedError;
  String? get aplyYmd => throw _privateConstructorUsedError;
  String? get earnCndSeCd => throw _privateConstructorUsedError;
  String? get earnMinAmt => throw _privateConstructorUsedError;
  String? get earnMaxAmt => throw _privateConstructorUsedError;
  String? get earnEtcCn => throw _privateConstructorUsedError;
  String? get sprtSclCnt => throw _privateConstructorUsedError;
  String? get sprtTrgtAgeLmtYn => throw _privateConstructorUsedError;
  String? get sprtTrgtMinAge => throw _privateConstructorUsedError;
  String? get sprtTrgtMaxAge => throw _privateConstructorUsedError;
  String? get sprtArvlSeqYn => throw _privateConstructorUsedError;
  String? get sbizCd => throw _privateConstructorUsedError;
  String? get schoolCd => throw _privateConstructorUsedError;
  String? get jobCd => throw _privateConstructorUsedError;
  String? get mrgSttsCd => throw _privateConstructorUsedError;
  String? get ptcpPrpTrgtCn => throw _privateConstructorUsedError;
  String? get addAplyQlfcCndCn => throw _privateConstructorUsedError;
  String? get etcMttrCn => throw _privateConstructorUsedError;
  String? get refUrlAddr1 => throw _privateConstructorUsedError;
  String? get refUrlAddr2 => throw _privateConstructorUsedError;
  String? get sbmsnDcmntCn => throw _privateConstructorUsedError;
  String? get plcyMajorCd => throw _privateConstructorUsedError;
  String? get rgtrHghrkInstCd => throw _privateConstructorUsedError;
  String? get rgtrHghrkInstCdNm => throw _privateConstructorUsedError;
  String? get rgtrInstCd => throw _privateConstructorUsedError;
  String? get rgtrInstCdNm => throw _privateConstructorUsedError;
  String? get rgtrUpInstCd => throw _privateConstructorUsedError;
  String? get rgtrUpInstCdNm => throw _privateConstructorUsedError;
  String? get frstRegDt => throw _privateConstructorUsedError;
  String? get lastMdfcnDt => throw _privateConstructorUsedError;
  String? get inqCnt => throw _privateConstructorUsedError;
  String? get zipCd => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PolicyYouthcenterItemDtoCopyWith<PolicyYouthcenterItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyYouthcenterItemDtoCopyWith<$Res> {
  factory $PolicyYouthcenterItemDtoCopyWith(PolicyYouthcenterItemDto value,
          $Res Function(PolicyYouthcenterItemDto) then) =
      _$PolicyYouthcenterItemDtoCopyWithImpl<$Res, PolicyYouthcenterItemDto>;
  @useResult
  $Res call(
      {String? plcyNo,
      String? bscPlanCycl,
      String? bscPlanPlcyWayNo,
      String? bscPlanFcsAsmtNo,
      String? bscPlanAsmtNo,
      String? pvsnInstGroupCd,
      String? plcyPvsnMthdCd,
      String? plcyAprvSttsCd,
      String? plcyNm,
      String? plcyKywdNm,
      String? plcyExplnCn,
      String? lclsfNm,
      String? mclsfNm,
      String? plcySprtCn,
      String? sprvsnInstCd,
      String? sprvsnInstCdNm,
      String? sprvsnInstPicNm,
      String? operInstCd,
      String? operInstCdNm,
      String? operInstPicNm,
      String? sprtSclLmtYn,
      String? aplyPrdSeCd,
      String? bizPrdSeCd,
      String? bizPrdBgngYmd,
      String? bizPrdEndYmd,
      String? bizPrdEtcCn,
      String? plcyAplyMthdCn,
      String? srngMthdCn,
      String? aplyUrlAddr,
      String? aplyYmd,
      String? earnCndSeCd,
      String? earnMinAmt,
      String? earnMaxAmt,
      String? earnEtcCn,
      String? sprtSclCnt,
      String? sprtTrgtAgeLmtYn,
      String? sprtTrgtMinAge,
      String? sprtTrgtMaxAge,
      String? sprtArvlSeqYn,
      String? sbizCd,
      String? schoolCd,
      String? jobCd,
      String? mrgSttsCd,
      String? ptcpPrpTrgtCn,
      String? addAplyQlfcCndCn,
      String? etcMttrCn,
      String? refUrlAddr1,
      String? refUrlAddr2,
      String? sbmsnDcmntCn,
      String? plcyMajorCd,
      String? rgtrHghrkInstCd,
      String? rgtrHghrkInstCdNm,
      String? rgtrInstCd,
      String? rgtrInstCdNm,
      String? rgtrUpInstCd,
      String? rgtrUpInstCdNm,
      String? frstRegDt,
      String? lastMdfcnDt,
      String? inqCnt,
      String? zipCd});
}

/// @nodoc
class _$PolicyYouthcenterItemDtoCopyWithImpl<$Res,
        $Val extends PolicyYouthcenterItemDto>
    implements $PolicyYouthcenterItemDtoCopyWith<$Res> {
  _$PolicyYouthcenterItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plcyNo = freezed,
    Object? bscPlanCycl = freezed,
    Object? bscPlanPlcyWayNo = freezed,
    Object? bscPlanFcsAsmtNo = freezed,
    Object? bscPlanAsmtNo = freezed,
    Object? pvsnInstGroupCd = freezed,
    Object? plcyPvsnMthdCd = freezed,
    Object? plcyAprvSttsCd = freezed,
    Object? plcyNm = freezed,
    Object? plcyKywdNm = freezed,
    Object? plcyExplnCn = freezed,
    Object? lclsfNm = freezed,
    Object? mclsfNm = freezed,
    Object? plcySprtCn = freezed,
    Object? sprvsnInstCd = freezed,
    Object? sprvsnInstCdNm = freezed,
    Object? sprvsnInstPicNm = freezed,
    Object? operInstCd = freezed,
    Object? operInstCdNm = freezed,
    Object? operInstPicNm = freezed,
    Object? sprtSclLmtYn = freezed,
    Object? aplyPrdSeCd = freezed,
    Object? bizPrdSeCd = freezed,
    Object? bizPrdBgngYmd = freezed,
    Object? bizPrdEndYmd = freezed,
    Object? bizPrdEtcCn = freezed,
    Object? plcyAplyMthdCn = freezed,
    Object? srngMthdCn = freezed,
    Object? aplyUrlAddr = freezed,
    Object? aplyYmd = freezed,
    Object? earnCndSeCd = freezed,
    Object? earnMinAmt = freezed,
    Object? earnMaxAmt = freezed,
    Object? earnEtcCn = freezed,
    Object? sprtSclCnt = freezed,
    Object? sprtTrgtAgeLmtYn = freezed,
    Object? sprtTrgtMinAge = freezed,
    Object? sprtTrgtMaxAge = freezed,
    Object? sprtArvlSeqYn = freezed,
    Object? sbizCd = freezed,
    Object? schoolCd = freezed,
    Object? jobCd = freezed,
    Object? mrgSttsCd = freezed,
    Object? ptcpPrpTrgtCn = freezed,
    Object? addAplyQlfcCndCn = freezed,
    Object? etcMttrCn = freezed,
    Object? refUrlAddr1 = freezed,
    Object? refUrlAddr2 = freezed,
    Object? sbmsnDcmntCn = freezed,
    Object? plcyMajorCd = freezed,
    Object? rgtrHghrkInstCd = freezed,
    Object? rgtrHghrkInstCdNm = freezed,
    Object? rgtrInstCd = freezed,
    Object? rgtrInstCdNm = freezed,
    Object? rgtrUpInstCd = freezed,
    Object? rgtrUpInstCdNm = freezed,
    Object? frstRegDt = freezed,
    Object? lastMdfcnDt = freezed,
    Object? inqCnt = freezed,
    Object? zipCd = freezed,
  }) {
    return _then(_value.copyWith(
      plcyNo: freezed == plcyNo
          ? _value.plcyNo
          : plcyNo // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanCycl: freezed == bscPlanCycl
          ? _value.bscPlanCycl
          : bscPlanCycl // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanPlcyWayNo: freezed == bscPlanPlcyWayNo
          ? _value.bscPlanPlcyWayNo
          : bscPlanPlcyWayNo // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanFcsAsmtNo: freezed == bscPlanFcsAsmtNo
          ? _value.bscPlanFcsAsmtNo
          : bscPlanFcsAsmtNo // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanAsmtNo: freezed == bscPlanAsmtNo
          ? _value.bscPlanAsmtNo
          : bscPlanAsmtNo // ignore: cast_nullable_to_non_nullable
              as String?,
      pvsnInstGroupCd: freezed == pvsnInstGroupCd
          ? _value.pvsnInstGroupCd
          : pvsnInstGroupCd // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyPvsnMthdCd: freezed == plcyPvsnMthdCd
          ? _value.plcyPvsnMthdCd
          : plcyPvsnMthdCd // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyAprvSttsCd: freezed == plcyAprvSttsCd
          ? _value.plcyAprvSttsCd
          : plcyAprvSttsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyNm: freezed == plcyNm
          ? _value.plcyNm
          : plcyNm // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyKywdNm: freezed == plcyKywdNm
          ? _value.plcyKywdNm
          : plcyKywdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyExplnCn: freezed == plcyExplnCn
          ? _value.plcyExplnCn
          : plcyExplnCn // ignore: cast_nullable_to_non_nullable
              as String?,
      lclsfNm: freezed == lclsfNm
          ? _value.lclsfNm
          : lclsfNm // ignore: cast_nullable_to_non_nullable
              as String?,
      mclsfNm: freezed == mclsfNm
          ? _value.mclsfNm
          : mclsfNm // ignore: cast_nullable_to_non_nullable
              as String?,
      plcySprtCn: freezed == plcySprtCn
          ? _value.plcySprtCn
          : plcySprtCn // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstCd: freezed == sprvsnInstCd
          ? _value.sprvsnInstCd
          : sprvsnInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstCdNm: freezed == sprvsnInstCdNm
          ? _value.sprvsnInstCdNm
          : sprvsnInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstPicNm: freezed == sprvsnInstPicNm
          ? _value.sprvsnInstPicNm
          : sprvsnInstPicNm // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstCd: freezed == operInstCd
          ? _value.operInstCd
          : operInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstCdNm: freezed == operInstCdNm
          ? _value.operInstCdNm
          : operInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstPicNm: freezed == operInstPicNm
          ? _value.operInstPicNm
          : operInstPicNm // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtSclLmtYn: freezed == sprtSclLmtYn
          ? _value.sprtSclLmtYn
          : sprtSclLmtYn // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyPrdSeCd: freezed == aplyPrdSeCd
          ? _value.aplyPrdSeCd
          : aplyPrdSeCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdSeCd: freezed == bizPrdSeCd
          ? _value.bizPrdSeCd
          : bizPrdSeCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdBgngYmd: freezed == bizPrdBgngYmd
          ? _value.bizPrdBgngYmd
          : bizPrdBgngYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdEndYmd: freezed == bizPrdEndYmd
          ? _value.bizPrdEndYmd
          : bizPrdEndYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdEtcCn: freezed == bizPrdEtcCn
          ? _value.bizPrdEtcCn
          : bizPrdEtcCn // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyAplyMthdCn: freezed == plcyAplyMthdCn
          ? _value.plcyAplyMthdCn
          : plcyAplyMthdCn // ignore: cast_nullable_to_non_nullable
              as String?,
      srngMthdCn: freezed == srngMthdCn
          ? _value.srngMthdCn
          : srngMthdCn // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyUrlAddr: freezed == aplyUrlAddr
          ? _value.aplyUrlAddr
          : aplyUrlAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyYmd: freezed == aplyYmd
          ? _value.aplyYmd
          : aplyYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      earnCndSeCd: freezed == earnCndSeCd
          ? _value.earnCndSeCd
          : earnCndSeCd // ignore: cast_nullable_to_non_nullable
              as String?,
      earnMinAmt: freezed == earnMinAmt
          ? _value.earnMinAmt
          : earnMinAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      earnMaxAmt: freezed == earnMaxAmt
          ? _value.earnMaxAmt
          : earnMaxAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      earnEtcCn: freezed == earnEtcCn
          ? _value.earnEtcCn
          : earnEtcCn // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtSclCnt: freezed == sprtSclCnt
          ? _value.sprtSclCnt
          : sprtSclCnt // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtTrgtAgeLmtYn: freezed == sprtTrgtAgeLmtYn
          ? _value.sprtTrgtAgeLmtYn
          : sprtTrgtAgeLmtYn // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtTrgtMinAge: freezed == sprtTrgtMinAge
          ? _value.sprtTrgtMinAge
          : sprtTrgtMinAge // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtTrgtMaxAge: freezed == sprtTrgtMaxAge
          ? _value.sprtTrgtMaxAge
          : sprtTrgtMaxAge // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtArvlSeqYn: freezed == sprtArvlSeqYn
          ? _value.sprtArvlSeqYn
          : sprtArvlSeqYn // ignore: cast_nullable_to_non_nullable
              as String?,
      sbizCd: freezed == sbizCd
          ? _value.sbizCd
          : sbizCd // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolCd: freezed == schoolCd
          ? _value.schoolCd
          : schoolCd // ignore: cast_nullable_to_non_nullable
              as String?,
      jobCd: freezed == jobCd
          ? _value.jobCd
          : jobCd // ignore: cast_nullable_to_non_nullable
              as String?,
      mrgSttsCd: freezed == mrgSttsCd
          ? _value.mrgSttsCd
          : mrgSttsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      ptcpPrpTrgtCn: freezed == ptcpPrpTrgtCn
          ? _value.ptcpPrpTrgtCn
          : ptcpPrpTrgtCn // ignore: cast_nullable_to_non_nullable
              as String?,
      addAplyQlfcCndCn: freezed == addAplyQlfcCndCn
          ? _value.addAplyQlfcCndCn
          : addAplyQlfcCndCn // ignore: cast_nullable_to_non_nullable
              as String?,
      etcMttrCn: freezed == etcMttrCn
          ? _value.etcMttrCn
          : etcMttrCn // ignore: cast_nullable_to_non_nullable
              as String?,
      refUrlAddr1: freezed == refUrlAddr1
          ? _value.refUrlAddr1
          : refUrlAddr1 // ignore: cast_nullable_to_non_nullable
              as String?,
      refUrlAddr2: freezed == refUrlAddr2
          ? _value.refUrlAddr2
          : refUrlAddr2 // ignore: cast_nullable_to_non_nullable
              as String?,
      sbmsnDcmntCn: freezed == sbmsnDcmntCn
          ? _value.sbmsnDcmntCn
          : sbmsnDcmntCn // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyMajorCd: freezed == plcyMajorCd
          ? _value.plcyMajorCd
          : plcyMajorCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrHghrkInstCd: freezed == rgtrHghrkInstCd
          ? _value.rgtrHghrkInstCd
          : rgtrHghrkInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrHghrkInstCdNm: freezed == rgtrHghrkInstCdNm
          ? _value.rgtrHghrkInstCdNm
          : rgtrHghrkInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrInstCd: freezed == rgtrInstCd
          ? _value.rgtrInstCd
          : rgtrInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrInstCdNm: freezed == rgtrInstCdNm
          ? _value.rgtrInstCdNm
          : rgtrInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrUpInstCd: freezed == rgtrUpInstCd
          ? _value.rgtrUpInstCd
          : rgtrUpInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrUpInstCdNm: freezed == rgtrUpInstCdNm
          ? _value.rgtrUpInstCdNm
          : rgtrUpInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      frstRegDt: freezed == frstRegDt
          ? _value.frstRegDt
          : frstRegDt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMdfcnDt: freezed == lastMdfcnDt
          ? _value.lastMdfcnDt
          : lastMdfcnDt // ignore: cast_nullable_to_non_nullable
              as String?,
      inqCnt: freezed == inqCnt
          ? _value.inqCnt
          : inqCnt // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCd: freezed == zipCd
          ? _value.zipCd
          : zipCd // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PolicyYouthcenterItemDtoImplCopyWith<$Res>
    implements $PolicyYouthcenterItemDtoCopyWith<$Res> {
  factory _$$PolicyYouthcenterItemDtoImplCopyWith(
          _$PolicyYouthcenterItemDtoImpl value,
          $Res Function(_$PolicyYouthcenterItemDtoImpl) then) =
      __$$PolicyYouthcenterItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? plcyNo,
      String? bscPlanCycl,
      String? bscPlanPlcyWayNo,
      String? bscPlanFcsAsmtNo,
      String? bscPlanAsmtNo,
      String? pvsnInstGroupCd,
      String? plcyPvsnMthdCd,
      String? plcyAprvSttsCd,
      String? plcyNm,
      String? plcyKywdNm,
      String? plcyExplnCn,
      String? lclsfNm,
      String? mclsfNm,
      String? plcySprtCn,
      String? sprvsnInstCd,
      String? sprvsnInstCdNm,
      String? sprvsnInstPicNm,
      String? operInstCd,
      String? operInstCdNm,
      String? operInstPicNm,
      String? sprtSclLmtYn,
      String? aplyPrdSeCd,
      String? bizPrdSeCd,
      String? bizPrdBgngYmd,
      String? bizPrdEndYmd,
      String? bizPrdEtcCn,
      String? plcyAplyMthdCn,
      String? srngMthdCn,
      String? aplyUrlAddr,
      String? aplyYmd,
      String? earnCndSeCd,
      String? earnMinAmt,
      String? earnMaxAmt,
      String? earnEtcCn,
      String? sprtSclCnt,
      String? sprtTrgtAgeLmtYn,
      String? sprtTrgtMinAge,
      String? sprtTrgtMaxAge,
      String? sprtArvlSeqYn,
      String? sbizCd,
      String? schoolCd,
      String? jobCd,
      String? mrgSttsCd,
      String? ptcpPrpTrgtCn,
      String? addAplyQlfcCndCn,
      String? etcMttrCn,
      String? refUrlAddr1,
      String? refUrlAddr2,
      String? sbmsnDcmntCn,
      String? plcyMajorCd,
      String? rgtrHghrkInstCd,
      String? rgtrHghrkInstCdNm,
      String? rgtrInstCd,
      String? rgtrInstCdNm,
      String? rgtrUpInstCd,
      String? rgtrUpInstCdNm,
      String? frstRegDt,
      String? lastMdfcnDt,
      String? inqCnt,
      String? zipCd});
}

/// @nodoc
class __$$PolicyYouthcenterItemDtoImplCopyWithImpl<$Res>
    extends _$PolicyYouthcenterItemDtoCopyWithImpl<$Res,
        _$PolicyYouthcenterItemDtoImpl>
    implements _$$PolicyYouthcenterItemDtoImplCopyWith<$Res> {
  __$$PolicyYouthcenterItemDtoImplCopyWithImpl(
      _$PolicyYouthcenterItemDtoImpl _value,
      $Res Function(_$PolicyYouthcenterItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plcyNo = freezed,
    Object? bscPlanCycl = freezed,
    Object? bscPlanPlcyWayNo = freezed,
    Object? bscPlanFcsAsmtNo = freezed,
    Object? bscPlanAsmtNo = freezed,
    Object? pvsnInstGroupCd = freezed,
    Object? plcyPvsnMthdCd = freezed,
    Object? plcyAprvSttsCd = freezed,
    Object? plcyNm = freezed,
    Object? plcyKywdNm = freezed,
    Object? plcyExplnCn = freezed,
    Object? lclsfNm = freezed,
    Object? mclsfNm = freezed,
    Object? plcySprtCn = freezed,
    Object? sprvsnInstCd = freezed,
    Object? sprvsnInstCdNm = freezed,
    Object? sprvsnInstPicNm = freezed,
    Object? operInstCd = freezed,
    Object? operInstCdNm = freezed,
    Object? operInstPicNm = freezed,
    Object? sprtSclLmtYn = freezed,
    Object? aplyPrdSeCd = freezed,
    Object? bizPrdSeCd = freezed,
    Object? bizPrdBgngYmd = freezed,
    Object? bizPrdEndYmd = freezed,
    Object? bizPrdEtcCn = freezed,
    Object? plcyAplyMthdCn = freezed,
    Object? srngMthdCn = freezed,
    Object? aplyUrlAddr = freezed,
    Object? aplyYmd = freezed,
    Object? earnCndSeCd = freezed,
    Object? earnMinAmt = freezed,
    Object? earnMaxAmt = freezed,
    Object? earnEtcCn = freezed,
    Object? sprtSclCnt = freezed,
    Object? sprtTrgtAgeLmtYn = freezed,
    Object? sprtTrgtMinAge = freezed,
    Object? sprtTrgtMaxAge = freezed,
    Object? sprtArvlSeqYn = freezed,
    Object? sbizCd = freezed,
    Object? schoolCd = freezed,
    Object? jobCd = freezed,
    Object? mrgSttsCd = freezed,
    Object? ptcpPrpTrgtCn = freezed,
    Object? addAplyQlfcCndCn = freezed,
    Object? etcMttrCn = freezed,
    Object? refUrlAddr1 = freezed,
    Object? refUrlAddr2 = freezed,
    Object? sbmsnDcmntCn = freezed,
    Object? plcyMajorCd = freezed,
    Object? rgtrHghrkInstCd = freezed,
    Object? rgtrHghrkInstCdNm = freezed,
    Object? rgtrInstCd = freezed,
    Object? rgtrInstCdNm = freezed,
    Object? rgtrUpInstCd = freezed,
    Object? rgtrUpInstCdNm = freezed,
    Object? frstRegDt = freezed,
    Object? lastMdfcnDt = freezed,
    Object? inqCnt = freezed,
    Object? zipCd = freezed,
  }) {
    return _then(_$PolicyYouthcenterItemDtoImpl(
      plcyNo: freezed == plcyNo
          ? _value.plcyNo
          : plcyNo // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanCycl: freezed == bscPlanCycl
          ? _value.bscPlanCycl
          : bscPlanCycl // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanPlcyWayNo: freezed == bscPlanPlcyWayNo
          ? _value.bscPlanPlcyWayNo
          : bscPlanPlcyWayNo // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanFcsAsmtNo: freezed == bscPlanFcsAsmtNo
          ? _value.bscPlanFcsAsmtNo
          : bscPlanFcsAsmtNo // ignore: cast_nullable_to_non_nullable
              as String?,
      bscPlanAsmtNo: freezed == bscPlanAsmtNo
          ? _value.bscPlanAsmtNo
          : bscPlanAsmtNo // ignore: cast_nullable_to_non_nullable
              as String?,
      pvsnInstGroupCd: freezed == pvsnInstGroupCd
          ? _value.pvsnInstGroupCd
          : pvsnInstGroupCd // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyPvsnMthdCd: freezed == plcyPvsnMthdCd
          ? _value.plcyPvsnMthdCd
          : plcyPvsnMthdCd // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyAprvSttsCd: freezed == plcyAprvSttsCd
          ? _value.plcyAprvSttsCd
          : plcyAprvSttsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyNm: freezed == plcyNm
          ? _value.plcyNm
          : plcyNm // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyKywdNm: freezed == plcyKywdNm
          ? _value.plcyKywdNm
          : plcyKywdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyExplnCn: freezed == plcyExplnCn
          ? _value.plcyExplnCn
          : plcyExplnCn // ignore: cast_nullable_to_non_nullable
              as String?,
      lclsfNm: freezed == lclsfNm
          ? _value.lclsfNm
          : lclsfNm // ignore: cast_nullable_to_non_nullable
              as String?,
      mclsfNm: freezed == mclsfNm
          ? _value.mclsfNm
          : mclsfNm // ignore: cast_nullable_to_non_nullable
              as String?,
      plcySprtCn: freezed == plcySprtCn
          ? _value.plcySprtCn
          : plcySprtCn // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstCd: freezed == sprvsnInstCd
          ? _value.sprvsnInstCd
          : sprvsnInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstCdNm: freezed == sprvsnInstCdNm
          ? _value.sprvsnInstCdNm
          : sprvsnInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      sprvsnInstPicNm: freezed == sprvsnInstPicNm
          ? _value.sprvsnInstPicNm
          : sprvsnInstPicNm // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstCd: freezed == operInstCd
          ? _value.operInstCd
          : operInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstCdNm: freezed == operInstCdNm
          ? _value.operInstCdNm
          : operInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      operInstPicNm: freezed == operInstPicNm
          ? _value.operInstPicNm
          : operInstPicNm // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtSclLmtYn: freezed == sprtSclLmtYn
          ? _value.sprtSclLmtYn
          : sprtSclLmtYn // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyPrdSeCd: freezed == aplyPrdSeCd
          ? _value.aplyPrdSeCd
          : aplyPrdSeCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdSeCd: freezed == bizPrdSeCd
          ? _value.bizPrdSeCd
          : bizPrdSeCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdBgngYmd: freezed == bizPrdBgngYmd
          ? _value.bizPrdBgngYmd
          : bizPrdBgngYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdEndYmd: freezed == bizPrdEndYmd
          ? _value.bizPrdEndYmd
          : bizPrdEndYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      bizPrdEtcCn: freezed == bizPrdEtcCn
          ? _value.bizPrdEtcCn
          : bizPrdEtcCn // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyAplyMthdCn: freezed == plcyAplyMthdCn
          ? _value.plcyAplyMthdCn
          : plcyAplyMthdCn // ignore: cast_nullable_to_non_nullable
              as String?,
      srngMthdCn: freezed == srngMthdCn
          ? _value.srngMthdCn
          : srngMthdCn // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyUrlAddr: freezed == aplyUrlAddr
          ? _value.aplyUrlAddr
          : aplyUrlAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      aplyYmd: freezed == aplyYmd
          ? _value.aplyYmd
          : aplyYmd // ignore: cast_nullable_to_non_nullable
              as String?,
      earnCndSeCd: freezed == earnCndSeCd
          ? _value.earnCndSeCd
          : earnCndSeCd // ignore: cast_nullable_to_non_nullable
              as String?,
      earnMinAmt: freezed == earnMinAmt
          ? _value.earnMinAmt
          : earnMinAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      earnMaxAmt: freezed == earnMaxAmt
          ? _value.earnMaxAmt
          : earnMaxAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      earnEtcCn: freezed == earnEtcCn
          ? _value.earnEtcCn
          : earnEtcCn // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtSclCnt: freezed == sprtSclCnt
          ? _value.sprtSclCnt
          : sprtSclCnt // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtTrgtAgeLmtYn: freezed == sprtTrgtAgeLmtYn
          ? _value.sprtTrgtAgeLmtYn
          : sprtTrgtAgeLmtYn // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtTrgtMinAge: freezed == sprtTrgtMinAge
          ? _value.sprtTrgtMinAge
          : sprtTrgtMinAge // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtTrgtMaxAge: freezed == sprtTrgtMaxAge
          ? _value.sprtTrgtMaxAge
          : sprtTrgtMaxAge // ignore: cast_nullable_to_non_nullable
              as String?,
      sprtArvlSeqYn: freezed == sprtArvlSeqYn
          ? _value.sprtArvlSeqYn
          : sprtArvlSeqYn // ignore: cast_nullable_to_non_nullable
              as String?,
      sbizCd: freezed == sbizCd
          ? _value.sbizCd
          : sbizCd // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolCd: freezed == schoolCd
          ? _value.schoolCd
          : schoolCd // ignore: cast_nullable_to_non_nullable
              as String?,
      jobCd: freezed == jobCd
          ? _value.jobCd
          : jobCd // ignore: cast_nullable_to_non_nullable
              as String?,
      mrgSttsCd: freezed == mrgSttsCd
          ? _value.mrgSttsCd
          : mrgSttsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      ptcpPrpTrgtCn: freezed == ptcpPrpTrgtCn
          ? _value.ptcpPrpTrgtCn
          : ptcpPrpTrgtCn // ignore: cast_nullable_to_non_nullable
              as String?,
      addAplyQlfcCndCn: freezed == addAplyQlfcCndCn
          ? _value.addAplyQlfcCndCn
          : addAplyQlfcCndCn // ignore: cast_nullable_to_non_nullable
              as String?,
      etcMttrCn: freezed == etcMttrCn
          ? _value.etcMttrCn
          : etcMttrCn // ignore: cast_nullable_to_non_nullable
              as String?,
      refUrlAddr1: freezed == refUrlAddr1
          ? _value.refUrlAddr1
          : refUrlAddr1 // ignore: cast_nullable_to_non_nullable
              as String?,
      refUrlAddr2: freezed == refUrlAddr2
          ? _value.refUrlAddr2
          : refUrlAddr2 // ignore: cast_nullable_to_non_nullable
              as String?,
      sbmsnDcmntCn: freezed == sbmsnDcmntCn
          ? _value.sbmsnDcmntCn
          : sbmsnDcmntCn // ignore: cast_nullable_to_non_nullable
              as String?,
      plcyMajorCd: freezed == plcyMajorCd
          ? _value.plcyMajorCd
          : plcyMajorCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrHghrkInstCd: freezed == rgtrHghrkInstCd
          ? _value.rgtrHghrkInstCd
          : rgtrHghrkInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrHghrkInstCdNm: freezed == rgtrHghrkInstCdNm
          ? _value.rgtrHghrkInstCdNm
          : rgtrHghrkInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrInstCd: freezed == rgtrInstCd
          ? _value.rgtrInstCd
          : rgtrInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrInstCdNm: freezed == rgtrInstCdNm
          ? _value.rgtrInstCdNm
          : rgtrInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrUpInstCd: freezed == rgtrUpInstCd
          ? _value.rgtrUpInstCd
          : rgtrUpInstCd // ignore: cast_nullable_to_non_nullable
              as String?,
      rgtrUpInstCdNm: freezed == rgtrUpInstCdNm
          ? _value.rgtrUpInstCdNm
          : rgtrUpInstCdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      frstRegDt: freezed == frstRegDt
          ? _value.frstRegDt
          : frstRegDt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMdfcnDt: freezed == lastMdfcnDt
          ? _value.lastMdfcnDt
          : lastMdfcnDt // ignore: cast_nullable_to_non_nullable
              as String?,
      inqCnt: freezed == inqCnt
          ? _value.inqCnt
          : inqCnt // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCd: freezed == zipCd
          ? _value.zipCd
          : zipCd // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyYouthcenterItemDtoImpl implements _PolicyYouthcenterItemDto {
  const _$PolicyYouthcenterItemDtoImpl(
      {this.plcyNo,
      this.bscPlanCycl,
      this.bscPlanPlcyWayNo,
      this.bscPlanFcsAsmtNo,
      this.bscPlanAsmtNo,
      this.pvsnInstGroupCd,
      this.plcyPvsnMthdCd,
      this.plcyAprvSttsCd,
      this.plcyNm,
      this.plcyKywdNm,
      this.plcyExplnCn,
      this.lclsfNm,
      this.mclsfNm,
      this.plcySprtCn,
      this.sprvsnInstCd,
      this.sprvsnInstCdNm,
      this.sprvsnInstPicNm,
      this.operInstCd,
      this.operInstCdNm,
      this.operInstPicNm,
      this.sprtSclLmtYn,
      this.aplyPrdSeCd,
      this.bizPrdSeCd,
      this.bizPrdBgngYmd,
      this.bizPrdEndYmd,
      this.bizPrdEtcCn,
      this.plcyAplyMthdCn,
      this.srngMthdCn,
      this.aplyUrlAddr,
      this.aplyYmd,
      this.earnCndSeCd,
      this.earnMinAmt,
      this.earnMaxAmt,
      this.earnEtcCn,
      this.sprtSclCnt,
      this.sprtTrgtAgeLmtYn,
      this.sprtTrgtMinAge,
      this.sprtTrgtMaxAge,
      this.sprtArvlSeqYn,
      this.sbizCd,
      this.schoolCd,
      this.jobCd,
      this.mrgSttsCd,
      this.ptcpPrpTrgtCn,
      this.addAplyQlfcCndCn,
      this.etcMttrCn,
      this.refUrlAddr1,
      this.refUrlAddr2,
      this.sbmsnDcmntCn,
      this.plcyMajorCd,
      this.rgtrHghrkInstCd,
      this.rgtrHghrkInstCdNm,
      this.rgtrInstCd,
      this.rgtrInstCdNm,
      this.rgtrUpInstCd,
      this.rgtrUpInstCdNm,
      this.frstRegDt,
      this.lastMdfcnDt,
      this.inqCnt,
      this.zipCd});

  factory _$PolicyYouthcenterItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyYouthcenterItemDtoImplFromJson(json);

  @override
  final String? plcyNo;
  @override
  final String? bscPlanCycl;
  @override
  final String? bscPlanPlcyWayNo;
  @override
  final String? bscPlanFcsAsmtNo;
  @override
  final String? bscPlanAsmtNo;
  @override
  final String? pvsnInstGroupCd;
  @override
  final String? plcyPvsnMthdCd;
  @override
  final String? plcyAprvSttsCd;
  @override
  final String? plcyNm;
  @override
  final String? plcyKywdNm;
  @override
  final String? plcyExplnCn;
  @override
  final String? lclsfNm;
  @override
  final String? mclsfNm;
  @override
  final String? plcySprtCn;
  @override
  final String? sprvsnInstCd;
  @override
  final String? sprvsnInstCdNm;
  @override
  final String? sprvsnInstPicNm;
  @override
  final String? operInstCd;
  @override
  final String? operInstCdNm;
  @override
  final String? operInstPicNm;
  @override
  final String? sprtSclLmtYn;
  @override
  final String? aplyPrdSeCd;
  @override
  final String? bizPrdSeCd;
  @override
  final String? bizPrdBgngYmd;
  @override
  final String? bizPrdEndYmd;
  @override
  final String? bizPrdEtcCn;
  @override
  final String? plcyAplyMthdCn;
  @override
  final String? srngMthdCn;
  @override
  final String? aplyUrlAddr;
  @override
  final String? aplyYmd;
  @override
  final String? earnCndSeCd;
  @override
  final String? earnMinAmt;
  @override
  final String? earnMaxAmt;
  @override
  final String? earnEtcCn;
  @override
  final String? sprtSclCnt;
  @override
  final String? sprtTrgtAgeLmtYn;
  @override
  final String? sprtTrgtMinAge;
  @override
  final String? sprtTrgtMaxAge;
  @override
  final String? sprtArvlSeqYn;
  @override
  final String? sbizCd;
  @override
  final String? schoolCd;
  @override
  final String? jobCd;
  @override
  final String? mrgSttsCd;
  @override
  final String? ptcpPrpTrgtCn;
  @override
  final String? addAplyQlfcCndCn;
  @override
  final String? etcMttrCn;
  @override
  final String? refUrlAddr1;
  @override
  final String? refUrlAddr2;
  @override
  final String? sbmsnDcmntCn;
  @override
  final String? plcyMajorCd;
  @override
  final String? rgtrHghrkInstCd;
  @override
  final String? rgtrHghrkInstCdNm;
  @override
  final String? rgtrInstCd;
  @override
  final String? rgtrInstCdNm;
  @override
  final String? rgtrUpInstCd;
  @override
  final String? rgtrUpInstCdNm;
  @override
  final String? frstRegDt;
  @override
  final String? lastMdfcnDt;
  @override
  final String? inqCnt;
  @override
  final String? zipCd;

  @override
  String toString() {
    return 'PolicyYouthcenterItemDto(plcyNo: $plcyNo, bscPlanCycl: $bscPlanCycl, bscPlanPlcyWayNo: $bscPlanPlcyWayNo, bscPlanFcsAsmtNo: $bscPlanFcsAsmtNo, bscPlanAsmtNo: $bscPlanAsmtNo, pvsnInstGroupCd: $pvsnInstGroupCd, plcyPvsnMthdCd: $plcyPvsnMthdCd, plcyAprvSttsCd: $plcyAprvSttsCd, plcyNm: $plcyNm, plcyKywdNm: $plcyKywdNm, plcyExplnCn: $plcyExplnCn, lclsfNm: $lclsfNm, mclsfNm: $mclsfNm, plcySprtCn: $plcySprtCn, sprvsnInstCd: $sprvsnInstCd, sprvsnInstCdNm: $sprvsnInstCdNm, sprvsnInstPicNm: $sprvsnInstPicNm, operInstCd: $operInstCd, operInstCdNm: $operInstCdNm, operInstPicNm: $operInstPicNm, sprtSclLmtYn: $sprtSclLmtYn, aplyPrdSeCd: $aplyPrdSeCd, bizPrdSeCd: $bizPrdSeCd, bizPrdBgngYmd: $bizPrdBgngYmd, bizPrdEndYmd: $bizPrdEndYmd, bizPrdEtcCn: $bizPrdEtcCn, plcyAplyMthdCn: $plcyAplyMthdCn, srngMthdCn: $srngMthdCn, aplyUrlAddr: $aplyUrlAddr, aplyYmd: $aplyYmd, earnCndSeCd: $earnCndSeCd, earnMinAmt: $earnMinAmt, earnMaxAmt: $earnMaxAmt, earnEtcCn: $earnEtcCn, sprtSclCnt: $sprtSclCnt, sprtTrgtAgeLmtYn: $sprtTrgtAgeLmtYn, sprtTrgtMinAge: $sprtTrgtMinAge, sprtTrgtMaxAge: $sprtTrgtMaxAge, sprtArvlSeqYn: $sprtArvlSeqYn, sbizCd: $sbizCd, schoolCd: $schoolCd, jobCd: $jobCd, mrgSttsCd: $mrgSttsCd, ptcpPrpTrgtCn: $ptcpPrpTrgtCn, addAplyQlfcCndCn: $addAplyQlfcCndCn, etcMttrCn: $etcMttrCn, refUrlAddr1: $refUrlAddr1, refUrlAddr2: $refUrlAddr2, sbmsnDcmntCn: $sbmsnDcmntCn, plcyMajorCd: $plcyMajorCd, rgtrHghrkInstCd: $rgtrHghrkInstCd, rgtrHghrkInstCdNm: $rgtrHghrkInstCdNm, rgtrInstCd: $rgtrInstCd, rgtrInstCdNm: $rgtrInstCdNm, rgtrUpInstCd: $rgtrUpInstCd, rgtrUpInstCdNm: $rgtrUpInstCdNm, frstRegDt: $frstRegDt, lastMdfcnDt: $lastMdfcnDt, inqCnt: $inqCnt, zipCd: $zipCd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyYouthcenterItemDtoImpl &&
            (identical(other.plcyNo, plcyNo) || other.plcyNo == plcyNo) &&
            (identical(other.bscPlanCycl, bscPlanCycl) ||
                other.bscPlanCycl == bscPlanCycl) &&
            (identical(other.bscPlanPlcyWayNo, bscPlanPlcyWayNo) ||
                other.bscPlanPlcyWayNo == bscPlanPlcyWayNo) &&
            (identical(other.bscPlanFcsAsmtNo, bscPlanFcsAsmtNo) ||
                other.bscPlanFcsAsmtNo == bscPlanFcsAsmtNo) &&
            (identical(other.bscPlanAsmtNo, bscPlanAsmtNo) ||
                other.bscPlanAsmtNo == bscPlanAsmtNo) &&
            (identical(other.pvsnInstGroupCd, pvsnInstGroupCd) ||
                other.pvsnInstGroupCd == pvsnInstGroupCd) &&
            (identical(other.plcyPvsnMthdCd, plcyPvsnMthdCd) ||
                other.plcyPvsnMthdCd == plcyPvsnMthdCd) &&
            (identical(other.plcyAprvSttsCd, plcyAprvSttsCd) ||
                other.plcyAprvSttsCd == plcyAprvSttsCd) &&
            (identical(other.plcyNm, plcyNm) || other.plcyNm == plcyNm) &&
            (identical(other.plcyKywdNm, plcyKywdNm) ||
                other.plcyKywdNm == plcyKywdNm) &&
            (identical(other.plcyExplnCn, plcyExplnCn) ||
                other.plcyExplnCn == plcyExplnCn) &&
            (identical(other.lclsfNm, lclsfNm) || other.lclsfNm == lclsfNm) &&
            (identical(other.mclsfNm, mclsfNm) || other.mclsfNm == mclsfNm) &&
            (identical(other.plcySprtCn, plcySprtCn) ||
                other.plcySprtCn == plcySprtCn) &&
            (identical(other.sprvsnInstCd, sprvsnInstCd) ||
                other.sprvsnInstCd == sprvsnInstCd) &&
            (identical(other.sprvsnInstCdNm, sprvsnInstCdNm) ||
                other.sprvsnInstCdNm == sprvsnInstCdNm) &&
            (identical(other.sprvsnInstPicNm, sprvsnInstPicNm) ||
                other.sprvsnInstPicNm == sprvsnInstPicNm) &&
            (identical(other.operInstCd, operInstCd) ||
                other.operInstCd == operInstCd) &&
            (identical(other.operInstCdNm, operInstCdNm) ||
                other.operInstCdNm == operInstCdNm) &&
            (identical(other.operInstPicNm, operInstPicNm) ||
                other.operInstPicNm == operInstPicNm) &&
            (identical(other.sprtSclLmtYn, sprtSclLmtYn) ||
                other.sprtSclLmtYn == sprtSclLmtYn) &&
            (identical(other.aplyPrdSeCd, aplyPrdSeCd) ||
                other.aplyPrdSeCd == aplyPrdSeCd) &&
            (identical(other.bizPrdSeCd, bizPrdSeCd) ||
                other.bizPrdSeCd == bizPrdSeCd) &&
            (identical(other.bizPrdBgngYmd, bizPrdBgngYmd) ||
                other.bizPrdBgngYmd == bizPrdBgngYmd) &&
            (identical(other.bizPrdEndYmd, bizPrdEndYmd) ||
                other.bizPrdEndYmd == bizPrdEndYmd) &&
            (identical(other.bizPrdEtcCn, bizPrdEtcCn) ||
                other.bizPrdEtcCn == bizPrdEtcCn) &&
            (identical(other.plcyAplyMthdCn, plcyAplyMthdCn) ||
                other.plcyAplyMthdCn == plcyAplyMthdCn) &&
            (identical(other.srngMthdCn, srngMthdCn) ||
                other.srngMthdCn == srngMthdCn) &&
            (identical(other.aplyUrlAddr, aplyUrlAddr) ||
                other.aplyUrlAddr == aplyUrlAddr) &&
            (identical(other.aplyYmd, aplyYmd) || other.aplyYmd == aplyYmd) &&
            (identical(other.earnCndSeCd, earnCndSeCd) ||
                other.earnCndSeCd == earnCndSeCd) &&
            (identical(other.earnMinAmt, earnMinAmt) ||
                other.earnMinAmt == earnMinAmt) &&
            (identical(other.earnMaxAmt, earnMaxAmt) ||
                other.earnMaxAmt == earnMaxAmt) &&
            (identical(other.earnEtcCn, earnEtcCn) ||
                other.earnEtcCn == earnEtcCn) &&
            (identical(other.sprtSclCnt, sprtSclCnt) ||
                other.sprtSclCnt == sprtSclCnt) &&
            (identical(other.sprtTrgtAgeLmtYn, sprtTrgtAgeLmtYn) ||
                other.sprtTrgtAgeLmtYn == sprtTrgtAgeLmtYn) &&
            (identical(other.sprtTrgtMinAge, sprtTrgtMinAge) ||
                other.sprtTrgtMinAge == sprtTrgtMinAge) &&
            (identical(other.sprtTrgtMaxAge, sprtTrgtMaxAge) ||
                other.sprtTrgtMaxAge == sprtTrgtMaxAge) &&
            (identical(other.sprtArvlSeqYn, sprtArvlSeqYn) ||
                other.sprtArvlSeqYn == sprtArvlSeqYn) &&
            (identical(other.sbizCd, sbizCd) || other.sbizCd == sbizCd) &&
            (identical(other.schoolCd, schoolCd) ||
                other.schoolCd == schoolCd) &&
            (identical(other.jobCd, jobCd) || other.jobCd == jobCd) &&
            (identical(other.mrgSttsCd, mrgSttsCd) ||
                other.mrgSttsCd == mrgSttsCd) &&
            (identical(other.ptcpPrpTrgtCn, ptcpPrpTrgtCn) ||
                other.ptcpPrpTrgtCn == ptcpPrpTrgtCn) &&
            (identical(other.addAplyQlfcCndCn, addAplyQlfcCndCn) ||
                other.addAplyQlfcCndCn == addAplyQlfcCndCn) &&
            (identical(other.etcMttrCn, etcMttrCn) ||
                other.etcMttrCn == etcMttrCn) &&
            (identical(other.refUrlAddr1, refUrlAddr1) ||
                other.refUrlAddr1 == refUrlAddr1) &&
            (identical(other.refUrlAddr2, refUrlAddr2) ||
                other.refUrlAddr2 == refUrlAddr2) &&
            (identical(other.sbmsnDcmntCn, sbmsnDcmntCn) ||
                other.sbmsnDcmntCn == sbmsnDcmntCn) &&
            (identical(other.plcyMajorCd, plcyMajorCd) ||
                other.plcyMajorCd == plcyMajorCd) &&
            (identical(other.rgtrHghrkInstCd, rgtrHghrkInstCd) || other.rgtrHghrkInstCd == rgtrHghrkInstCd) &&
            (identical(other.rgtrHghrkInstCdNm, rgtrHghrkInstCdNm) || other.rgtrHghrkInstCdNm == rgtrHghrkInstCdNm) &&
            (identical(other.rgtrInstCd, rgtrInstCd) || other.rgtrInstCd == rgtrInstCd) &&
            (identical(other.rgtrInstCdNm, rgtrInstCdNm) || other.rgtrInstCdNm == rgtrInstCdNm) &&
            (identical(other.rgtrUpInstCd, rgtrUpInstCd) || other.rgtrUpInstCd == rgtrUpInstCd) &&
            (identical(other.rgtrUpInstCdNm, rgtrUpInstCdNm) || other.rgtrUpInstCdNm == rgtrUpInstCdNm) &&
            (identical(other.frstRegDt, frstRegDt) || other.frstRegDt == frstRegDt) &&
            (identical(other.lastMdfcnDt, lastMdfcnDt) || other.lastMdfcnDt == lastMdfcnDt) &&
            (identical(other.inqCnt, inqCnt) || other.inqCnt == inqCnt) &&
            (identical(other.zipCd, zipCd) || other.zipCd == zipCd));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        plcyNo,
        bscPlanCycl,
        bscPlanPlcyWayNo,
        bscPlanFcsAsmtNo,
        bscPlanAsmtNo,
        pvsnInstGroupCd,
        plcyPvsnMthdCd,
        plcyAprvSttsCd,
        plcyNm,
        plcyKywdNm,
        plcyExplnCn,
        lclsfNm,
        mclsfNm,
        plcySprtCn,
        sprvsnInstCd,
        sprvsnInstCdNm,
        sprvsnInstPicNm,
        operInstCd,
        operInstCdNm,
        operInstPicNm,
        sprtSclLmtYn,
        aplyPrdSeCd,
        bizPrdSeCd,
        bizPrdBgngYmd,
        bizPrdEndYmd,
        bizPrdEtcCn,
        plcyAplyMthdCn,
        srngMthdCn,
        aplyUrlAddr,
        aplyYmd,
        earnCndSeCd,
        earnMinAmt,
        earnMaxAmt,
        earnEtcCn,
        sprtSclCnt,
        sprtTrgtAgeLmtYn,
        sprtTrgtMinAge,
        sprtTrgtMaxAge,
        sprtArvlSeqYn,
        sbizCd,
        schoolCd,
        jobCd,
        mrgSttsCd,
        ptcpPrpTrgtCn,
        addAplyQlfcCndCn,
        etcMttrCn,
        refUrlAddr1,
        refUrlAddr2,
        sbmsnDcmntCn,
        plcyMajorCd,
        rgtrHghrkInstCd,
        rgtrHghrkInstCdNm,
        rgtrInstCd,
        rgtrInstCdNm,
        rgtrUpInstCd,
        rgtrUpInstCdNm,
        frstRegDt,
        lastMdfcnDt,
        inqCnt,
        zipCd
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PolicyYouthcenterItemDtoImplCopyWith<_$PolicyYouthcenterItemDtoImpl>
      get copyWith => __$$PolicyYouthcenterItemDtoImplCopyWithImpl<
          _$PolicyYouthcenterItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicyYouthcenterItemDtoImplToJson(
      this,
    );
  }
}

abstract class _PolicyYouthcenterItemDto implements PolicyYouthcenterItemDto {
  const factory _PolicyYouthcenterItemDto(
      {final String? plcyNo,
      final String? bscPlanCycl,
      final String? bscPlanPlcyWayNo,
      final String? bscPlanFcsAsmtNo,
      final String? bscPlanAsmtNo,
      final String? pvsnInstGroupCd,
      final String? plcyPvsnMthdCd,
      final String? plcyAprvSttsCd,
      final String? plcyNm,
      final String? plcyKywdNm,
      final String? plcyExplnCn,
      final String? lclsfNm,
      final String? mclsfNm,
      final String? plcySprtCn,
      final String? sprvsnInstCd,
      final String? sprvsnInstCdNm,
      final String? sprvsnInstPicNm,
      final String? operInstCd,
      final String? operInstCdNm,
      final String? operInstPicNm,
      final String? sprtSclLmtYn,
      final String? aplyPrdSeCd,
      final String? bizPrdSeCd,
      final String? bizPrdBgngYmd,
      final String? bizPrdEndYmd,
      final String? bizPrdEtcCn,
      final String? plcyAplyMthdCn,
      final String? srngMthdCn,
      final String? aplyUrlAddr,
      final String? aplyYmd,
      final String? earnCndSeCd,
      final String? earnMinAmt,
      final String? earnMaxAmt,
      final String? earnEtcCn,
      final String? sprtSclCnt,
      final String? sprtTrgtAgeLmtYn,
      final String? sprtTrgtMinAge,
      final String? sprtTrgtMaxAge,
      final String? sprtArvlSeqYn,
      final String? sbizCd,
      final String? schoolCd,
      final String? jobCd,
      final String? mrgSttsCd,
      final String? ptcpPrpTrgtCn,
      final String? addAplyQlfcCndCn,
      final String? etcMttrCn,
      final String? refUrlAddr1,
      final String? refUrlAddr2,
      final String? sbmsnDcmntCn,
      final String? plcyMajorCd,
      final String? rgtrHghrkInstCd,
      final String? rgtrHghrkInstCdNm,
      final String? rgtrInstCd,
      final String? rgtrInstCdNm,
      final String? rgtrUpInstCd,
      final String? rgtrUpInstCdNm,
      final String? frstRegDt,
      final String? lastMdfcnDt,
      final String? inqCnt,
      final String? zipCd}) = _$PolicyYouthcenterItemDtoImpl;

  factory _PolicyYouthcenterItemDto.fromJson(Map<String, dynamic> json) =
      _$PolicyYouthcenterItemDtoImpl.fromJson;

  @override
  String? get plcyNo;
  @override
  String? get bscPlanCycl;
  @override
  String? get bscPlanPlcyWayNo;
  @override
  String? get bscPlanFcsAsmtNo;
  @override
  String? get bscPlanAsmtNo;
  @override
  String? get pvsnInstGroupCd;
  @override
  String? get plcyPvsnMthdCd;
  @override
  String? get plcyAprvSttsCd;
  @override
  String? get plcyNm;
  @override
  String? get plcyKywdNm;
  @override
  String? get plcyExplnCn;
  @override
  String? get lclsfNm;
  @override
  String? get mclsfNm;
  @override
  String? get plcySprtCn;
  @override
  String? get sprvsnInstCd;
  @override
  String? get sprvsnInstCdNm;
  @override
  String? get sprvsnInstPicNm;
  @override
  String? get operInstCd;
  @override
  String? get operInstCdNm;
  @override
  String? get operInstPicNm;
  @override
  String? get sprtSclLmtYn;
  @override
  String? get aplyPrdSeCd;
  @override
  String? get bizPrdSeCd;
  @override
  String? get bizPrdBgngYmd;
  @override
  String? get bizPrdEndYmd;
  @override
  String? get bizPrdEtcCn;
  @override
  String? get plcyAplyMthdCn;
  @override
  String? get srngMthdCn;
  @override
  String? get aplyUrlAddr;
  @override
  String? get aplyYmd;
  @override
  String? get earnCndSeCd;
  @override
  String? get earnMinAmt;
  @override
  String? get earnMaxAmt;
  @override
  String? get earnEtcCn;
  @override
  String? get sprtSclCnt;
  @override
  String? get sprtTrgtAgeLmtYn;
  @override
  String? get sprtTrgtMinAge;
  @override
  String? get sprtTrgtMaxAge;
  @override
  String? get sprtArvlSeqYn;
  @override
  String? get sbizCd;
  @override
  String? get schoolCd;
  @override
  String? get jobCd;
  @override
  String? get mrgSttsCd;
  @override
  String? get ptcpPrpTrgtCn;
  @override
  String? get addAplyQlfcCndCn;
  @override
  String? get etcMttrCn;
  @override
  String? get refUrlAddr1;
  @override
  String? get refUrlAddr2;
  @override
  String? get sbmsnDcmntCn;
  @override
  String? get plcyMajorCd;
  @override
  String? get rgtrHghrkInstCd;
  @override
  String? get rgtrHghrkInstCdNm;
  @override
  String? get rgtrInstCd;
  @override
  String? get rgtrInstCdNm;
  @override
  String? get rgtrUpInstCd;
  @override
  String? get rgtrUpInstCdNm;
  @override
  String? get frstRegDt;
  @override
  String? get lastMdfcnDt;
  @override
  String? get inqCnt;
  @override
  String? get zipCd;
  @override
  @JsonKey(ignore: true)
  _$$PolicyYouthcenterItemDtoImplCopyWith<_$PolicyYouthcenterItemDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
