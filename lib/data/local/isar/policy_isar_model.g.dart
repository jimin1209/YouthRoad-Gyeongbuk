// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_isar_model.dart';

// ***************************************************************************
// IsarCollectionGenerator
// ***************************************************************************

extension GetPolicyIsarModelCollection on Isar {
  IsarCollection<PolicyIsarModel> get policyIsarModels =>
      this.collection<PolicyIsarModel>();
}

const PolicyIsarModelSchema = CollectionSchema(
  name: r'PolicyIsarModel',
  id: -3113743137396210088,
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
    r'dtlLinkUrl': PropertySchema(
      id: 4,
      name: r'dtlLinkUrl',
      type: IsarType.string,
    ),
    r'dsplyYn': PropertySchema(
      id: 5,
      name: r'dsplyYn',
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
    r'policyEnq': PropertySchema(
      id: 12,
      name: r'policyEnq',
      type: IsarType.string,
    ),
    r'policyEndYmd': PropertySchema(
      id: 13,
      name: r'policyEndYmd',
      type: IsarType.dateTime,
    ),
    r'policyNm': PropertySchema(
      id: 14,
      name: r'policyNm',
      type: IsarType.string,
    ),
    r'policyScl': PropertySchema(
      id: 15,
      name: r'policyScl',
      type: IsarType.string,
    ),
    r'policyTypeNm': PropertySchema(
      id: 16,
      name: r'policyTypeNm',
      type: IsarType.string,
    ),
    r'policyYr': PropertySchema(
      id: 17,
      name: r'policyYr',
      type: IsarType.string,
    ),
    r'policyId': PropertySchema(
      id: 18,
      name: r'policyId',
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
    ),
  },
  estimateSize: _policyIsarModelEstimateSize,
  serialize: _policyIsarModelSerialize,
  deserialize: _policyIsarModelDeserialize,
  deserializeProp: _policyIsarModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'policyId': IndexSchema(
      id: -8314000835645510860,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _policyIsarModelGetId,
  getLinks: _policyIsarModelGetLinks,
  attach: _policyIsarModelAttach,
  version: 1,
);

int _policyIsarModelEstimateSize(
  PolicyIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + (object.dtlLinkUrl?.length ?? 0);
  bytesCount += 3 + (object.dsplyYn?.length ?? 0);
  bytesCount += 3 + (object.operInstNm?.length ?? 0);
  bytesCount += 3 + (object.policyCn?.length ?? 0);
  bytesCount += 3 + (object.policyEnq?.length ?? 0);
  bytesCount += 3 + object.policyNm.length;
  bytesCount += 3 + (object.policyScl?.length ?? 0);
  bytesCount += 3 + (object.policyTypeNm?.length ?? 0);
  bytesCount += 3 + (object.policyYr?.length ?? 0);
  bytesCount += 3 + object.policyId.length;
  bytesCount += 3 + (object.rgnSeNm?.length ?? 0);
  bytesCount += 3 + (object.sprvsnInstNm?.length ?? 0);
  bytesCount += 3 + object.tags.length * 3;
  for (var v in object.tags) {
    bytesCount += v.length;
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
  writer.writeString(offsets[4], object.dtlLinkUrl);
  writer.writeString(offsets[5], object.dsplyYn);
  writer.writeBool(offsets[6], object.isApplyNow);
  writer.writeBool(offsets[7], object.isOngoing);
  writer.writeBool(offsets[8], object.onlineApply);
  writer.writeString(offsets[9], object.operInstNm);
  writer.writeDateTime(offsets[10], object.policyBgngYmd);
  writer.writeString(offsets[11], object.policyCn);
  writer.writeString(offsets[12], object.policyEnq);
  writer.writeDateTime(offsets[13], object.policyEndYmd);
  writer.writeString(offsets[14], object.policyNm);
  writer.writeString(offsets[15], object.policyScl);
  writer.writeString(offsets[16], object.policyTypeNm);
  writer.writeString(offsets[17], object.policyYr);
  writer.writeString(offsets[18], object.policyId);
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
    dtlLinkUrl: reader.readStringOrNull(offsets[4]),
    dsplyYn: reader.readStringOrNull(offsets[5]),
    isApplyNow: reader.readBoolOrNull(offsets[6]),
    isOngoing: reader.readBoolOrNull(offsets[7]),
    onlineApply: reader.readBoolOrNull(offsets[8]),
    operInstNm: reader.readStringOrNull(offsets[9]),
    policyBgngYmd: reader.readDateTimeOrNull(offsets[10]),
    policyCn: reader.readStringOrNull(offsets[11]),
    policyEnq: reader.readStringOrNull(offsets[12]),
    policyEndYmd: reader.readDateTimeOrNull(offsets[13]),
    policyNm: reader.readString(offsets[14]),
    policyScl: reader.readStringOrNull(offsets[15]),
    policyTypeNm: reader.readStringOrNull(offsets[16]),
    policyYr: reader.readStringOrNull(offsets[17]),
    policyId: reader.readString(offsets[18]),
    rgnSeNm: reader.readStringOrNull(offsets[19]),
    sprvsnInstNm: reader.readStringOrNull(offsets[20]),
    tags: reader.readStringList(offsets[21]) ?? const [],
    updatedAt: reader.readDateTimeOrNull(offsets[22]),
  );
  object.isarId = id;
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
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
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
  return const [];
}

void _policyIsarModelAttach(
    IsarCollection<dynamic> col, Id id, PolicyIsarModel object) {
  object.isarId = id;
}
