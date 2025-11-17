import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bookmark_local_datasource.dart';
import '../../policy/data/models/policy.dart';

final bookmarkDataSourceProvider =
    Provider<BookmarkLocalDataSource>((ref) => BookmarkLocalDataSource());

final bookmarkControllerProvider =
    NotifierProvider<BookmarkController, List<Policy>>(BookmarkController.new);

class BookmarkController extends Notifier<List<Policy>> {
  late final BookmarkLocalDataSource _dataSource;

  @override
  List<Policy> build() {
    _dataSource = ref.watch(bookmarkDataSourceProvider);
    return _dataSource.getBookmarks();
  }

  void toggle(Policy policy) {
    _dataSource.toggleBookmark(policy);
    state = _dataSource.getBookmarks();
  }
}
