// lib/data/local/isar/isar_service.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/policy_filter.dart';
import 'policy_isar_model.dart';
import '../../../features/policy_new/data/local/isar/policy_reminder_isar_model.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// 🔵 전역 Isar Singleton — 절대 중복 오픈 방지
/// ─────────────────────────────────────────────────────────────────────────────
Isar? _globalIsar;
Completer<Isar>? _openCompleter;

const _dbName = 'default';
const _schemas = <CollectionSchema>[
  PolicyIsarModelSchema,
  PolicyReminderIsarModelSchema,
];

class IsarService {
  const IsarService();

  /// ---------------------------------------------------------------------------
  /// public getter — 전역 단일 인스턴스 보장
  /// ---------------------------------------------------------------------------
  Future<Isar> get instance async {
    // 이미 열린 상태이면 바로 리턴
    if (_globalIsar != null) {
      debugPrint('[ISAR] EXISTING INSTANCE REUSED');
      return _globalIsar!;
    }

    // 누군가 열고 있다면 기다림
    if (_openCompleter != null) {
      return _openCompleter!.future;
    }

    // 첫 호출 → open 시작
    debugPrint('[ISAR] OPENING FIRST INSTANCE');
    _openCompleter = Completer<Isar>();
    try {
      final isar = await _openInternal();
      _globalIsar = isar;

      _openCompleter!.complete(isar);
      return isar;
    } catch (e, st) {
      if (!(_openCompleter!.isCompleted)) {
        _openCompleter!.completeError(e, st);
      }
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// 내부 진짜 open 함수 — 오직 여기서만 open() 발생
  /// ---------------------------------------------------------------------------
  Future<Isar> _openInternal() async {
    final dir = await getApplicationSupportDirectory();
    final path = dir.path;

    debugPrint('[IsarService] Opening DB at $path');

    // 이미 같은 이름의 DB가 떠있음 → 재사용
    if (Isar.instanceNames.contains(_dbName)) {
      final existing = Isar.getInstance(_dbName);
      if (existing != null) {
        debugPrint('[ISAR] EXISTING INSTANCE REUSED');
        return existing;
      }
    }

    try {
      return await Isar.open(
        _schemas,
        directory: path,
        name: _dbName,
        inspector: kDebugMode,
      );
    } on IsarError catch (e) {
      final message = e.message ?? e.toString();

      // 이미 열려있다는 에러는 무조건 재사용
      if (message.contains('Instance has already been opened')) {
        final existing = Isar.getInstance(_dbName);
        if (existing != null) return existing;
      }

      // 스키마 mismatch → DB 삭제 후 다시 시도
      if (message.contains('Collection id is invalid')) {
        final dbFile = File('$path/$_dbName.isar');
        final lockFile = File('$path/$_dbName.isar.lock');

        if (await lockFile.exists()) await lockFile.delete();
        if (await dbFile.exists()) await dbFile.delete();

        return await Isar.open(
          _schemas,
          directory: path,
          name: _dbName,
          inspector: kDebugMode,
        );
      }

      rethrow;
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // 정책 캐시
  // ────────────────────────────────────────────────────────────────────────────

  Future<List<PolicyIsarModel>> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    final isar = await instance;
    final all = await isar.policyIsarModels.where().findAll();

    return all.where((p) {
      bool ok = true;

      if (filter.searchPolicyNm?.isNotEmpty == true) {
        final q = filter.searchPolicyNm!.toLowerCase();
        ok = ok && p.policyNm.toLowerCase().contains(q);
      }

      if (filter.searchRgnSe?.isNotEmpty == true) {
        final region = filter.searchRgnSe!.toLowerCase();
        ok = ok && (p.rgnSeNm?.toLowerCase() == region);
      }

      if (filter.category?.isNotEmpty == true) {
        final cat = filter.category!.toLowerCase();
        ok = ok && (p.policyTypeNm?.toLowerCase() == cat);
      }

      if (filter.searchYear?.isNotEmpty == true) {
        ok = ok && (p.policyYr == filter.searchYear);
      }

      if (filter.startDate != null) {
        ok = ok &&
            (p.policyBgngYmd != null &&
                !p.policyBgngYmd!.isBefore(filter.startDate!));
      }

      if (filter.endDate != null) {
        ok = ok &&
            (p.policyEndYmd != null &&
                !p.policyEndYmd!.isAfter(filter.endDate!));
      }

      if (filter.availableOnly == true) {
        ok = ok && (p.isApplyNow == true || p.isOngoing == true);
      }

      return ok;
    }).toList();
  }

  Future<List<PolicyIsarModel>> getAllPolicies() async {
    final isar = await instance;
    return isar.policyIsarModels.where().findAll();
  }

  Future<PolicyIsarModel?> getPolicyById(String id) async {
    final isar = await instance;
    return isar.policyIsarModels.filter().policyIdEqualTo(id).findFirst();
  }

  Future<void> putAllPolicies(List<PolicyIsarModel> policies) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
      await isar.policyIsarModels.putAll(policies);
    });
  }

  Future<void> clearPolicies() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
    });
  }

  // ────────────────────────────────────────────────────────────────────────────
  // 리마인더 캐시
  // ────────────────────────────────────────────────────────────────────────────

  Future<List<PolicyReminderIsarModel>> getAllReminders() async {
    final isar = await instance;
    return isar.policyReminderIsarModels.where().findAll();
  }

  Future<void> putAllReminders(List<PolicyReminderIsarModel> reminders) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyReminderIsarModels.putAll(reminders);
    });
  }

  Future<void> putReminder(PolicyReminderIsarModel reminder) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyReminderIsarModels.put(reminder);
    });
  }

  Future<void> deleteReminderById(String reminderId) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      final target = await isar.policyReminderIsarModels
          .where()
          .reminderIdEqualTo(reminderId)
          .findFirst();

      if (target != null) {
        await isar.policyReminderIsarModels.delete(target.isarId);
      }
    });
  }

  Future<void> deleteRemindersByPolicy(String policyId) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      final targets = await isar.policyReminderIsarModels
          .where()
          .policyIdEqualTo(policyId)
          .findAll();

      for (final t in targets) {
        await isar.policyReminderIsarModels.delete(t.isarId);
      }
    });
  }

  Future<PolicyReminderIsarModel?> getReminder(String reminderId) async {
    final isar = await instance;
    return isar.policyReminderIsarModels
        .where()
        .reminderIdEqualTo(reminderId)
        .findFirst();
  }

  Future<List<PolicyReminderIsarModel>> getRemindersForPolicy(
      String policyId) async {
    final isar = await instance;
    return isar.policyReminderIsarModels
        .where()
        .policyIdEqualTo(policyId)
        .findAll();
  }

  Future<void> clearAll() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
      await isar.policyReminderIsarModels.clear();
    });
  }

  Future<void> close() async {
    final isar = _globalIsar;
    if (isar != null && isar.isOpen) {
      await isar.close();
    }
    _globalIsar = null;
    _openCompleter = null;
  }
}
