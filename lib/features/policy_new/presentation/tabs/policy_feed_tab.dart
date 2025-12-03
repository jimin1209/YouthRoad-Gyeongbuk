import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../widgets/policy_feed_list_view.dart';

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
    final query = ref.read(policyQueryProvider(widget.feedType));
    _searchController = TextEditingController(text: query.keyword ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final query = ref.watch(policyQueryProvider(widget.feedType));
    final content = PolicyFeedListView(feedType: widget.feedType);

    if (!widget.enableSearch) {
      return content;
    }

    if (_searchController.text != (query.keyword ?? '')) {
      _searchController.text = query.keyword ?? '';
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

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
      ],
    );
  }

  void _updateKeyword(String value) {
    ref
        .read(policyQueryProvider(widget.feedType).notifier)
        .setKeyword(value.trim());
  }

  @override
  bool get wantKeepAlive => true;
}
