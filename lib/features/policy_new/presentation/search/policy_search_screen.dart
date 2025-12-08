import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../application/search/search_label_builder.dart';
import '../../domain/values/policy_feed_type.dart';
import '../tabs/policy_feed_tab.dart';

class PolicySearchScreen extends ConsumerWidget {
  const PolicySearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(globalFilterProvider);
    final filterLabel = SearchLabelBuildContext.filterLabelFromStatus(filter.status);
    final sortLabel = SearchLabelBuildContext.sortLabel(filter.sort);
    final summary = SearchLabelBuildContext.makeLabel(
      filter.regionSummary,
      filterLabel,
      sortLabel,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(summary),
      ),
      body: const PolicyFeedTab(feedType: PolicyFeedType.search),
    );
  }
}
