// FILE: lib/data/search/models/search_result_item_model.dart

import '../../../domain/search/entities/search_category.dart';
import '../../../domain/search/entities/search_result_item.dart';
import '../../../domain/entities/policy.dart';
import '../../models/inst_model.dart';
import '../../models/policy_model.dart';

class SearchResultItemModel {
  const SearchResultItemModel({
    required this.id,
    required this.title,
    required this.category,
    this.subtitle,
    this.region,
    this.latitude,
    this.longitude,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String? subtitle;
  final SearchCategory category;
  final String? region;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic> metadata;

  SearchResultItem toDomain() {
    return SearchResultItem(
      id: id,
      title: title,
      subtitle: subtitle,
      category: category,
      region: region,
      latitude: latitude,
      longitude: longitude,
      metadata: metadata,
    );
  }

  factory SearchResultItemModel.fromPolicy(PolicyModel model) {
    return SearchResultItemModel(
      id: 'policy-${model.id}',
      title: model.policyNm,
      subtitle: model.policyCn ?? model.policyScl,
      category: SearchCategory.policy,
      region: model.regionName,
      metadata: {
        'policyId': model.id,
        'policyType': model.typeName,
        'detailUrl': model.detailUrl,
        'isOngoing': model.isOngoing,
      },
    );
  }

  factory SearchResultItemModel.fromPolicyEntity(Policy policy) {
    return SearchResultItemModel(
      id: 'policy-${policy.id}',
      title: policy.policyNm,
      subtitle: policy.policyCn ?? policy.policyScl,
      category: SearchCategory.policy,
      region: policy.rgnSeNm,
      metadata: {
        'policyId': policy.id,
        'policyType': policy.policyTypeNm,
        'detailUrl': policy.dtlLinkUrl,
        'isOngoing': policy.isOngoing,
      },
    );
  }

  factory SearchResultItemModel.fromInstitution(InstModel model) {
    return SearchResultItemModel(
      id: 'inst-${model.id}',
      title: model.name,
      subtitle: model.addr?.isNotEmpty == true ? model.addr : model.tel,
      category: SearchCategory.institution,
      region: model.addr,
      metadata: {
        'institutionId': model.id,
        'tel': model.tel,
      },
    );
  }
}
