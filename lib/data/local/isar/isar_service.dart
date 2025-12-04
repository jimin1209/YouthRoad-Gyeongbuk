import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/policy_filter.dart';
import 'policy_isar_model.dart';
import '../../../features/policy_new/data/local/isar/policy_reminder_isar_model.dart';

class IsarService {
  Isar? _isar;
  bool _opening = false;

  /// Lazy singleton instance
  Future<Isar> get instance async {
    if (_isar != null) return _isar!;
    if (_opening) {
      await Future.delayed(const Duration(milliseconds: 50));
      return instance;
    }
    _isar = await _openIsar();
    return _isar!;
  }

  /// Isar DB 오픈 (스키마 mismatch 자동 복구 포함)
  Future<Isar> _openIsar() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    _opening = true;

    final dir = await getApplicationSupportDirectory();
    final path = dir.path;

    if (kDebugMode) {
      debugPrint('[IsarService] Open DB at $path');
    }

    try {
      // === 첫 번째 시도 ===
      return await Isar.open(
        [
          PolicyIsarModelSchema,
          PolicyReminderIsarModelSchema,
        ],
        directory: path,
        inspector: kDebugMode,
      );
    } catch (e) {
      final msg = e.toString();
      debugPrint("[IsarService] First open failed: $msg");

      final isSchemaMismatch = msg.contains("Collection id is invalid") ||
          msg.contains("IllegalArg") ||
          msg.contains("LateInitializationError");

      if (isSchemaMismatch) {
        debugPrint(
            "[IsarService] Detected schema mismatch → Resetting Isar DB...");

        // 기존 .isar 파일 삭제
        final dirObj = Directory(path);
        if (await dirObj.exists()) {
          await for (final f in dirObj.list()) {
            if (f.path.contains(".isar")) {
              debugPrint("[IsarService] Deleting ${f.path}");
              await f.delete();
            }
          }
        }

        // === 재시도 ===
        final reopened = await Isar.open(
          [
            PolicyIsarModelSchema,
            PolicyReminderIsarModelSchema,
          ],
          directory: path,
          inspector: kDebugMode,
        );

        _opening = false;
        return reopened;
      }

      _opening = false;
      rethrow;
    }
  }

  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }

  // ==============================
  // 전체 정책 조회
  // ==============================
  Future<List<PolicyIsarModel>> getAllPolicies() async {
    final isar = await instance;
    return await isar.policyIsarModels.where().findAll();
  }

  // ==============================
  // 필터 기반 조회
  // ==============================
  Future<List<PolicyIsarModel>> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    final isar = await instance;

    final all = await isar.policyIsarModels.where().findAll();

    var andList = all.where((p) {
      bool ok = true;

      if (filter.searchPolicyNm != null && filter.searchPolicyNm!.isNotEmpty) {
        final q = filter.searchPolicyNm!.toLowerCase();
        ok = ok && p.policyNm.toLowerCase().contains(q);
      }

      if (filter.searchRgnSe != null && filter.searchRgnSe!.isNotEmpty) {
        final region = filter.searchRgnSe!.toLowerCase();
        ok = ok && (p.rgnSeNm != null && p.rgnSeNm!.toLowerCase() == region);
      }

      if (filter.category != null && filter.category!.isNotEmpty) {
        final cat = filter.category!.toLowerCase();
        ok = ok &&
            (p.policyTypeNm != null && p.policyTypeNm!.toLowerCase() == cat);
      }

      if (filter.searchYear != null && filter.searchYear!.isNotEmpty) {
        ok = ok && p.policyYr == filter.searchYear;
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

      return ok;
    }).toList();

    if ((filter.searchText != null && filter.searchText!.isNotEmpty) ||
        filter.availableOnly == true) {
      final t = filter.searchText?.toLowerCase();
      andList = andList.where((p) {
        bool orOk = false;

        if (t != null && t.isNotEmpty) {
          final title = p.policyNm.toLowerCase();
          final content = (p.policyCn ?? '').toLowerCase();
          if (title.contains(t) || content.contains(t)) {
            orOk = true;
          }
        }

        if (filter.availableOnly == true) {
          if (p.isApplyNow == true || p.isOngoing == true) {
            orOk = true;
          }
        }

        return orOk;
      }).toList();
    }

    final pageIndex = (filter.pageIndex ?? 1).clamp(1, 9999);
    final pageSize = filter.recordCount ?? 50;
    final offset = (pageIndex - 1) * pageSize;

    if (offset >= andList.length) {
      return [];
    }

    return andList.skip(offset).take(pageSize).toList();
  }

  // ==============================
  // 단일 조회
  // ==============================
  Future<PolicyIsarModel?> getPolicyById(String id) async {
    final isar = await instance;
    return await isar.policyIsarModels.filter().policyIdEqualTo(id).findFirst();
  }

  // ==============================
  // 전체 넣기
  // ==============================
  Future<void> putAllPolicies(List<PolicyIsarModel> list) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.putAll(list);
    });
  }

  // ==============================
  // 전체 삭제
  // ==============================
  Future<void> clearPolicies() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
    });
  }

  // ==============================
  // 리마인더 CRUD
  // ==============================
  Future<void> putReminder(PolicyReminderIsarModel reminder) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyReminderIsarModels.put(reminder);
    });
  }

  Future<void> putAllReminders(List<PolicyReminderIsarModel> reminders) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.policyReminderIsarModels.putAll(reminders);
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
      for (final target in targets) {
        await isar.policyReminderIsarModels.delete(target.isarId);
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

  Future<List<PolicyReminderIsarModel>> getAllReminders() async {
    final isar = await instance;
    return isar.policyReminderIsarModels.where().findAll();
  }
}
