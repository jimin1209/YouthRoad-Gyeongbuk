import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/models/department_model.dart';
import '../../data/repositories/dept_repository_impl.dart';
import '../../data/sources/remote/department_remote_source.dart';
import '../di.dart';

final departmentNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    DepartmentNotifier, List<DepartmentModel>, String>(
  DepartmentNotifier.new,
);

class DepartmentNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<DepartmentModel>, String> {
  late String _instId;
  String _keyword = '';

  @override
  FutureOr<List<DepartmentModel>> build(String arg) {
    _instId = arg;
    return _fetch();
  }

  Future<void> search(String keyword) async {
    _keyword = keyword;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<DepartmentModel>> _fetch() async {
    final dio = ref.read(dioProvider);
    final repository = DeptRepositoryImpl(null, DepartmentRemoteSource(dio));
    final items = await repository.getDepartments(
      instId: _instId,
      keyword: _keyword.isEmpty ? null : _keyword,
    );
    return items;
  }
}
