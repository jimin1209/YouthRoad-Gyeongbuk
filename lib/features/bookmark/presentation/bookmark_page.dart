import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/bookmark_controller.dart';
import '../data/bookmark_models.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  BookmarkFolder? _folderFilter;
  BookmarkSortOption _sort = BookmarkSortOption.recent;

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarkControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('북마크')),
      body: bookmarks.when(
        data: (entries) {
          final filtered = _applyFilters(entries);
          return Column(
            children: [
              _FolderFilter(
                selected: _folderFilter,
                onSelected: (folder) => setState(() => _folderFilter = folder),
              ),
              _SortSelector(
                current: _sort,
                onChanged: (sort) => setState(() => _sort = sort),
              ),
              const Divider(),
              if (filtered.isEmpty)
                const Expanded(
                  child: Center(child: Text('선택한 조건에 맞는 북마크가 없습니다.')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      return _BookmarkTile(
                        entry: entry,
                        onMove: (folder) => ref
                            .read(bookmarkControllerProvider.notifier)
                            .moveToFolder(entry.policy.id, folder),
                        onRemove: () => ref
                            .read(bookmarkControllerProvider.notifier)
                            .toggle(entry.policy),
                      );
                    },
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
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

class _FolderFilter extends StatelessWidget {
  const _FolderFilter({required this.selected, required this.onSelected});

  final BookmarkFolder? selected;
  final ValueChanged<BookmarkFolder?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: const Text('전체'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          ...BookmarkFolder.values.map(
            (folder) => ChoiceChip(
              label: Text(folder.label),
              selected: selected == folder,
              onSelected: (_) => onSelected(folder),
            ),
          ),
        ],
      ),
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
