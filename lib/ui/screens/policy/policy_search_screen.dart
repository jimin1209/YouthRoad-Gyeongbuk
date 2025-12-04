import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/search/controllers/search_controller.dart';
import '../../../application/search/controllers/search_history_controller.dart';
import '../../../application/search/controllers/search_suggestion_controller.dart';
import '../../../application/search/providers.dart';
import '../../../domain/search/entities/search_category.dart';
import '../../../domain/search/entities/search_result_item.dart';
import '../../components/policy_search_suggestion_panel.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';
import '../../../presentation/search/widgets/search_result_list.dart';

class PolicySearchScreen extends ConsumerStatefulWidget {
  const PolicySearchScreen({super.key});

  @override
  ConsumerState<PolicySearchScreen> createState() => _PolicySearchScreenState();
}

class _PolicySearchScreenState extends ConsumerState<PolicySearchScreen> {
  static const _debounceDuration = Duration(milliseconds: 300);
  static const _categoryKeywords = <String>[
    '주거 지원',
    '취업 지원',
    '창업 지원',
    '교육/훈련',
    '금융 지원',
  ];

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final suggestionState = ref.watch(searchSuggestionControllerProvider);
    final historyState = ref.watch(searchHistoryControllerProvider);
    final popularKeywords = ref.watch(popularSearchKeywordListProvider);

    final mode = _resolveMode();
    final liveSuggestions = suggestionState.valueOrNull ?? const [];

    return Scaffold(
      appBar: const AppAppBar(title: '정책 검색'),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: _buildSearchField(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PolicySearchSuggestionPanel(
                  mode: mode,
                  highlight: _controller.text,
                  recentQueries:
                      historyState.items.map((item) => item.query).toList(),
                  popularKeywords: popularKeywords.valueOrNull ?? const [],
                  categoryKeywords: _categoryKeywords,
                  liveSuggestions: liveSuggestions.map((e) => e.text).toList(),
                  isLoadingSuggestions: suggestionState.isLoading,
                  onSelect: _onSelectSuggestion,
                  onRemoveRecent: _onRemoveRecent,
                  onClearRecent: _onClearRecent,
                  onCategoryTap: _onTapCategory,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildResultArea(context, searchState),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: '정책명을 검색하세요',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearQuery,
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onChanged: _onQueryChanged,
      onSubmitted: (_) => _submit(),
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildResultArea(BuildContext context, SearchState searchState) {
    switch (searchState.status) {
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.empty:
        return const Center(child: Text('검색 결과가 없습니다.'));
      case SearchStatus.error:
        return GlobalErrorView(
          message: searchState.errorMessage ?? '검색 중 오류가 발생했습니다.',
          onRetry: () => ref.read(searchControllerProvider.notifier).refresh(),
        );
      case SearchStatus.success:
      case SearchStatus.idle:
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.extentAfter < 240 &&
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('선택한 항목: ${item.title}')),
    );
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      ref.read(searchControllerProvider.notifier).updateQuery(value);
      ref.read(searchSuggestionControllerProvider.notifier).request(value);
      setState(() {});
    });
    setState(() {});
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ref.read(searchControllerProvider.notifier).refresh();
    ref.read(searchSuggestionControllerProvider.notifier).request('');
    setState(() {});
  }

  void _clearQuery() {
    _controller.clear();
    ref.read(searchControllerProvider.notifier).updateQuery('');
    ref.read(searchSuggestionControllerProvider.notifier).request('');
    setState(() {});
  }

  void _onSelectSuggestion(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    _submit();
  }

  void _onRemoveRecent(String value) {
    ref.read(searchHistoryControllerProvider.notifier).remove(value);
  }

  void _onClearRecent() {
    ref.read(searchHistoryControllerProvider.notifier).clear();
  }

  void _onTapCategory(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    ref.read(searchControllerProvider.notifier).setCategory(SearchCategory.policy);
    _submit();
  }

  PolicySearchUiMode _resolveMode() {
    if (!_focusNode.hasFocus) {
      return PolicySearchUiMode.none;
    }
    return _controller.text.trim().isEmpty
        ? PolicySearchUiMode.idle
        : PolicySearchUiMode.typing;
  }

  void _handleFocusChange() {
    setState(() {});
  }
}
