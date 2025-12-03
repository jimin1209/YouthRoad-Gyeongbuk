import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_feed_type.dart';
import '../filters/policy_filter_bar.dart';
import '../filters/policy_recommend_tags_bar.dart';
import '../widgets/policy_feed_list_view.dart';

class PolicyFeedHomeScreen extends ConsumerStatefulWidget {
  const PolicyFeedHomeScreen({super.key});

  @override
  ConsumerState<PolicyFeedHomeScreen> createState() =>
      _PolicyFeedHomeScreenState();
}

class _PolicyFeedHomeScreenState extends ConsumerState<PolicyFeedHomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<({String label, PolicyFeedType type})> _tabs = const [
    (label: '추천', type: PolicyFeedType.recommend),
    (label: '전체', type: PolicyFeedType.all),
    (label: '지역', type: PolicyFeedType.region),
    (label: '검색', type: PolicyFeedType.search),
    (label: '즐겨찾기', type: PolicyFeedType.favorite),
    (label: '비교', type: PolicyFeedType.compare),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 탐색'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((e) => Tab(text: e.label)).toList(),
        ),
      ),
      body: Column(
        children: [
          const PolicyFilterBar(),
          const PolicyRecommendTagsBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: _tabs
                  .map((tab) => PolicyFeedListView(feedType: tab.type))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
