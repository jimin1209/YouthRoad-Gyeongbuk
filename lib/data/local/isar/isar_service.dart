import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'policy_isar_model.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  final service = IsarService();
  ref.onDispose(service.close);
  return service;
});

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

  Future<PolicyIsarModel?> getPolicyById(String policyId) async {
    final isar = await instance;
    return isar.policyIsarModels.filter().policyIdEqualTo(policyId).findFirst();
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
