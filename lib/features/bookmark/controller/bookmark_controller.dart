import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bookmark_local_datasource.dart';
import '../data/bookmark_models.dart';
import '../../policy/data/models/policy.dart';

final bookmarkControllerProvider =
    AsyncNotifierProvider<BookmarkController, List<BookmarkEntry>>(
  BookmarkController.new,
);

class BookmarkController extends AsyncNotifier<List<BookmarkEntry>> {
  late BookmarkLocalDataSource _dataSource;

  @override
  Future<List<BookmarkEntry>> build() async {
    _dataSource = await BookmarkLocalDataSource.create();
    return _dataSource.getBookmarkEntries();
  }

  Future<void> toggle(
    Policy policy, {
    BookmarkFolder folder = BookmarkFolder.favorite,
  }) async {
    final updated = await _dataSource.toggleBookmark(policy, folder: folder);
    state = AsyncValue.data(updated);
  }

  Future<void> moveToFolder(String policyId, BookmarkFolder folder) async {
    final updated = await _dataSource.updateFolder(policyId, folder);
    state = AsyncValue.data(updated);
  }

  bool isBookmarked(String policyId) {
    final cached = state.value;
    if (cached != null) {
      return cached.any((entry) => entry.policy.id == policyId);
    }
    return _dataSource.isBookmarked(policyId);
  }

  BookmarkFolder? folderOf(String policyId) {
    return _dataSource.folderOf(policyId);
  }
}
