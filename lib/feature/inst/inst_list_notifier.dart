import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/result.dart';
import '../../data/model/inst_models.dart';
import '../../data/repository/youth_policy_repository.dart';

class InstListNotifier extends StateNotifier<AsyncValue<List<InstItem>>> {
  InstListNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetch();
  }

  final Ref _ref;
  String _keyword = '';

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    final repo = _ref.read(youthPolicyRepositoryProvider);
    final result = await repo.fetchInstList(srchInstNm: _keyword.isEmpty ? null : _keyword);
    result.when(
      success: (data) => state = AsyncValue.data(data.resultList),
      failure: (err) => state = AsyncValue.error(err.message, err.stackTrace ?? StackTrace.current),
    );
  }

  void setKeyword(String keyword) {
    _keyword = keyword;
    fetch();
  }
}

final instListProvider =
    StateNotifierProvider<InstListNotifier, AsyncValue<List<InstItem>>>(
  (ref) => InstListNotifier(ref),
);
