import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../compare/widgets/compare_entry_bar.dart';
import '../widgets/policy_feed_list_view.dart';
import '../compare/policy_compare_screen.dart';

class PolicyFeedTab extends ConsumerStatefulWidget {
  const PolicyFeedTab({
    super.key,
    required this.feedType,
    this.enableSearch = false,
  });

  final PolicyFeedType feedType;
  final bool enableSearch;

  @override
  ConsumerState<PolicyFeedTab> createState() => _PolicyFeedTabState();
}

class _PolicyFeedTabState extends ConsumerState<PolicyFeedTab>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final ui = ref.read(policyFilterUiStateProvider);
    _searchController = TextEditingController(text: ui.keyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ui = ref.watch(policyFilterUiStateProvider);
    final compareState = ref.watch(compareRepositoryProvider);
    final compareCount = compareState.ids.length;

    // 🔵 보관함 탭인지 여부만으로 하단 바 노출 여부 결정
    final feedType = widget.feedType;
    final isFavoriteTab = feedType == PolicyFeedType.favorite;
    final showCompareBar = isFavoriteTab;

    debugPrint(
      '[PolicyFeedTab] feedType=$feedType, compareCount=$compareCount, showCompareBar=$showCompareBar',
    );

    // 검색어 컨트롤러 동기화
    if (_searchController.text != ui.keyword) {
      _searchController.text = ui.keyword;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    final content = PolicyFeedListView(feedType: widget.feedType);

    // 검색 비활성 모드 (추천/보관함)
    if (!widget.enableSearch) {
      return Column(
        children: [
          Expanded(child: content),
          if (showCompareBar)
            SafeArea(
              top: false,
              child: CompareEntryBar(
                itemCount: compareCount,
                onOpenCompare: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PolicyCompareScreen(),
                    ),
                  );
                },
              ),
            ),
        ],
      );
    }

    // 검색 활성 모드 (검색 탭 등)
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '검색어를 입력하세요',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _updateKeyword(_searchController.text),
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _updateKeyword,
          ),
        ),
        Expanded(child: content),
        if (showCompareBar)
          SafeArea(
            top: false,
            child: CompareEntryBar(
              itemCount: compareCount,
              onOpenCompare: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PolicyCompareScreen(),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _updateKeyword(String value) {
    ref.read(policyFilterUiStateProvider.notifier).setKeyword(value.trim());
  }

  @override
  bool get wantKeepAlive => true;
}
