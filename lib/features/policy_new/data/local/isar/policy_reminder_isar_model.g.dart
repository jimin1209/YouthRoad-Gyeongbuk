// GENERATED CODE - MANUALLY WRITTEN DUE TO ENV LIMITATIONS

part of 'policy_reminder_isar_model.dart';

// ***************************************************************************
// IsarCollectionGenerator
// ***************************************************************************

extension GetPolicyReminderIsarModelCollection on Isar {
  IsarCollection<PolicyReminderIsarModel> get policyReminderIsarModels =>
      this.collection<PolicyReminderIsarModel>();
}

const PolicyReminderIsarModelSchema = CollectionSchema(
  name: r'PolicyReminderIsarModel',
  id: -1842357767878129312,
  properties: {
    r'createdAtUtc': PropertySchema(
      id: 0,
      name: r'createdAtUtc',
      type: IsarType.dateTime,
    ),
    r'policyId': PropertySchema(
      id: 1,
      name: r'policyId',
      type: IsarType.string,
    ),
    r'policyTitleSnapshot': PropertySchema(
      id: 2,
      name: r'policyTitleSnapshot',
      type: IsarType.string,
    ),
    r'reminderId': PropertySchema(
      id: 3,
      name: r'reminderId',
      type: IsarType.string,
    ),
    r'scheduledAtUtc': PropertySchema(
      id: 4,
      name: r'scheduledAtUtc',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.string,
    ),
    r'optionCode': PropertySchema(
      id: 6,
      name: r'optionCode',
      type: IsarType.string,
    ),
    r'updatedAtUtc': PropertySchema(
      id: 7,
      name: r'updatedAtUtc',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 8,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'canceledAtUtc': PropertySchema(
      id: 9,
      name: r'canceledAtUtc',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _policyReminderIsarModelEstimateSize,
  serialize: _policyReminderIsarModelSerialize,
  deserialize: _policyReminderIsarModelDeserialize,
  deserializeProp: _policyReminderIsarModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'reminderId': IndexSchema(
      id: -8973747439207546061,
      name: r'reminderId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reminderId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'policyId': IndexSchema(
      id: -4539201677813345022,
      name: r'policyId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'policyId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _policyReminderIsarModelGetId,
  getLinks: _policyReminderIsarModelGetLinks,
  attach: _policyReminderIsarModelAttach,
  version: 1,
);

int _policyReminderIsarModelEstimateSize(
  PolicyReminderIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.policyId.length * 3;
  bytesCount += 3 + object.reminderId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.optionCode.length * 3;
  bytesCount += 1; // isActive
  final title = object.policyTitleSnapshot;
  if (title != null) {
    bytesCount += 3 + title.length * 3;
  }
  return bytesCount;
}

void _policyReminderIsarModelSerialize(
  PolicyReminderIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAtUtc);
  writer.writeString(offsets[1], object.policyId);
  writer.writeString(offsets[2], object.policyTitleSnapshot);
  writer.writeString(offsets[3], object.reminderId);
  writer.writeDateTime(offsets[4], object.scheduledAtUtc);
  writer.writeString(offsets[5], object.status);
  writer.writeString(offsets[6], object.optionCode);
  writer.writeDateTime(offsets[7], object.updatedAtUtc);
  writer.writeBool(offsets[8], object.isActive);
  writer.writeDateTime(offsets[9], object.canceledAtUtc);
}

PolicyReminderIsarModel _policyReminderIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PolicyReminderIsarModel(
    isarId: id,
    reminderId: reader.readString(offsets[3]) ?? '',
    policyId: reader.readString(offsets[1]) ?? '',
    optionCode: reader.readString(offsets[6]) ?? '',
    status: reader.readString(offsets[5]) ?? '',
    scheduledAtUtc: reader.readDateTime(offsets[4]),
    createdAtUtc: reader.readDateTime(offsets[0]),
    updatedAtUtc: reader.readDateTime(offsets[7]),
    isActive: reader.readBoolOrNull(offsets[8]) ?? true,
    canceledAtUtc: reader.readDateTimeOrNull(offsets[9]),
    policyTitleSnapshot: reader.readStringOrNull(offsets[2]),
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
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset) ?? '') as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset) ?? '') as P;
    case 6:
      return (reader.readString(offset) ?? '') as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _policyReminderIsarModelGetId(PolicyReminderIsarModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _policyReminderIsarModelGetLinks(
    PolicyReminderIsarModel object) {
  return const [];
}

void _policyReminderIsarModelAttach(
    IsarCollection<dynamic> col, Id id, PolicyReminderIsarModel object) {
  object.isarId = id;
}

extension PolicyReminderIsarModelQueryWhereSort on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QWhere> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PolicyReminderIsarModelQueryWhere on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QWhereClause> {
  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterWhereClause>
      reminderIdEqualTo(String reminderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'reminderId',
          value: [reminderId],
        ),
      );
    });
  }

  QueryBuilder<PolicyReminderIsarModel, PolicyReminderIsarModel, QAfterWhereClause>
      policyIdEqualTo(String policyId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'policyId',
          value: [policyId],
        ),
      );
    });
  }
}

extension PolicyReminderIsarModelQueryFilter on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QFilterCondition> {}

extension PolicyReminderIsarModelQueryObject on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QFilterCondition> {}

extension PolicyReminderIsarModelQueryLinks on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QFilterCondition> {}

extension PolicyReminderIsarModelQuerySortBy on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QSortBy> {}

extension PolicyReminderIsarModelQuerySortThenBy on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QSortThenBy> {}

extension PolicyReminderIsarModelQueryWhereDistinct on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QDistinct> {}

extension PolicyReminderIsarModelQueryProperty on QueryBuilder<
    PolicyReminderIsarModel, PolicyReminderIsarModel, QQueryProperty> {}
