import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/policy_filter.dart';
import 'policy_isar_model.dart';

class IsarService {
  Isar? _isar;

  Future<Isar> get instance async => _isar ??= await _openIsar();

  Future<Isar> _openIsar() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final dir = await getApplicationSupportDirectory();

    if (kDebugMode) {
      debugPrint('[IsarService] Open DB at ${dir.path}');
    }

    return await Isar.open(
      [PolicyIsarModelSchema],
      directory: dir.path,
      inspector: kDebugMode,
    );
  }

  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }

  Future<List<PolicyIsarModel>> getAllPolicies() async {
    final isar = await instance;
    return isar.policyIsarModels.where().findAll();
  }

  Future<List<PolicyIsarModel>> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    final isar = await instance;

    var qb = isar.policyIsarModels.filter();

    if (filter.searchPolicyNm != null && filter.searchPolicyNm!.isNotEmpty) {
      qb = qb.policyNmContains(filter.searchPolicyNm!, caseSensitive: false);
    }

    if (filter.searchRgnSe != null && filter.searchRgnSe!.isNotEmpty) {
      qb = qb.rgnSeNmEqualTo(filter.searchRgnSe!, caseSensitive: false);
    }

    if (filter.category != null && filter.category!.isNotEmpty) {
      qb = qb.policyTypeNmEqualTo(filter.category!, caseSensitive: false);
    }

    if (filter.searchYear != null && filter.searchYear!.isNotEmpty) {
      qb = qb.policyYrEqualTo(filter.searchYear!);
    }

    if (filter.startDate != null) {
      qb = qb.policyBgngYmdGreaterThan(filter.startDate!, include: true);
    }

    if (filter.endDate != null) {
      qb = qb.policyEndYmdLessThan(filter.endDate!, include: true);
    }

    final andResult = await qb.findAll();

    final Set<PolicyIsarModel> orSet = {};

    if (filter.searchText != null && filter.searchText!.isNotEmpty) {
      final t = filter.searchText!;

      final title = await isar.policyIsarModels
          .filter()
          .policyNmContains(t, caseSensitive: false)
          .findAll();

      final content = await isar.policyIsarModels
          .filter()
          .policyCnContains(t, caseSensitive: false)
          .findAll();

      orSet.addAll(title);
      orSet.addAll(content);
    }

    if (filter.availableOnly == true) {
      final now = await isar.policyIsarModels
          .filter()
          .isApplyNowEqualTo(true)
          .findAll();

      final ongoing =
          await isar.policyIsarModels.filter().isOngoingEqualTo(true).findAll();

      orSet.addAll(now);
      orSet.addAll(ongoing);
    }

    List<PolicyIsarModel> result;

    if (orSet.isNotEmpty) {
      result = andResult.where(orSet.contains).toList();
    } else {
      result = andResult;
    }

    final pageIndex = (filter.pageIndex ?? 1).clamp(1, 9999);
    final pageSize = filter.recordCount ?? 50;

    final offset = (pageIndex - 1) * pageSize;
    if (offset >= result.length) return [];

    return result.skip(offset).take(pageSize).toList();
  }

  Future<PolicyIsarModel?> getPolicyById(String id) async {
    final isar = await instance;
    return isar.policyIsarModels.filter().policyIdEqualTo(id).findFirst();
  }

  Future<void> putAllPolicies(List<PolicyIsarModel> list) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.putAll(list);
    });
  }

  Future<void> clearPolicies() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
    });
  }
}
