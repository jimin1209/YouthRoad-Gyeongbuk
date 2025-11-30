// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPolicyIsarModelCollection on Isar {
  IsarCollection<PolicyIsarModel> get policyIsarModels => this.collection();
}

const PolicyIsarModelSchema = CollectionSchema(
  name: r'PolicyIsarModel',
  id: -791425155178856287,
  properties: {
    r'applyEnd': PropertySchema(
      id: 0,
      name: r'applyEnd',
      type: IsarType.dateTime,
    ),
    r'applyStart': PropertySchema(
      id: 1,
      name: r'applyStart',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dday': PropertySchema(
      id: 3,
      name: r'dday',
      type: IsarType.long,
    ),
    r'dsplyYn': PropertySchema(
      id: 4,
      name: r'dsplyYn',
      type: IsarType.string,
    ),
    r'dtlLinkUrl': PropertySchema(
      id: 5,
      name: r'dtlLinkUrl',
      type: IsarType.string,
    ),
    r'isApplyNow': PropertySchema(
      id: 6,
      name: r'isApplyNow',
      type: IsarType.bool,
    ),
    r'isOngoing': PropertySchema(
      id: 7,
      name: r'isOngoing',
      type: IsarType.bool,
    ),
    r'onlineApply': PropertySchema(
      id: 8,
      name: r'onlineApply',
      type: IsarType.bool,
    ),
    r'operInstNm': PropertySchema(
      id: 9,
      name: r'operInstNm',
      type: IsarType.string,
    ),
    r'policyBgngYmd': PropertySchema(
      id: 10,
      name: r'policyBgngYmd',
      type: IsarType.dateTime,
    ),
    r'policyCn': PropertySchema(
      id: 11,
      name: r'policyCn',
      type: IsarType.string,
    ),
    r'policyEndYmd': PropertySchema(
      id: 12,
      name: r'policyEndYmd',
      type: IsarType.dateTime,
    ),
    r'policyEnq': PropertySchema(
      id: 13,
      name: r'policyEnq',
      type: IsarType.string,
    ),
    r'policyId': PropertySchema(
      id: 14,
      name: r'policyId',
      type: IsarType.string,
    ),
    r'policyNm': PropertySchema(
      id: 15,
      name: r'policyNm',
      type: IsarType.string,
    ),
    r'policyScl': PropertySchema(
      id: 16,
      name: r'policyScl',
      type: IsarType.string,
    ),
    r'policyTypeNm': PropertySchema(
      id: 17,
      name: r'policyTypeNm',
      type: IsarType.string,
    ),
    r'policyYr': PropertySchema(
      id: 18,
      name: r'policyYr',
      type: IsarType.string,
    ),
    r'rgnSeNm': PropertySchema(
      id: 19,
      name: r'rgnSeNm',
      type: IsarType.string,
    ),
    r'sprvsnInstNm': PropertySchema(
      id: 20,
      name: r'sprvsnInstNm',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 21,
      name: r'tags',
      type: IsarType.stringList,
    ),
    r'updatedAt': PropertySchema(
      id: 22,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _policyIsarModelEstimateSize,
  serialize: _policyIsarModelSerialize,
  deserialize: _policyIsarModelDeserialize,
  deserializeProp: _policyIsarModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'policyId': IndexSchema(
      id: 5070643496271002886,
      name: r'policyId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'policyId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'policyNm': IndexSchema(
      id: 4461278890667364242,
      name: r'policyNm',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'policyNm',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'rgnSeNm': IndexSchema(
      id: -6543934550768405027,
      name: r'rgnSeNm',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rgnSeNm',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'policyTypeNm': IndexSchema(
      id: -5175548591284258517,
      name: r'policyTypeNm',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'policyTypeNm',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _policyIsarModelGetId,
  getLinks: _policyIsarModelGetLinks,
  attach: _policyIsarModelAttach,
  version: '3.1.0+1',
);

int _policyIsarModelEstimateSize(
  PolicyIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dsplyYn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dtlLinkUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.operInstNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.policyCn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.policyEnq;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.policyId.length * 3;
  bytesCount += 3 + object.policyNm.length * 3;
  {
    final value = object.policyScl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.policyTypeNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.policyYr;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rgnSeNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sprvsnInstNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _policyIsarModelSerialize(
  PolicyIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.applyEnd);
  writer.writeDateTime(offsets[1], object.applyStart);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.dday);
  writer.writeString(offsets[4], object.dsplyYn);
  writer.writeString(offsets[5], object.dtlLinkUrl);
  writer.writeBool(offsets[6], object.isApplyNow);
  writer.writeBool(offsets[7], object.isOngoing);
  writer.writeBool(offsets[8], object.onlineApply);
  writer.writeString(offsets[9], object.operInstNm);
  writer.writeDateTime(offsets[10], object.policyBgngYmd);
  writer.writeString(offsets[11], object.policyCn);
  writer.writeDateTime(offsets[12], object.policyEndYmd);
  writer.writeString(offsets[13], object.policyEnq);
  writer.writeString(offsets[14], object.policyId);
  writer.writeString(offsets[15], object.policyNm);
  writer.writeString(offsets[16], object.policyScl);
  writer.writeString(offsets[17], object.policyTypeNm);
  writer.writeString(offsets[18], object.policyYr);
  writer.writeString(offsets[19], object.rgnSeNm);
  writer.writeString(offsets[20], object.sprvsnInstNm);
  writer.writeStringList(offsets[21], object.tags);
  writer.writeDateTime(offsets[22], object.updatedAt);
}

PolicyIsarModel _policyIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PolicyIsarModel(
    applyEnd: reader.readDateTimeOrNull(offsets[0]),
    applyStart: reader.readDateTimeOrNull(offsets[1]),
    createdAt: reader.readDateTimeOrNull(offsets[2]),
    dday: reader.readLongOrNull(offsets[3]),
    dsplyYn: reader.readStringOrNull(offsets[4]),
    dtlLinkUrl: reader.readStringOrNull(offsets[5]),
    isApplyNow: reader.readBoolOrNull(offsets[6]),
    isOngoing: reader.readBoolOrNull(offsets[7]),
    isarId: id,
    onlineApply: reader.readBoolOrNull(offsets[8]),
    operInstNm: reader.readStringOrNull(offsets[9]),
    policyBgngYmd: reader.readDateTimeOrNull(offsets[10]),
    policyCn: reader.readStringOrNull(offsets[11]),
    policyEndYmd: reader.readDateTimeOrNull(offsets[12]),
    policyEnq: reader.readStringOrNull(offsets[13]),
    policyId: reader.readString(offsets[14]),
    policyNm: reader.readString(offsets[15]),
    policyScl: reader.readStringOrNull(offsets[16]),
    policyTypeNm: reader.readStringOrNull(offsets[17]),
    policyYr: reader.readStringOrNull(offsets[18]),
    rgnSeNm: reader.readStringOrNull(offsets[19]),
    sprvsnInstNm: reader.readStringOrNull(offsets[20]),
    tags: reader.readStringList(offsets[21]) ?? const [],
    updatedAt: reader.readDateTimeOrNull(offsets[22]),
  );
  return object;
}

P _policyIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readBoolOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringList(offset) ?? const []) as P;
    case 22:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _policyIsarModelGetId(PolicyIsarModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _policyIsarModelGetLinks(PolicyIsarModel object) {
  return [];
}

void _policyIsarModelAttach(
    IsarCollection<dynamic> col, Id id, PolicyIsarModel object) {
  object.isarId = id;
}

extension PolicyIsarModelByIndex on IsarCollection<PolicyIsarModel> {
  Future<PolicyIsarModel?> getByPolicyId(String policyId) {
    return getByIndex(r'policyId', [policyId]);
  }

  PolicyIsarModel? getByPolicyIdSync(String policyId) {
    return getByIndexSync(r'policyId', [policyId]);
  }

  Future<bool> deleteByPolicyId(String policyId) {
    return deleteByIndex(r'policyId', [policyId]);
  }

  bool deleteByPolicyIdSync(String policyId) {
    return deleteByIndexSync(r'policyId', [policyId]);
  }

  Future<List<PolicyIsarModel?>> getAllByPolicyId(List<String> policyIdValues) {
    final values = policyIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'policyId', values);
  }

  List<PolicyIsarModel?> getAllByPolicyIdSync(List<String> policyIdValues) {
    final values = policyIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'policyId', values);
  }

  Future<int> deleteAllByPolicyId(List<String> policyIdValues) {
    final values = policyIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'policyId', values);
  }

  int deleteAllByPolicyIdSync(List<String> policyIdValues) {
    final values = policyIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'policyId', values);
  }

  Future<Id> putByPolicyId(PolicyIsarModel object) {
    return putByIndex(r'policyId', object);
  }

  Id putByPolicyIdSync(PolicyIsarModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'policyId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPolicyId(List<PolicyIsarModel> objects) {
    return putAllByIndex(r'policyId', objects);
  }

  List<Id> putAllByPolicyIdSync(List<PolicyIsarModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'policyId', objects, saveLinks: saveLinks);
  }
}

extension PolicyIsarModelQueryWhereSort
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QWhere> {
  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PolicyIsarModelQueryWhere
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QWhereClause> {
  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyIdEqualTo(String policyId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'policyId',
        value: [policyId],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyIdNotEqualTo(String policyId) {
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyNmEqualTo(String policyNm) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'policyNm',
        value: [policyNm],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyNmNotEqualTo(String policyNm) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyNm',
              lower: [],
              upper: [policyNm],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyNm',
              lower: [policyNm],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyNm',
              lower: [policyNm],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyNm',
              lower: [],
              upper: [policyNm],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      rgnSeNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rgnSeNm',
        value: [null],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      rgnSeNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rgnSeNm',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      rgnSeNmEqualTo(String? rgnSeNm) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rgnSeNm',
        value: [rgnSeNm],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      rgnSeNmNotEqualTo(String? rgnSeNm) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rgnSeNm',
              lower: [],
              upper: [rgnSeNm],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rgnSeNm',
              lower: [rgnSeNm],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rgnSeNm',
              lower: [rgnSeNm],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rgnSeNm',
              lower: [],
              upper: [rgnSeNm],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyTypeNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'policyTypeNm',
        value: [null],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyTypeNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'policyTypeNm',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyTypeNmEqualTo(String? policyTypeNm) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'policyTypeNm',
        value: [policyTypeNm],
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterWhereClause>
      policyTypeNmNotEqualTo(String? policyTypeNm) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyTypeNm',
              lower: [],
              upper: [policyTypeNm],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyTypeNm',
              lower: [policyTypeNm],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyTypeNm',
              lower: [policyTypeNm],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'policyTypeNm',
              lower: [],
              upper: [policyTypeNm],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PolicyIsarModelQueryFilter
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QFilterCondition> {
  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyEndIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'applyEnd',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyEndIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'applyEnd',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyEndEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'applyEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyEndGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'applyEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyEndLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'applyEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyEndBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'applyEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyStartIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'applyStart',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyStartIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'applyStart',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyStartEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'applyStart',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyStartGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'applyStart',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyStartLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'applyStart',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      applyStartBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'applyStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      ddayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dday',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      ddayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dday',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      ddayEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dday',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      ddayGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dday',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      ddayLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dday',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      ddayBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dsplyYn',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dsplyYn',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dsplyYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dsplyYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dsplyYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dsplyYn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dsplyYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dsplyYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dsplyYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dsplyYn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dsplyYn',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dsplyYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dsplyYn',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dtlLinkUrl',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dtlLinkUrl',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dtlLinkUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dtlLinkUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dtlLinkUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dtlLinkUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dtlLinkUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dtlLinkUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dtlLinkUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dtlLinkUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dtlLinkUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      dtlLinkUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dtlLinkUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isApplyNowIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isApplyNow',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isApplyNowIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isApplyNow',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isApplyNowEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isApplyNow',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isOngoingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isOngoing',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isOngoingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isOngoing',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isOngoingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOngoing',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isarIdLessThan(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      onlineApplyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'onlineApply',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      onlineApplyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'onlineApply',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      onlineApplyEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onlineApply',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'operInstNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'operInstNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operInstNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'operInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'operInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operInstNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operInstNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      operInstNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operInstNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyBgngYmdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyBgngYmd',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyBgngYmdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyBgngYmd',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyBgngYmdEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyBgngYmd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyBgngYmdGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyBgngYmd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyBgngYmdLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyBgngYmd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyBgngYmdBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyBgngYmd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyCn',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyCn',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyCn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyCn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyCn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyCn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyCn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyCn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyCn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyCn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyCn',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyCnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyCn',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEndYmdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyEndYmd',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEndYmdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyEndYmd',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEndYmdEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyEndYmd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEndYmdGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyEndYmd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEndYmdLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyEndYmd',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEndYmdBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyEndYmd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyEnq',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyEnq',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyEnq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyEnq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyEnq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyEnq',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyEnq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyEnq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyEnq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyEnq',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyEnq',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyEnqIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyEnq',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdEqualTo(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdGreaterThan(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdLessThan(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdBetween(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdStartsWith(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdEndsWith(
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

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyScl',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyScl',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyScl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyScl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyScl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyScl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyScl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyScl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyScl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyScl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyScl',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policySclIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyScl',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyTypeNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyTypeNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyTypeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyTypeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyTypeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyTypeNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyTypeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyTypeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyTypeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyTypeNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyTypeNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyTypeNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyTypeNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'policyYr',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'policyYr',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyYr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'policyYr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'policyYr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'policyYr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'policyYr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'policyYr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'policyYr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'policyYr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'policyYr',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      policyYrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'policyYr',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rgnSeNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rgnSeNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rgnSeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rgnSeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rgnSeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rgnSeNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rgnSeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rgnSeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rgnSeNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rgnSeNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rgnSeNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      rgnSeNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rgnSeNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sprvsnInstNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sprvsnInstNm',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sprvsnInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sprvsnInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sprvsnInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sprvsnInstNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sprvsnInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sprvsnInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sprvsnInstNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sprvsnInstNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sprvsnInstNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      sprvsnInstNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sprvsnInstNm',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PolicyIsarModelQueryObject
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QFilterCondition> {}

extension PolicyIsarModelQueryLinks
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QFilterCondition> {}

extension PolicyIsarModelQuerySortBy
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QSortBy> {
  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByApplyEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyEnd', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByApplyEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyEnd', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByApplyStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyStart', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByApplyStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyStart', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy> sortByDday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dday', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByDdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dday', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy> sortByDsplyYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dsplyYn', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByDsplyYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dsplyYn', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByDtlLinkUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtlLinkUrl', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByDtlLinkUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtlLinkUrl', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByIsApplyNow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isApplyNow', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByIsApplyNowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isApplyNow', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByIsOngoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOngoing', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByIsOngoingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOngoing', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByOnlineApply() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlineApply', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByOnlineApplyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlineApply', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByOperInstNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operInstNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByOperInstNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operInstNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyBgngYmd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyBgngYmd', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyBgngYmdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyBgngYmd', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyCn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyCn', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyCnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyCn', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyEndYmd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEndYmd', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyEndYmdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEndYmd', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyEnq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEnq', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyEnqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEnq', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyScl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyScl', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicySclDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyScl', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyTypeNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTypeNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyTypeNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTypeNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyYr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyYr', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByPolicyYrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyYr', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy> sortByRgnSeNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rgnSeNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByRgnSeNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rgnSeNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortBySprvsnInstNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprvsnInstNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortBySprvsnInstNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprvsnInstNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PolicyIsarModelQuerySortThenBy
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QSortThenBy> {
  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByApplyEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyEnd', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByApplyEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyEnd', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByApplyStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyStart', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByApplyStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyStart', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy> thenByDday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dday', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByDdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dday', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy> thenByDsplyYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dsplyYn', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByDsplyYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dsplyYn', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByDtlLinkUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtlLinkUrl', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByDtlLinkUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtlLinkUrl', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByIsApplyNow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isApplyNow', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByIsApplyNowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isApplyNow', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByIsOngoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOngoing', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByIsOngoingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOngoing', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByOnlineApply() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlineApply', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByOnlineApplyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlineApply', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByOperInstNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operInstNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByOperInstNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operInstNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyBgngYmd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyBgngYmd', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyBgngYmdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyBgngYmd', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyCn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyCn', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyCnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyCn', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyEndYmd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEndYmd', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyEndYmdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEndYmd', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyEnq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEnq', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyEnqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyEnq', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyId', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyScl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyScl', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicySclDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyScl', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyTypeNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTypeNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyTypeNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyTypeNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyYr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyYr', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByPolicyYrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'policyYr', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy> thenByRgnSeNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rgnSeNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByRgnSeNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rgnSeNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenBySprvsnInstNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprvsnInstNm', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenBySprvsnInstNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprvsnInstNm', Sort.desc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PolicyIsarModelQueryWhereDistinct
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> {
  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByApplyEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'applyEnd');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByApplyStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'applyStart');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByDday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dday');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByDsplyYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dsplyYn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByDtlLinkUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dtlLinkUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByIsApplyNow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isApplyNow');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByIsOngoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOngoing');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByOnlineApply() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onlineApply');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByOperInstNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operInstNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByPolicyBgngYmd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyBgngYmd');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByPolicyCn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyCn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByPolicyEndYmd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyEndYmd');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByPolicyEnq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyEnq', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByPolicyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByPolicyNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByPolicyScl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyScl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByPolicyTypeNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyTypeNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByPolicyYr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'policyYr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByRgnSeNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rgnSeNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctBySprvsnInstNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sprvsnInstNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<PolicyIsarModel, PolicyIsarModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PolicyIsarModelQueryProperty
    on QueryBuilder<PolicyIsarModel, PolicyIsarModel, QQueryProperty> {
  QueryBuilder<PolicyIsarModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PolicyIsarModel, DateTime?, QQueryOperations>
      applyEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'applyEnd');
    });
  }

  QueryBuilder<PolicyIsarModel, DateTime?, QQueryOperations>
      applyStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'applyStart');
    });
  }

  QueryBuilder<PolicyIsarModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PolicyIsarModel, int?, QQueryOperations> ddayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dday');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations> dsplyYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dsplyYn');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations>
      dtlLinkUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dtlLinkUrl');
    });
  }

  QueryBuilder<PolicyIsarModel, bool?, QQueryOperations> isApplyNowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isApplyNow');
    });
  }

  QueryBuilder<PolicyIsarModel, bool?, QQueryOperations> isOngoingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOngoing');
    });
  }

  QueryBuilder<PolicyIsarModel, bool?, QQueryOperations> onlineApplyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onlineApply');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations>
      operInstNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operInstNm');
    });
  }

  QueryBuilder<PolicyIsarModel, DateTime?, QQueryOperations>
      policyBgngYmdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyBgngYmd');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations> policyCnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyCn');
    });
  }

  QueryBuilder<PolicyIsarModel, DateTime?, QQueryOperations>
      policyEndYmdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyEndYmd');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations> policyEnqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyEnq');
    });
  }

  QueryBuilder<PolicyIsarModel, String, QQueryOperations> policyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyId');
    });
  }

  QueryBuilder<PolicyIsarModel, String, QQueryOperations> policyNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyNm');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations> policySclProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyScl');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations>
      policyTypeNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyTypeNm');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations> policyYrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'policyYr');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations> rgnSeNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rgnSeNm');
    });
  }

  QueryBuilder<PolicyIsarModel, String?, QQueryOperations>
      sprvsnInstNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sprvsnInstNm');
    });
  }

  QueryBuilder<PolicyIsarModel, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<PolicyIsarModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
