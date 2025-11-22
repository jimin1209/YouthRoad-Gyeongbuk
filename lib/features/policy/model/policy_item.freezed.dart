// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'policy_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PolicyItem _$PolicyItemFromJson(Map<String, dynamic> json) {
  return _PolicyItem.fromJson(json);
}

/// @nodoc
mixin _$PolicyItem {
  @JsonKey(name: 'no', fromJson: _string)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'policyNm')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'policyCn')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'instNm')
  String? get instNm => throw _privateConstructorUsedError;
  @JsonKey(name: 'deptNm')
  String? get deptNm => throw _privateConstructorUsedError;
  @JsonKey(name: 'policyTypeNm')
  String? get policyType => throw _privateConstructorUsedError;
  @JsonKey(name: 'rgnSeNm')
  String? get region => throw _privateConstructorUsedError;
  @JsonKey(name: 'policyBgngYmd')
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'policyEndYmd')
  String? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'url')
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'aplyPsbltyYn')
  String? get applyAbleYn => throw _privateConstructorUsedError;
  @JsonKey(name: 'instTel')
  String? get instTel => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'no', fromJson: _string) String? id,
      @JsonKey(name: 'policyNm') String? title,
      @JsonKey(name: 'policyCn') String? description,
      @JsonKey(name: 'instNm') String? instNm,
      @JsonKey(name: 'deptNm') String? deptNm,
      @JsonKey(name: 'policyTypeNm') String? policyType,
      @JsonKey(name: 'rgnSeNm') String? region,
      @JsonKey(name: 'policyBgngYmd') String? startDate,
      @JsonKey(name: 'policyEndYmd') String? endDate,
      @JsonKey(name: 'url') String? url,
      @JsonKey(name: 'aplyPsbltyYn') String? applyAbleYn,
      @JsonKey(name: 'instTel') String? instTel});
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
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? instNm = freezed,
    Object? deptNm = freezed,
    Object? policyType = freezed,
    Object? region = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? url = freezed,
    Object? applyAbleYn = freezed,
    Object? instTel = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      instNm: freezed == instNm
          ? _value.instNm
          : instNm // ignore: cast_nullable_to_non_nullable
              as String?,
      deptNm: freezed == deptNm
          ? _value.deptNm
          : deptNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyType: freezed == policyType
          ? _value.policyType
          : policyType // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      applyAbleYn: freezed == applyAbleYn
          ? _value.applyAbleYn
          : applyAbleYn // ignore: cast_nullable_to_non_nullable
              as String?,
      instTel: freezed == instTel
          ? _value.instTel
          : instTel // ignore: cast_nullable_to_non_nullable
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
      {@JsonKey(name: 'no', fromJson: _string) String? id,
      @JsonKey(name: 'policyNm') String? title,
      @JsonKey(name: 'policyCn') String? description,
      @JsonKey(name: 'instNm') String? instNm,
      @JsonKey(name: 'deptNm') String? deptNm,
      @JsonKey(name: 'policyTypeNm') String? policyType,
      @JsonKey(name: 'rgnSeNm') String? region,
      @JsonKey(name: 'policyBgngYmd') String? startDate,
      @JsonKey(name: 'policyEndYmd') String? endDate,
      @JsonKey(name: 'url') String? url,
      @JsonKey(name: 'aplyPsbltyYn') String? applyAbleYn,
      @JsonKey(name: 'instTel') String? instTel});
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
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? instNm = freezed,
    Object? deptNm = freezed,
    Object? policyType = freezed,
    Object? region = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? url = freezed,
    Object? applyAbleYn = freezed,
    Object? instTel = freezed,
  }) {
    return _then(_$PolicyItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      instNm: freezed == instNm
          ? _value.instNm
          : instNm // ignore: cast_nullable_to_non_nullable
              as String?,
      deptNm: freezed == deptNm
          ? _value.deptNm
          : deptNm // ignore: cast_nullable_to_non_nullable
              as String?,
      policyType: freezed == policyType
          ? _value.policyType
          : policyType // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      applyAbleYn: freezed == applyAbleYn
          ? _value.applyAbleYn
          : applyAbleYn // ignore: cast_nullable_to_non_nullable
              as String?,
      instTel: freezed == instTel
          ? _value.instTel
          : instTel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyItemImpl implements _PolicyItem {
  const _$PolicyItemImpl(
      {@JsonKey(name: 'no', fromJson: _string) this.id,
      @JsonKey(name: 'policyNm') this.title,
      @JsonKey(name: 'policyCn') this.description,
      @JsonKey(name: 'instNm') this.instNm,
      @JsonKey(name: 'deptNm') this.deptNm,
      @JsonKey(name: 'policyTypeNm') this.policyType,
      @JsonKey(name: 'rgnSeNm') this.region,
      @JsonKey(name: 'policyBgngYmd') this.startDate,
      @JsonKey(name: 'policyEndYmd') this.endDate,
      @JsonKey(name: 'url') this.url,
      @JsonKey(name: 'aplyPsbltyYn') this.applyAbleYn,
      @JsonKey(name: 'instTel') this.instTel});

  factory _$PolicyItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyItemImplFromJson(json);

  @override
  @JsonKey(name: 'no', fromJson: _string)
  final String? id;
  @override
  @JsonKey(name: 'policyNm')
  final String? title;
  @override
  @JsonKey(name: 'policyCn')
  final String? description;
  @override
  @JsonKey(name: 'instNm')
  final String? instNm;
  @override
  @JsonKey(name: 'deptNm')
  final String? deptNm;
  @override
  @JsonKey(name: 'policyTypeNm')
  final String? policyType;
  @override
  @JsonKey(name: 'rgnSeNm')
  final String? region;
  @override
  @JsonKey(name: 'policyBgngYmd')
  final String? startDate;
  @override
  @JsonKey(name: 'policyEndYmd')
  final String? endDate;
  @override
  @JsonKey(name: 'url')
  final String? url;
  @override
  @JsonKey(name: 'aplyPsbltyYn')
  final String? applyAbleYn;
  @override
  @JsonKey(name: 'instTel')
  final String? instTel;

  @override
  String toString() {
    return 'PolicyItem(id: $id, title: $title, description: $description, instNm: $instNm, deptNm: $deptNm, policyType: $policyType, region: $region, startDate: $startDate, endDate: $endDate, url: $url, applyAbleYn: $applyAbleYn, instTel: $instTel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.instNm, instNm) || other.instNm == instNm) &&
            (identical(other.deptNm, deptNm) || other.deptNm == deptNm) &&
            (identical(other.policyType, policyType) ||
                other.policyType == policyType) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.applyAbleYn, applyAbleYn) ||
                other.applyAbleYn == applyAbleYn) &&
            (identical(other.instTel, instTel) || other.instTel == instTel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      instNm,
      deptNm,
      policyType,
      region,
      startDate,
      endDate,
      url,
      applyAbleYn,
      instTel);

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
      {@JsonKey(name: 'no', fromJson: _string) final String? id,
      @JsonKey(name: 'policyNm') final String? title,
      @JsonKey(name: 'policyCn') final String? description,
      @JsonKey(name: 'instNm') final String? instNm,
      @JsonKey(name: 'deptNm') final String? deptNm,
      @JsonKey(name: 'policyTypeNm') final String? policyType,
      @JsonKey(name: 'rgnSeNm') final String? region,
      @JsonKey(name: 'policyBgngYmd') final String? startDate,
      @JsonKey(name: 'policyEndYmd') final String? endDate,
      @JsonKey(name: 'url') final String? url,
      @JsonKey(name: 'aplyPsbltyYn') final String? applyAbleYn,
      @JsonKey(name: 'instTel') final String? instTel}) = _$PolicyItemImpl;

  factory _PolicyItem.fromJson(Map<String, dynamic> json) =
      _$PolicyItemImpl.fromJson;

  @override
  @JsonKey(name: 'no', fromJson: _string)
  String? get id;
  @override
  @JsonKey(name: 'policyNm')
  String? get title;
  @override
  @JsonKey(name: 'policyCn')
  String? get description;
  @override
  @JsonKey(name: 'instNm')
  String? get instNm;
  @override
  @JsonKey(name: 'deptNm')
  String? get deptNm;
  @override
  @JsonKey(name: 'policyTypeNm')
  String? get policyType;
  @override
  @JsonKey(name: 'rgnSeNm')
  String? get region;
  @override
  @JsonKey(name: 'policyBgngYmd')
  String? get startDate;
  @override
  @JsonKey(name: 'policyEndYmd')
  String? get endDate;
  @override
  @JsonKey(name: 'url')
  String? get url;
  @override
  @JsonKey(name: 'aplyPsbltyYn')
  String? get applyAbleYn;
  @override
  @JsonKey(name: 'instTel')
  String? get instTel;

  /// Create a copy of PolicyItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolicyItemImplCopyWith<_$PolicyItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PolicyListResponse _$PolicyListResponseFromJson(Map<String, dynamic> json) {
  return _PolicyListResponse.fromJson(json);
}

/// @nodoc
mixin _$PolicyListResponse {
  @JsonKey(defaultValue: [])
  List<PolicyItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'resultList', defaultValue: [])
  List<PolicyItem>? get resultList => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get pageIndex => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;

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
      {@JsonKey(defaultValue: []) List<PolicyItem> items,
      @JsonKey(name: 'resultList', defaultValue: [])
      List<PolicyItem>? resultList,
      int totalCount,
      int pageIndex,
      int pageSize});
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
    Object? items = null,
    Object? resultList = freezed,
    Object? totalCount = null,
    Object? pageIndex = null,
    Object? pageSize = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PolicyItem>,
      resultList: freezed == resultList
          ? _value.resultList
          : resultList // ignore: cast_nullable_to_non_nullable
              as List<PolicyItem>?,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
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
      {@JsonKey(defaultValue: []) List<PolicyItem> items,
      @JsonKey(name: 'resultList', defaultValue: [])
      List<PolicyItem>? resultList,
      int totalCount,
      int pageIndex,
      int pageSize});
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
    Object? items = null,
    Object? resultList = freezed,
    Object? totalCount = null,
    Object? pageIndex = null,
    Object? pageSize = null,
  }) {
    return _then(_$PolicyListResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PolicyItem>,
      resultList: freezed == resultList
          ? _value._resultList
          : resultList // ignore: cast_nullable_to_non_nullable
              as List<PolicyItem>?,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyListResponseImpl implements _PolicyListResponse {
  const _$PolicyListResponseImpl(
      {@JsonKey(defaultValue: []) required final List<PolicyItem> items,
      @JsonKey(name: 'resultList', defaultValue: [])
      final List<PolicyItem>? resultList,
      this.totalCount = 0,
      this.pageIndex = 1,
      this.pageSize = 10})
      : _items = items,
        _resultList = resultList;

  factory _$PolicyListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyListResponseImplFromJson(json);

  final List<PolicyItem> _items;
  @override
  @JsonKey(defaultValue: [])
  List<PolicyItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<PolicyItem>? _resultList;
  @override
  @JsonKey(name: 'resultList', defaultValue: [])
  List<PolicyItem>? get resultList {
    final value = _resultList;
    if (value == null) return null;
    if (_resultList is EqualUnmodifiableListView) return _resultList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int totalCount;
  @override
  @JsonKey()
  final int pageIndex;
  @override
  @JsonKey()
  final int pageSize;

  @override
  String toString() {
    return 'PolicyListResponse(items: $items, resultList: $resultList, totalCount: $totalCount, pageIndex: $pageIndex, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyListResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._resultList, _resultList) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.pageIndex, pageIndex) ||
                other.pageIndex == pageIndex) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_resultList),
      totalCount,
      pageIndex,
      pageSize);

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
      {@JsonKey(defaultValue: []) required final List<PolicyItem> items,
      @JsonKey(name: 'resultList', defaultValue: [])
      final List<PolicyItem>? resultList,
      final int totalCount,
      final int pageIndex,
      final int pageSize}) = _$PolicyListResponseImpl;

  factory _PolicyListResponse.fromJson(Map<String, dynamic> json) =
      _$PolicyListResponseImpl.fromJson;

  @override
  @JsonKey(defaultValue: [])
  List<PolicyItem> get items;
  @override
  @JsonKey(name: 'resultList', defaultValue: [])
  List<PolicyItem>? get resultList;
  @override
  int get totalCount;
  @override
  int get pageIndex;
  @override
  int get pageSize;

  /// Create a copy of PolicyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolicyListResponseImplCopyWith<_$PolicyListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
