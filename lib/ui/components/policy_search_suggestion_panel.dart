import 'package:flutter/material.dart';

enum PolicySearchUiMode { idle, typing, none }

class PolicySearchSuggestionPanel extends StatelessWidget {
  const PolicySearchSuggestionPanel({
    super.key,
    required this.mode,
    required this.highlight,
    required this.recentQueries,
    required this.popularKeywords,
    required this.categoryKeywords,
    required this.liveSuggestions,
    required this.isLoadingSuggestions,
    required this.onSelect,
    required this.onRemoveRecent,
    required this.onClearRecent,
    required this.onCategoryTap,
  });

  final PolicySearchUiMode mode;
  final String highlight;
  final List<String> recentQueries;
  final List<String> popularKeywords;
  final List<String> categoryKeywords;
  final List<String> liveSuggestions;
  final bool isLoadingSuggestions;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemoveRecent;
  final VoidCallback onClearRecent;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final shouldShow = mode != PolicySearchUiMode.none;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: shouldShow
          ? _SuggestionBody(
              mode: mode,
              highlight: highlight,
              recentQueries: recentQueries,
              popularKeywords: popularKeywords,
              categoryKeywords: categoryKeywords,
              liveSuggestions: liveSuggestions,
              isLoadingSuggestions: isLoadingSuggestions,
              onSelect: onSelect,
              onRemoveRecent: onRemoveRecent,
              onClearRecent: onClearRecent,
              onCategoryTap: onCategoryTap,
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SuggestionBody extends StatelessWidget {
  const _SuggestionBody({
    required this.mode,
    required this.highlight,
    required this.recentQueries,
    required this.popularKeywords,
    required this.categoryKeywords,
    required this.liveSuggestions,
    required this.isLoadingSuggestions,
    required this.onSelect,
    required this.onRemoveRecent,
    required this.onClearRecent,
    required this.onCategoryTap,
  });

  final PolicySearchUiMode mode;
  final String highlight;
  final List<String> recentQueries;
  final List<String> popularKeywords;
  final List<String> categoryKeywords;
  final List<String> liveSuggestions;
  final bool isLoadingSuggestions;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemoveRecent;
  final VoidCallback onClearRecent;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(mode),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mode == PolicySearchUiMode.idle) ...[
              _SectionHeader(
                title: '최근 검색어',
                actionLabel: '전체 삭제',
                onAction: recentQueries.isEmpty ? null : onClearRecent,
              ),
              const SizedBox(height: 8),
              _ChipWrap(
                items: recentQueries,
                onSelect: onSelect,
                onRemove: onRemoveRecent,
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: '추천 검색어'),
              const SizedBox(height: 8),
              _ChipWrap(
                items: popularKeywords,
                onSelect: onSelect,
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: '카테고리 추천'),
              const SizedBox(height: 8),
              _ChipWrap(
                items: categoryKeywords,
                onSelect: onCategoryTap,
              ),
            ],
            if (mode == PolicySearchUiMode.typing) ...[
              _SectionHeader(title: '자동완성'),
              const SizedBox(height: 8),
              if (isLoadingSuggestions)
                const LinearProgressIndicator(minHeight: 2)
              else if (liveSuggestions.isEmpty)
                const Text('입력한 검색어와 관련된 추천어가 없습니다.')
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: liveSuggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final suggestion = liveSuggestions[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.search, size: 18),
                      title: _HighlightText(
                        base: suggestion,
                        highlight: highlight,
                      ),
                      onTap: () => onSelect(suggestion),
                    );
                  },
                ),
              const SizedBox(height: 16),
              _SectionHeader(
                title: '최근 검색어',
                actionLabel: '전체 삭제',
                onAction: recentQueries.isEmpty ? null : onClearRecent,
              ),
              const SizedBox(height: 8),
              _ChipWrap(
                items: recentQueries,
                onSelect: onSelect,
                onRemove: onRemoveRecent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({
    required this.items,
    required this.onSelect,
    this.onRemove,
  });

  final List<String> items;
  final ValueChanged<String> onSelect;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('표시할 항목이 없습니다.');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return InputChip(
          label: Text(item),
          onPressed: () => onSelect(item),
          onDeleted: onRemove != null ? () => onRemove!(item) : null,
          deleteIcon: onRemove != null ? const Icon(Icons.close, size: 16) : null,
        );
      }).toList(),
    );
  }
}

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.base,
    required this.highlight,
  });

  final String base;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    final query = highlight.trim();
    if (query.isEmpty) {
      return Text(base);
    }

    final lowerBase = base.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerBase.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(base);
    }

    final endIndex = startIndex + query.length;
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          if (startIndex > 0) TextSpan(text: base.substring(0, startIndex)),
          TextSpan(
            text: base.substring(startIndex, endIndex),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (endIndex < base.length) TextSpan(text: base.substring(endIndex)),
        ],
      ),
    );
  }
}
