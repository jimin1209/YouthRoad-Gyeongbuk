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
int _resetCount = 0;

class IsarService {
  const IsarService();

  String _callerTrace() {
    try {
      final trace = StackTrace.current.toString().split('\n');
      if (trace.length > 2) return trace[2];
    } catch (_) {}
    return 'UnknownCaller';
  }

  Future<Isar> get instance async {
    final caller = _callerTrace();

    if (_instance != null) {
      debugPrint('[ISAR] Reuse existing instance ← caller $caller');
      return _instance!;
    }

    if (_openCompleter != null) {
      debugPrint('[ISAR] Waiting existing open ← caller $caller');
      return _openCompleter!.future;
    }

    debugPrint('[ISAR] Start open ← caller $caller');
    _openCompleter = Completer();

    try {
      final db = await _openInternal(caller);
      _instance = db;
      _openCompleter!.complete(db);
      return db;
    } catch (e, st) {
      if (!(_openCompleter?.isCompleted ?? true)) {
        _openCompleter!.completeError(e, st);
      }
      rethrow;
    }
  }

  Future<Isar> _openInternal(String caller) async {
    final sw = Stopwatch()..start();
    final dir = await getApplicationSupportDirectory();
    final path = dir.path;

    debugPrint("📌 [IsarService] opening @ $path (caller: $caller)");

    try {
      final opened = await Isar.open(
        [
          PolicyIsarModelSchema,
          PolicyReminderIsarModelSchema,
        ],
        inspector: kDebugMode,
        name: _dbName,
        directory: path,
      );

      sw.stop();
      debugPrint("✔ ISAR OPEN SUCCESS (${sw.elapsedMilliseconds}ms)");
      return opened;
    } on IsarError catch (e) {
      final msg = e.message ?? e.toString();
      debugPrint("🔥 ISAR OPEN ERROR → $msg");

      if (msg.contains('Collection id is invalid')) {
        _resetCount++;
        debugPrint("🔥 DB RESET STARTED (count=$_resetCount)");
        await _resetDB(path);
        debugPrint("🔥 RETRY after RESET");

        return await Isar.open(
          [
            PolicyIsarModelSchema,
            PolicyReminderIsarModelSchema,
          ],
          inspector: kDebugMode,
          name: _dbName,
          directory: path,
        );
      }

      rethrow;
    }
  }

  Future<void> _resetDB(String path) async {
    try {
      if (_instance?.isOpen == true) {
        debugPrint("🔥 CLOSING DB BEFORE RESET");
        await _instance!.close();
      }
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 200));

    final dbFile = File("$path/$_dbName.isar");
    final lockFile = File("$path/$_dbName.isar.lock");

    if (await lockFile.exists()) {
      debugPrint("🔥 removing lock");
      await lockFile.delete();
    }

    if (await dbFile.exists()) {
      debugPrint("🔥 removing db");
      await dbFile.delete();
    }

    _instance = null;
    _openCompleter = null;
  }

  /// cleanup for provider dispose
  Future<void> close() async {
    if (_instance?.isOpen == true) {
      await _instance!.close();
    }

    _instance = null;
    _openCompleter = null;
  }

  // ============================================================================
  // 정책 관련 저장소
  // ============================================================================

  Future<List<PolicyIsarModel>> getPolicies({PolicyFilter? filter}) async {
    final isar = await instance;
    final all = await isar.policyIsarModels.where().findAll();

    if (filter == null) return all;

    return all.where((p) {
      bool ok = true;

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

  // ============================================================================
  // 리마인더
  // ============================================================================

  Future<void> putReminder(PolicyReminderIsarModel model) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyReminderIsarModels.put(model);
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
      String policyId) async {
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
}
