import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/api/models/department_model.dart';
import '../models/dept_model.dart';
import '../sources/remote/dept_remote_source.dart';
import '../sources/remote/department_remote_source.dart';
import '../../domain/repositories/dept_repository.dart';

class DeptRepositoryImpl implements DeptRepository {
  DeptRepositoryImpl([this._legacyRemote, DepartmentRemoteSource? remoteSource])
      : _remoteSource = remoteSource ?? DepartmentRemoteSource(Dio());

  final DeptRemoteSource? _legacyRemote;
  final DepartmentRemoteSource _remoteSource;

  @override
  Future<List<DeptModel>> fetchDeptList({required String instNo, String? keyword}) async {
    try {
      final departments = await getDepartments(instId: instNo, keyword: keyword);
      return departments
          .map((dept) => DeptModel(id: dept.id, instNo: instNo, name: dept.deptName, tel: null))
          .toList();
    } catch (e, st) {
      debugPrint('DeptRepositoryImpl.fetchDeptList error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  @override
  Future<List<DepartmentModel>> getDepartments({
    required String instId,
    String? keyword,
  }) async {
    try {
      return await _remoteSource.fetchDepartments(instId: instId, keyword: keyword);
    } catch (e, st) {
      debugPrint('DeptRepositoryImpl.getDepartments error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
