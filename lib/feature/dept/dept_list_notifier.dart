import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/result.dart';
import '../../data/model/dept_models.dart';
import '../../data/repository/youth_policy_repository.dart';

class DeptListNotifier extends StateNotifier<AsyncValue<List<DeptItem>>> {
  DeptListNotifier(this._ref, this.instNo) : super(const AsyncValue.loading()) {
    fetch();
  }

  final Ref _ref;
  final String instNo;

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    final repo = _ref.read(youthPolicyRepositoryProvider);
    final result = await repo.fetchDeptList(instNo: instNo);
    result.when(
      success: (data) => state = AsyncValue.data(data.resultList),
      failure: (err) => state = AsyncValue.error(err.message, err.stackTrace ?? StackTrace.current),
    );
  }
}

final deptListProvider = StateNotifierProvider.family<DeptListNotifier, AsyncValue<List<DeptItem>>, String>(
  (ref, instNo) => DeptListNotifier(ref, instNo),
);
