import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bookmark_local_datasource.dart';
import '../../policy/data/models/policy.dart';

final bookmarkControllerProvider = AsyncNotifierProvider<BookmarkController, List<Policy>>(
  BookmarkController.new,
);

class BookmarkController extends AsyncNotifier<List<Policy>> {
  late BookmarkLocalDataSource _dataSource;

  @override
  Future<List<Policy>> build() async {
    _dataSource = await BookmarkLocalDataSource.create();
    return _dataSource.getBookmarks();
  }

  Future<void> toggle(Policy policy) async {
    final updated = await _dataSource.toggleBookmark(policy);
    state = AsyncValue.data(updated);
  }

  bool isBookmarked(String policyId) {
    final cached = state.value;
    if (cached != null) {
      return cached.any((policy) => policy.id == policyId);
    }
    return _dataSource.isBookmarked(policyId);
  }
}
