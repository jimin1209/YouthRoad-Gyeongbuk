import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/models/department_model.dart';
import '../repository_providers.dart';

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
    final repository = ref.read(deptRepositoryProvider);
    final items = await repository.getDepartments(
      instId: _instId,
      keyword: _keyword.isEmpty ? null : _keyword,
    );
    return items;
  }
}
