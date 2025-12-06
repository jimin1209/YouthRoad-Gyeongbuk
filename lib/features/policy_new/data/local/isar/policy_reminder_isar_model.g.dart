// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_reminder_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPolicyReminderIsarModelCollection on Isar {
  IsarCollection<PolicyReminderIsarModel> get policyReminderIsarModels =>
      this.collection();
}

const PolicyReminderIsarModelSchema = CollectionSchema(
  name: r'PolicyReminderIsarModel',
  id: -3930345520110404702,
  properties: {
    r'canceledAtUtc': PropertySchema(
      id: 0,
      name: r'canceledAtUtc',
      type: IsarType.dateTime,
    ),
    r'createdAtUtc': PropertySchema(
      id: 1,
      name: r'createdAtUtc',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'optionCode': PropertySchema(
      id: 3,
      name: r'optionCode',
      type: IsarType.string,
    ),
    r'policyId': PropertySchema(
      id: 4,
      name: r'policyId',
      type: IsarType.string,
    ),
    r'policyTitleSnapshot': PropertySchema(
      id: 5,
      name: r'policyTitleSnapshot',
      type: IsarType.string,
    ),
    r'reminderId': PropertySchema(
      id: 6,
      name: r'reminderId',
      type: IsarType.string,
    ),
    r'scheduledAtUtc': PropertySchema(
      id: 7,
      name: r'scheduledAtUtc',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    ),
    r'updatedAtUtc': PropertySchema(
      id: 9,
      name: r'updatedAtUtc',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _policyReminderIsarModelEstimateSize,
  serialize: _policyReminderIsarModelSerialize,
  deserialize: _policyReminderIsarModelDeserialize,
  deserializeProp: _policyReminderIsarModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'reminderId': IndexSchema(
      id: 3675930301236523255,
      name: r'reminderId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reminderId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'policyId': IndexSchema(
      id: 5070643496271002886,
      name: r'policyId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'policyId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _policyReminderIsarModelGetId,
  getLinks: _policyReminderIsarModelGetLinks,
  attach: _policyReminderIsarModelAttach,
  version: '3.1.0+1',
);

int _policyReminderIsarModelEstimateSize(
  PolicyReminderIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.optionCode.length * 3;
  bytesCount += 3 + object.policyId.length * 3;
  {
    final value = object.policyTitleSnapshot;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.reminderId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _policyReminderIsarModelSerialize(
  PolicyReminderIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.canceledAtUtc);
  writer.writeDateTime(offsets[1], object.createdAtUtc);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeString(offsets[3], object.optionCode);
  writer.writeString(offsets[4], object.policyId);
  writer.writeString(offsets[5], object.policyTitleSnapshot);
  writer.writeString(offsets[6], object.reminderId);
  writer.writeDateTime(offsets[7], object.scheduledAtUtc);
  writer.writeString(offsets[8], object.status);
  writer.writeDateTime(offsets[9], object.updatedAtUtc);
}

PolicyReminderIsarModel _policyReminderIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PolicyReminderIsarModel(
    canceledAtUtc: reader.readDateTimeOrNull(offsets[0]),
    createdAtUtc: reader.readDateTime(offsets[1]),
    isActive: reader.readBool(offsets[2]),
    isarId: id,
    optionCode: reader.readString(offsets[3]),
    policyId: reader.readString(offsets[4]),
    policyTitleSnapshot: reader.readStringOrNull(offsets[5]),
    reminderId: reader.readString(offsets[6]),
    scheduledAtUtc: reader.readDateTime(offsets[7]),
    status: reader.readString(offsets[8]),
    updatedAtUtc: reader.readDateTime(offsets[9]),
  );
  return object;
}

P _policyReminderIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _policyReminderIsarModelGetId(PolicyReminderIsarModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _policyReminderIsarModelGetLinks(
    PolicyReminderIsarModel object) {
  return [];
}

void _policyReminderIsarModelAttach(
    IsarCollection<dynamic> col, Id id, PolicyReminderIsarModel object) {
  object.isarId = id;
}

extension PolicyReminderIsarModelByIndex
    on IsarCollection<PolicyReminderIsarModel> {
  Future<PolicyReminderIsarModel?> getByReminderId(String reminderId) {
    return getByIndex(r'reminderId', [reminderId]);
  }

  PolicyReminderIsarModel? getByReminderIdSync(String reminderId) {
    return getByIndexSync(r'reminderId', [reminderId]);
  }

  Future<bool> deleteByReminderId(String reminderId) {
    return deleteByIndex(r'reminderId', [reminderId]);
  }

  bool deleteByReminderIdSync(String reminderId) {
    return deleteByIndexSync(r'reminderId', [reminderId]);
  }

  Future<List<PolicyReminderIsarModel?>> getAllByReminderId(
      List<String> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'reminderId', values);
  }

  List<PolicyReminderIsarModel?> getAllByReminderIdSync(
      List<String> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'reminderId', values);
  }

  Future<int> deleteAllByReminderId(List<String> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'reminderId', values);
  }

  int deleteAllByReminderIdSync(List<String> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'reminderId', values);
  }

  Future<Id> putByReminderId(PolicyReminderIsarModel object) {
    return putByIndex(r'reminderId', object);
  }

  Id putByReminderIdSync(PolicyReminderIsarModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'reminderId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReminderId(List<PolicyReminderIsarModel> objects) {
    return putAllByIndex(r'reminderId', objects);
  }

  List<Id> putAllByReminderIdSync(List<PolicyReminderIsarModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reminderId', objects, saveLinks: saveLinks);
  }
}

extension PolicyReminderIsarModelQueryWhereSort
    on QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QWhere> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PolicyReminderIsarModelQueryWhere on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QWhereClause> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> reminderIdEqualTo(String reminderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reminderId',
        value: [reminderId],
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> reminderIdNotEqualTo(String reminderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [],
              upper: [reminderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [reminderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [reminderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [],
              upper: [reminderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> policyIdEqualTo(String policyId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'policyId',
        value: [policyId],
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterWhereClause> policyIdNotEqualTo(String policyId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyId',
              lower: [],
              upper: [policyId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyId',
              lower: [policyId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyId',
              lower: [policyId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyId',
              lower: [],
              upper: [policyId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PolicyReminderIsarModelQueryFilter on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QFilterCondition> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> canceledAtUtcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'canceledAtUtc',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> canceledAtUtcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'canceledAtUtc',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> canceledAtUtcEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canceledAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> canceledAtUtcGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canceledAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> canceledAtUtcLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canceledAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> canceledAtUtcBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canceledAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> createdAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> createdAtUtcGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> createdAtUtcLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> createdAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'optionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'optionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'optionCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'optionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'optionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      optionCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'optionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      optionCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'optionCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optionCode',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> optionCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'optionCode',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      policyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      policyIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyTitleSnapshot',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyTitleSnapshot',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyTitleSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      policyTitleSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyTitleSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      policyTitleSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyTitleSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyTitleSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> policyTitleSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyTitleSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      reminderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      reminderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reminderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> reminderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> scheduledAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> scheduledAtUtcGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> scheduledAtUtcLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> scheduledAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> updatedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> updatedAtUtcGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> updatedAtUtcLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel,
      QAfterFilterCondition> updatedAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PolicyReminderIsarModelQueryObject on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QFilterCondition> {}

extension PolicyReminderIsarModelQueryLinks on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QFilterCondition> {}

extension PolicyReminderIsarModelQuerySortBy
    on QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QSortBy> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByCanceledAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canceledAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByCanceledAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canceledAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByCreatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByOptionCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionCode', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByOptionCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionCode', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByPolicyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByPolicyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByPolicyTitleSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTitleSnapshot', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByPolicyTitleSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTitleSnapshot', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByScheduledAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByScheduledAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByUpdatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      sortByUpdatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtUtc', Sort.desc);
    });
  }
}

extension PolicyReminderIsarModelQuerySortThenBy on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QSortThenBy> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByCanceledAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canceledAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByCanceledAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canceledAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByCreatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByOptionCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionCode', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByOptionCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionCode', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByPolicyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByPolicyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByPolicyTitleSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTitleSnapshot', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByPolicyTitleSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTitleSnapshot', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByScheduledAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByScheduledAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByUpdatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterSortBy>
      thenByUpdatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtUtc', Sort.desc);
    });
  }
}

extension PolicyReminderIsarModelQueryWhereDistinct on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByCanceledAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canceledAtUtc');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtUtc');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByOptionCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'optionCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByPolicyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByPolicyTitleSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyTitleSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByReminderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByScheduledAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAtUtc');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct>
      distinctByUpdatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtUtc');
    });
  }
}

extension PolicyReminderIsarModelQueryProperty on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QQueryProperty> {
  QueryBuilder<PolicyReminderIsarModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, DateTime?, QQueryOperations>
      canceledAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canceledAtUtc');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, DateTime, QQueryOperations>
      createdAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtUtc');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, String, QQueryOperations>
      optionCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'optionCode');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, String, QQueryOperations>
      policyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyId');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, String?, QQueryOperations>
      policyTitleSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyTitleSnapshot');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, String, QQueryOperations>
      reminderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderId');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, DateTime, QQueryOperations>
      scheduledAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAtUtc');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PolicyReminderIsarModel, DateTime, QQueryOperations>
      updatedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtUtc');
    });
  }
}
