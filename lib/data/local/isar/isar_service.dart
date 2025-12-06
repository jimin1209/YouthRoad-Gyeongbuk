// lib/data/local/isar/isar_service.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/policy_filter.dart';
import 'policy_isar_model.dart';
import '../../../features/policy_new/data/local/isar/policy_reminder_isar_model.dart';

const _dbName = 'default';

Isar? _instance;
Completer<Isar>? _openCompleter;

class IsarService {
  const IsarService();

  Future<Isar> get instance async {
    if (_instance != null) return _instance!;
    if (_openCompleter != null) return _openCompleter!.future;

    _openCompleter = Completer<Isar>();
    try {
      final db = await _openInternal();
      _instance = db;
      _openCompleter!.complete(db);
      return db;
    } catch (e, st) {
      _openCompleter?.completeError(e, st);
      rethrow;
    }
  }

  Future<Isar> _openInternal() async {
    final dir = await getApplicationSupportDirectory();
    final path = dir.path;

    if (Isar.instanceNames.contains(_dbName)) {
      final existing = Isar.getInstance(_dbName);
      if (existing != null) {
        debugPrint('[IsarService] Reusing existing instance');
        return existing;
      }
    }

    debugPrint('[IsarService] Opening DB at $path');
    try {
      return await Isar.open(
        [
          PolicyIsarModelSchema,
          PolicyReminderIsarModelSchema,
        ],
        name: _dbName,
        directory: path,
        inspector: kDebugMode,
      );
    } on IsarError catch (e) {
      final message = e.message ?? e.toString();
      debugPrint('[IsarService] Open failed: $message');
      if (message.contains('Collection id is invalid')) {
        await _resetDB(path);
        return await Isar.open(
          [
            PolicyIsarModelSchema,
            PolicyReminderIsarModelSchema,
          ],
          name: _dbName,
          directory: path,
          inspector: kDebugMode,
        );
      }
      rethrow;
    }
  }

  Future<void> _resetDB(String path) async {
    try {
      if (_instance?.isOpen == true) {
        await _instance!.close();
      }
    } catch (_) {}

    final dbFile = File('$path/$_dbName.isar');
    final lockFile = File('$path/$_dbName.isar.lock');
    if (await lockFile.exists()) {
      await lockFile.delete();
    }
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
    _instance = null;
    _openCompleter = null;
  }

  Future<void> close() async {
    if (_instance?.isOpen == true) {
      await _instance!.close();
    }
    _instance = null;
    _openCompleter = null;
  }

  // ===========================================================================
  // 정책
  // ===========================================================================

  Future<List<PolicyIsarModel>> getPolicies({PolicyFilter? filter}) async {
    final isar = await instance;
    final all = await isar.policyIsarModels.where().findAll();
    if (filter == null) return all;

    return all.where((p) {
      var ok = true;
      if (filter.searchPolicyNm?.isNotEmpty == true) {
        ok &= p.policyNm
            .toLowerCase()
            .contains(filter.searchPolicyNm!.toLowerCase());
      }
      if (filter.searchRgnSe?.isNotEmpty == true) {
        ok &= (p.rgnSeNm?.toLowerCase() == filter.searchRgnSe!.toLowerCase());
      }
      if (filter.category?.isNotEmpty == true) {
        ok &= (p.policyTypeNm?.toLowerCase() == filter.category!.toLowerCase());
      }
      if (filter.availableOnly == true) {
        ok &= (p.isApplyNow == true || p.isOngoing == true);
      }
      return ok;
    }).toList();
  }

  Future<List<PolicyIsarModel>> getAllPolicies() async {
    final isar = await instance;
    return await isar.policyIsarModels.where().findAll();
  }

  Future<PolicyIsarModel?> getPolicyById(String id) async {
    final isar = await instance;
    return await isar.policyIsarModels.where().policyIdEqualTo(id).findFirst();
  }

  Future<void> putAllPolicies(List<PolicyIsarModel> items) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.putAll(items);
    });
  }

  Future<void> clearPolicies() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
    });
  }

  // ===========================================================================
  // 리마인더
  // ===========================================================================

  Future<PolicyReminderIsarModel> upsertReminder(
    PolicyReminderIsarModel model,
  ) async {
    final isar = await instance;
    PolicyReminderIsarModel stored = model;
    await isar.writeTxn(() async {
      await isar.policyReminderIsarModels.putByReminderId(model);
      final fetched = await isar.policyReminderIsarModels
          .where()
          .reminderIdEqualTo(model.reminderId)
          .findFirst();
      if (fetched != null) stored = fetched;
    });
    return stored;
  }

  Future<void> putReminder(PolicyReminderIsarModel model) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyReminderIsarModels.putByReminderId(model);
    });
  }

  Future<void> deleteReminderById(String reminderId) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      final found = await isar.policyReminderIsarModels
          .where()
          .reminderIdEqualTo(reminderId)
          .findFirst();
      if (found != null) {
        await isar.policyReminderIsarModels.delete(found.isarId);
      }
    });
  }

  Future<void> deleteRemindersByPolicy(String policyId) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      final list = await isar.policyReminderIsarModels
          .where()
          .policyIdEqualTo(policyId)
          .findAll();
      for (final r in list) {
        await isar.policyReminderIsarModels.delete(r.isarId);
      }
    });
  }

  Future<List<PolicyReminderIsarModel>> getAllReminders() async {
    final isar = await instance;
    return await isar.policyReminderIsarModels.where().findAll();
  }

  Future<List<PolicyReminderIsarModel>> getRemindersForPolicy(
    String policyId,
  ) async {
    final isar = await instance;
    return await isar.policyReminderIsarModels
        .where()
        .policyIdEqualTo(policyId)
        .findAll();
  }

  Future<PolicyReminderIsarModel?> getReminder(String reminderId) async {
    final isar = await instance;
    return await isar.policyReminderIsarModels
        .where()
        .reminderIdEqualTo(reminderId)
        .findFirst();
  }

  Future<PolicyReminderIsarModel?> getReminderByPolicyId(
    String policyId,
  ) async {
    final isar = await instance;
    final list = await isar.policyReminderIsarModels
        .where()
        .policyIdEqualTo(policyId)
        .findAll();
    list.sort((a, b) => b.updatedAtUtc.compareTo(a.updatedAtUtc));
    return list.isEmpty ? null : list.first;
  }
}
