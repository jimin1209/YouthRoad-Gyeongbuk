// FILE: lib/presentation/search/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/search/controllers/search_controller.dart';
import '../../../application/search/controllers/search_history_controller.dart';
import '../../../application/search/providers.dart';
import '../../../domain/search/entities/search_category.dart';
import '../../../domain/search/entities/search_result_item.dart';
import '../widgets/search_bar.dart';
import '../widgets/search_result_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final suggestionState = ref.watch(searchSuggestionControllerProvider);
    final historyState = ref.watch(searchHistoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                controller: _controller,
                onChanged: _onQueryChanged,
                onSubmitted: (_) => _onSubmit(),
                onClear: _clearQuery,
              ),
              const SizedBox(height: 12),
              _CategoryFilters(
                selected: searchState.query.category,
                onSelected: (category) {
                  ref.read(searchControllerProvider.notifier).setCategory(category);
                },
              ),
              const SizedBox(height: 8),
              _SuggestionSection(
                suggestions: (suggestionState.valueOrNull ?? const [])
                    .map((e) => e.text)
                    .toList(),
                onTap: (value) {
                  _controller.text = value;
                  _controller.selection =
                      TextSelection.collapsed(offset: value.length);
                  _onSubmit();
                },
                isLoading: suggestionState.isLoading,
              ),
              const SizedBox(height: 12),
              _HistorySection(
                state: historyState,
                onSelect: (value) {
                  _controller.text = value;
                  _controller.selection =
                      TextSelection.collapsed(offset: value.length);
                  _onSubmit();
                },
                onDelete: (value) {
                  ref.read(searchHistoryControllerProvider.notifier).remove(value);
                },
                onClear: () {
                  ref.read(searchHistoryControllerProvider.notifier).clear();
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildResultArea(context, searchState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQueryChanged(String value) {
    ref.read(searchControllerProvider.notifier).updateQuery(value);
    ref.read(searchSuggestionControllerProvider.notifier).request(value);
  }

  void _onSubmit() {
    ref.read(searchControllerProvider.notifier).refresh();
    ref.read(searchSuggestionControllerProvider.notifier).request('');
  }

  void _clearQuery() {
    _controller.clear();
    ref.read(searchControllerProvider.notifier).updateQuery('');
    ref.read(searchSuggestionControllerProvider.notifier).request('');
  }

  Widget _buildResultArea(BuildContext context, SearchState searchState) {
    switch (searchState.status) {
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.empty:
        return const Center(child: Text('검색 결과가 없습니다.'));
      case SearchStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(searchState.errorMessage ?? '검색 중 오류가 발생했습니다.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.read(searchControllerProvider.notifier).refresh(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        );
      case SearchStatus.success:
      case SearchStatus.idle:
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.extentAfter < 300 &&
                !searchState.isLoadingMore) {
              ref.read(searchControllerProvider.notifier).loadNextPage();
            }
            return false;
          },
          child: Stack(
            children: [
              SearchResultList(
                items: searchState.results,
                onItemTap: _onResultTap,
              ),
              if (searchState.isLoadingMore)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        );
    }
  }

  void _onResultTap(SearchResultItem item) {
    // KakaoMap 연동 시 이 지점을 활용합니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('선택한 항목: ${item.title}')),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.selected,
    required this.onSelected,
  });

  final SearchCategory selected;
  final ValueChanged<SearchCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: SearchCategory.values
          .where((category) => category != SearchCategory.all)
          .map(
            (category) => ChoiceChip(
              label: Text(category.label),
              selected: selected == category,
              onSelected: (_) => onSelected(category),
            ),
          )
          .toList(),
    );
  }
}

class _SuggestionSection extends StatelessWidget {
  const _SuggestionSection({
    required this.suggestions,
    required this.onTap,
    required this.isLoading,
  });

  final List<String> suggestions;
  final ValueChanged<String> onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LinearProgressIndicator();
    }
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ActionChip(
            label: Text(suggestion),
            onPressed: () => onTap(suggestion),
          );
        },
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
    required this.state,
    required this.onSelect,
    required this.onDelete,
    required this.onClear,
  });

  final SearchHistoryState state;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onDelete;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const LinearProgressIndicator();
    }

    if (state.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('최근 검색어'),
            TextButton(
              onPressed: onClear,
              child: const Text('전체 삭제'),
            ),
          ],
        ),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return InputChip(
                label: Text(item.query),
                onDeleted: () => onDelete(item.query),
                deleteIcon: const Icon(Icons.close),
                deleteButtonTooltipMessage: '삭제',
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.grey.shade200,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () => onSelect(item.query),
              );
            },
          ),
        ),
      ],
    );
  }
}
