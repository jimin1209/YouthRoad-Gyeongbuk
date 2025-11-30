// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Institution _$InstitutionFromJson(Map<String, dynamic> json) {
  return _Institution.fromJson(json);
}

/// @nodoc
mixin _$Institution {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InstitutionCopyWith<Institution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstitutionCopyWith<$Res> {
  factory $InstitutionCopyWith(
          Institution value, $Res Function(Institution) then) =
      _$InstitutionCopyWithImpl<$Res, Institution>;
  @useResult
  $Res call({String? id, String? name, String? description, String? region});
}

/// @nodoc
class _$InstitutionCopyWithImpl<$Res, $Val extends Institution>
    implements $InstitutionCopyWith<$Res> {
  _$InstitutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? region = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstitutionImplCopyWith<$Res>
    implements $InstitutionCopyWith<$Res> {
  factory _$$InstitutionImplCopyWith(
          _$InstitutionImpl value, $Res Function(_$InstitutionImpl) then) =
      __$$InstitutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? name, String? description, String? region});
}

/// @nodoc
class __$$InstitutionImplCopyWithImpl<$Res>
    extends _$InstitutionCopyWithImpl<$Res, _$InstitutionImpl>
    implements _$$InstitutionImplCopyWith<$Res> {
  __$$InstitutionImplCopyWithImpl(
      _$InstitutionImpl _value, $Res Function(_$InstitutionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? region = freezed,
  }) {
    return _then(_$InstitutionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstitutionImpl implements _Institution {
  const _$InstitutionImpl({this.id, this.name, this.description, this.region});

  factory _$InstitutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstitutionImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? region;

  @override
  String toString() {
    return 'Institution(id: $id, name: $name, description: $description, region: $region)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstitutionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.region, region) || other.region == region));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, region);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      __$$InstitutionImplCopyWithImpl<_$InstitutionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstitutionImplToJson(
      this,
    );
  }
}

abstract class _Institution implements Institution {
  const factory _Institution(
      {final String? id,
      final String? name,
      final String? description,
      final String? region}) = _$InstitutionImpl;

  factory _Institution.fromJson(Map<String, dynamic> json) =
      _$InstitutionImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get description;
  @override
  String? get region;
  @override
  @JsonKey(ignore: true)
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
