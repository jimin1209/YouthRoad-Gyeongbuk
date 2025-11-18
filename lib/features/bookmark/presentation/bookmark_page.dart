import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../policy/presentation/widgets/policy_card.dart';
import 'package:go_router/go_router.dart';

import '../controller/bookmark_controller.dart';
import '../data/bookmark_models.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage>
    with SingleTickerProviderStateMixin {
  BookmarkFolder? _folderFilter;
  BookmarkSortOption _sort = BookmarkSortOption.recent;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: BookmarkFolder.values.length + 1, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) return;
        setState(() {
          _folderFilter = _tabController.index == 0
              ? null
              : BookmarkFolder.values[_tabController.index - 1];
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarkControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크 보관함'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: '전체'),
            ...BookmarkFolder.values.map((folder) => Tab(text: folder.label)),
          ],
        ),
      ),
      body: bookmarks.when(
        data: (entries) {
          final filtered = _applyFilters(entries);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${filtered.length}개의 정책',
                        style: Theme.of(context).textTheme.titleMedium),
                    _SortSelector(
                      current: _sort,
                      onChanged: (sort) => setState(() => _sort = sort),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyBookmarkState()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 32),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final entry = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Chip(label: Text(entry.folder.label)),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () async {
                                        final action = await _showActionSheet(context);
                                        if (action == null) return;
                                        if (action == _BookmarkAction.remove) {
                                          ref.read(bookmarkControllerProvider.notifier).toggle(entry.policy);
                                        } else {
                                          ref
                                              .read(bookmarkControllerProvider.notifier)
                                              .moveToFolder(entry.policy.id, _actionToFolder(action));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                PolicyCard(policy: entry.policy, margin: EdgeInsets.zero),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const _BookmarkSkeleton(),
        error: (error, _) => Center(child: Text('북마크를 불러오지 못했습니다: $error')),
      ),
    );
  }

  List<BookmarkEntry> _applyFilters(List<BookmarkEntry> entries) {
    final filtered = _folderFilter == null
        ? List<BookmarkEntry>.from(entries)
        : entries
            .where((entry) => entry.folder == _folderFilter)
            .toList();
    switch (_sort) {
      case BookmarkSortOption.recent:
        filtered.sort((a, b) => b.savedAt.compareTo(a.savedAt));
        break;
      case BookmarkSortOption.region:
        filtered.sort((a, b) => a.policy.regionName.compareTo(b.policy.regionName));
        break;
      case BookmarkSortOption.category:
        filtered.sort((a, b) {
          final aCategory = a.policy.categories.isNotEmpty ? a.policy.categories.first : '';
          final bCategory = b.policy.categories.isNotEmpty ? b.policy.categories.first : '';
          return aCategory.compareTo(bCategory);
        });
        break;
    }
    return filtered;
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({required this.current, required this.onChanged});

  final BookmarkSortOption current;
  final ValueChanged<BookmarkSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BookmarkSortOption>(
      initialValue: current,
      tooltip: '정렬 기준',
      onSelected: onChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: BookmarkSortOption.recent,
          child: Text('최근 저장 순'),
        ),
        PopupMenuItem(
          value: BookmarkSortOption.region,
          child: Text('지역 순'),
        ),
        PopupMenuItem(
          value: BookmarkSortOption.category,
          child: Text('카테고리 순'),
        ),
      ],
      child: Chip(
        label: Text(
          switch (current) {
            BookmarkSortOption.recent => '최근순',
            BookmarkSortOption.region => '지역순',
            BookmarkSortOption.category => '카테고리순',
          },
        ),
        avatar: const Icon(Icons.sort, size: 18),
      ),
    );
  }
}

class _EmptyBookmarkState extends StatelessWidget {
  const _EmptyBookmarkState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border,
              size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          const Text('선택한 폴더에 저장된 정책이 없습니다.'),
          const SizedBox(height: 4),
          Text(
            '관심 정책을 북마크하면 여기에서 빠르게 찾을 수 있어요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

enum _BookmarkAction { favorite, planning, pending, remove }

Future<_BookmarkAction?> _showActionSheet(BuildContext context) {
  return showModalBottomSheet<_BookmarkAction>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...BookmarkFolder.values.map(
            (folder) => ListTile(
              title: Text('${folder.label} 폴더로 이동'),
              onTap: () => Navigator.of(context).pop(
                _BookmarkAction.values.firstWhere((action) => action.name == folder.name),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('삭제'),
            onTap: () => Navigator.of(context).pop(_BookmarkAction.remove),
          ),
        ],
      ),
    ),
  );
}

BookmarkFolder _actionToFolder(_BookmarkAction action) {
  switch (action) {
    case _BookmarkAction.favorite:
      return BookmarkFolder.favorite;
    case _BookmarkAction.planning:
      return BookmarkFolder.planning;
    case _BookmarkAction.pending:
      return BookmarkFolder.pending;
    case _BookmarkAction.remove:
      throw ArgumentError('삭제 액션은 폴더로 변환할 수 없습니다.');
  }
}

class _BookmarkSkeleton extends StatelessWidget {
  const _BookmarkSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        PolicyCardSkeleton(),
        PolicyCardSkeleton(),
        PolicyCardSkeleton(),
      ],
    );
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({required this.current, required this.onChanged});

  final BookmarkSortOption current;
  final ValueChanged<BookmarkSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('정렬', style: Theme.of(context).textTheme.labelLarge),
          DropdownButton<BookmarkSortOption>(
            value: current,
            items: const [
              DropdownMenuItem(
                value: BookmarkSortOption.recent,
                child: Text('최근 저장 순'),
              ),
              DropdownMenuItem(
                value: BookmarkSortOption.region,
                child: Text('지역 순'),
              ),
              DropdownMenuItem(
                value: BookmarkSortOption.category,
                child: Text('카테고리 순'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  const _BookmarkTile({
    required this.entry,
    required this.onMove,
    required this.onRemove,
  });

  final BookmarkEntry entry;
  final ValueChanged<BookmarkFolder> onMove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(entry.policy.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.policy.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('${entry.folder.label} • ${entry.policy.regionName}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        trailing: PopupMenuButton<_BookmarkAction>(
          onSelected: (action) {
            if (action == _BookmarkAction.remove) {
              onRemove();
            } else {
              onMove(_actionToFolder(action));
            }
          },
          itemBuilder: (context) => [
            ...BookmarkFolder.values.map(
              (folder) => PopupMenuItem<_BookmarkAction>(
                value: _BookmarkAction.values
                    .firstWhere((action) => action.name == folder.name),
                child: Text('${folder.label} 폴더로 이동'),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<_BookmarkAction>(
              value: _BookmarkAction.remove,
              child: Text('삭제'),
            ),
          ],
        ),
        onTap: () => context.push('/home/policy/${entry.policy.id}'),
      ),
    );
  }

  BookmarkFolder _actionToFolder(_BookmarkAction action) {
    switch (action) {
      case _BookmarkAction.favorite:
        return BookmarkFolder.favorite;
      case _BookmarkAction.planning:
        return BookmarkFolder.planning;
      case _BookmarkAction.pending:
        return BookmarkFolder.pending;
      case _BookmarkAction.remove:
        return entry.folder;
    }
  }
}

enum _BookmarkAction { favorite, planning, pending, remove }
