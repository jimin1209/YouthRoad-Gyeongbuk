import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/policy_filter.dart';
import 'policy_isar_model.dart';
import '../../../features/policy_new/data/local/isar/policy_reminder_isar_model.dart';

class IsarService {
  Isar? _isar;

  /// Lazy singleton instance
  Future<Isar> get instance async => _isar ??= await _openIsar();

  /// Isar DB 오픈
  Future<Isar> _openIsar() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final dir = await getApplicationSupportDirectory();

    if (kDebugMode) {
      debugPrint('[IsarService] Open DB at ${dir.path}');
    }

    return await Isar.open(
      [
        PolicyIsarModelSchema,
        PolicyReminderIsarModelSchema,
      ],
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

  // ==============================
  // 전체 정책 조회
  // ==============================
  Future<List<PolicyIsarModel>> getAllPolicies() async {
    final isar = await instance;
    // 이 라인은 기존에도 잘 돌아가던 패턴이라 그대로 둠
    return await isar.policyIsarModels.where().findAll();
  }

  // ==============================
  // 필터 기반 조회 (in-memory 필터링)
  // ==============================
  Future<List<PolicyIsarModel>> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    final isar = await instance;

    // 1) 먼저 전체 로드 (Isar 쿼리는 여기서 한 번만 사용)
    final all = await isar.policyIsarModels.where().findAll();

    // 2) AND 조건 필터링 (Dart 리스트에서 필터)
    var andList = all.where((p) {
      bool ok = true;

      // 제목 검색 (searchPolicyNm)
      if (filter.searchPolicyNm != null && filter.searchPolicyNm!.isNotEmpty) {
        final q = filter.searchPolicyNm!.toLowerCase();
        ok = ok && p.policyNm.toLowerCase().contains(q);
      }

      // 지역 (searchRgnSe)
      if (filter.searchRgnSe != null && filter.searchRgnSe!.isNotEmpty) {
        final region = filter.searchRgnSe!.toLowerCase();
        ok = ok && (p.rgnSeNm != null && p.rgnSeNm!.toLowerCase() == region);
      }

      // 카테고리 (category)
      if (filter.category != null && filter.category!.isNotEmpty) {
        final cat = filter.category!.toLowerCase();
        ok = ok &&
            (p.policyTypeNm != null && p.policyTypeNm!.toLowerCase() == cat);
      }

      // 연도 (searchYear)
      if (filter.searchYear != null && filter.searchYear!.isNotEmpty) {
        ok = ok && p.policyYr == filter.searchYear;
      }

      // 시작일 (policyBgngYmd >= startDate)
      if (filter.startDate != null) {
        final start = filter.startDate!;
        ok = ok &&
            (p.policyBgngYmd != null &&
                !p.policyBgngYmd!.isBefore(start)); // >=
      }

      // 종료일 (policyEndYmd <= endDate)
      if (filter.endDate != null) {
        final end = filter.endDate!;
        ok = ok &&
            (p.policyEndYmd != null && !p.policyEndYmd!.isAfter(end)); // <=
      }

      return ok;
    }).toList();

    // 3) OR 조건 (searchText, availableOnly)
    //    - 원래 로직: AND 결과(andResult) ∩ OR 결과(orSet)
    //    - 여기서는 andList에 대해 OR 조건을 적용
    if ((filter.searchText != null && filter.searchText!.isNotEmpty) ||
        filter.availableOnly == true) {
      final t = filter.searchText?.toLowerCase();
      andList = andList.where((p) {
        bool orOk = false;

        // 검색어: 제목 + 내용
        if (t != null && t.isNotEmpty) {
          final title = p.policyNm.toLowerCase();
          final content = (p.policyCn ?? '').toLowerCase();
          if (title.contains(t) || content.contains(t)) {
            orOk = true;
          }
        }

        // 신청 가능 (isApplyNow || isOngoing)
        if (filter.availableOnly == true) {
          if (p.isApplyNow == true || p.isOngoing == true) {
            orOk = true;
          }
        }

        return orOk;
      }).toList();
    }

    // 4) 페이지네이션
    final pageIndex = (filter.pageIndex ?? 1).clamp(1, 9999);
    final pageSize = filter.recordCount ?? 50;
    final offset = (pageIndex - 1) * pageSize;

    if (offset >= andList.length) {
      return [];
    }

    return andList.skip(offset).take(pageSize).toList();
  }

  // ==============================
  // 단일 정책 조회
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
