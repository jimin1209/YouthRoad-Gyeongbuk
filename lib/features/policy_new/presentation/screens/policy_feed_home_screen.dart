import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/base_feed_controller.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../tabs/policy_feed_tab.dart';

class PolicyFeedHomeScreen extends ConsumerStatefulWidget {
  const PolicyFeedHomeScreen({super.key});

  @override
  ConsumerState<PolicyFeedHomeScreen> createState() =>
      _PolicyFeedHomeScreenState();
}

class _PolicyFeedHomeScreenState extends ConsumerState<PolicyFeedHomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<(String label, PolicyFeedType type)> _tabs = const [
    ('추천', PolicyFeedType.recommend),
    ('전체', PolicyFeedType.all),
    ('지역', PolicyFeedType.region),
    ('검색', PolicyFeedType.search),
    ('즐겨찾기', PolicyFeedType.favorite),
    ('비교', PolicyFeedType.compare),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    _tabController.addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureCurrentTabLoaded();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
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
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: _tabs.map((tab) {
          final isSearchTab = tab.type == PolicyFeedType.search;
          return PolicyFeedTab(
            feedType: tab.type,
            enableSearch: isSearchTab,
          );
        }).toList(),
      ),
    );
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    _ensureCurrentTabLoaded();
  }

  void _ensureCurrentTabLoaded() {
    final currentType = _tabs[_tabController.index].type;
    _controllerFor(currentType).ensureInitialized();
  }

  BasePolicyFeedController _controllerFor(PolicyFeedType type) {
    switch (type) {
      case PolicyFeedType.recommend:
        return ref.read(recommendFeedControllerProvider.notifier);
      case PolicyFeedType.all:
        return ref.read(allFeedControllerProvider.notifier);
      case PolicyFeedType.region:
        return ref.read(regionFeedControllerProvider.notifier);
      case PolicyFeedType.search:
        return ref.read(searchFeedControllerProvider.notifier);
      case PolicyFeedType.favorite:
        return ref.read(favoriteFeedControllerProvider.notifier);
      case PolicyFeedType.compare:
        return ref.read(compareFeedControllerProvider.notifier);
    }
  }
}
