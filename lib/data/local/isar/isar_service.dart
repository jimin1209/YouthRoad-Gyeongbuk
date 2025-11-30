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
      debugPrint('[IsarService] Opening Isar at ${dir.path}');
    }

    return Isar.open(
      [PolicyIsarModelSchema],
      inspector: kDebugMode,
      directory: dir.path,
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
    final policies = await getAllPolicies();
    Iterable<PolicyIsarModel> results = policies;

    bool _containsIgnoreCase(String source, String query) {
      return source.toLowerCase().contains(query.toLowerCase());
    }

    if (filter.searchPolicyNm != null && filter.searchPolicyNm!.isNotEmpty) {
      results = results.where(
        (item) => _containsIgnoreCase(item.policyNm, filter.searchPolicyNm!),
      );
    }

    if (filter.searchText != null && filter.searchText!.isNotEmpty) {
      results = results.where(
        (item) =>
            (item.policyCn != null &&
                _containsIgnoreCase(item.policyCn!, filter.searchText!)) ||
            (item.policyNm.isNotEmpty &&
                _containsIgnoreCase(item.policyNm, filter.searchText!)),
      );
    }

    if (filter.searchRgnSe != null && filter.searchRgnSe!.isNotEmpty) {
      results = results.where(
        (item) =>
            item.rgnSeNm != null &&
            item.rgnSeNm!.toLowerCase() == filter.searchRgnSe!.toLowerCase(),
      );
    }

    if (filter.searchPolicyType != null && filter.searchPolicyType!.isNotEmpty) {
      results = results.where(
        (item) =>
            item.policyTypeNm != null &&
            item.policyTypeNm!.toLowerCase() ==
                filter.searchPolicyType!.toLowerCase(),
      );
    }

    if (filter.category != null && filter.category!.isNotEmpty) {
      results = results.where(
        (item) =>
            item.policyTypeNm != null &&
            item.policyTypeNm!.toLowerCase() == filter.category!.toLowerCase(),
      );
    }

    if (filter.searchYear != null && filter.searchYear!.isNotEmpty) {
      results = results.where(
        (item) => item.policyYr != null && item.policyYr == filter.searchYear,
      );
    }

    if (filter.availableOnly == true) {
      results = results.where(
        (item) => item.isApplyNow == true || item.isOngoing == true,
      );
    }

    if (filter.startDate != null) {
      results = results.where((item) {
        final start = item.applyStart ?? item.policyBgngYmd;
        if (start == null) return false;
        return !start.isBefore(filter.startDate!);
      });
    }

    if (filter.endDate != null) {
      results = results.where((item) {
        final end = item.applyEnd ?? item.policyEndYmd;
        if (end == null) return false;
        return !end.isAfter(filter.endDate!);
      });
    }

    final pageIndex = (filter.pageIndex ?? 1) < 1 ? 1 : filter.pageIndex ?? 1;
    final pageSize = filter.recordCount ?? results.length;
    final start = (pageIndex - 1) * pageSize;

    return results.skip(start).take(pageSize).toList();
  }

  Future<PolicyIsarModel?> getPolicyById(String policyId) async {
    final policies = await getAllPolicies();
    try {
      return policies.firstWhere((element) => element.policyId == policyId);
    } catch (_) {
      return null;
    }
  }

  Future<void> putAllPolicies(List<PolicyIsarModel> models) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.putAll(models);
    });
  }

  Future<void> clearPolicies() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
    });
  }
}
