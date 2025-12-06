import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_feed_type.dart';
import '../../application/providers.dart' show compareRepositoryProvider;
import '../filters/policy_filter_bar.dart';
import '../filters/policy_recommend_tags_bar.dart';
import '../reminder/policy_reminder_list_screen.dart';
import '../widgets/policy_feed_list_view.dart';
import '../explore/policy_explore_screen.dart';
import '../compare/widgets/compare_entry_bar.dart';
import '../compare/policy_compare_screen.dart';

class PolicyFeedHomeScreen extends ConsumerStatefulWidget {
  const PolicyFeedHomeScreen({super.key});

  @override
  ConsumerState<PolicyFeedHomeScreen> createState() =>
      _PolicyFeedHomeScreenState();
}

class _PolicyFeedHomeScreenState extends ConsumerState<PolicyFeedHomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;

  /// 메인 탭: 추천 / 탐색(=전체) / 보관함(=즐겨찾기)
  /// TODO(TASK20): 탐색/보관함 전용 화면 리팩터링 시 이 매핑을 교체한다.
  final List<({String label, PolicyFeedType type})> _tabs = const [
    (label: '추천', type: PolicyFeedType.recommend),
    (label: '탐색', type: PolicyFeedType.all),
    (label: '보관함', type: PolicyFeedType.favorite),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      animationDuration: const Duration(milliseconds: 230),
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFeedType = _tabs[_currentIndex].type;

    // 🔵 비교 보관함 상태
    final compareRepo = ref.watch(compareRepositoryProvider);
    final compareCount = compareRepo.ids.length;
    final showCompareBar =
        currentFeedType == PolicyFeedType.favorite && compareCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 탐색'),
        actions: [
          IconButton(
            tooltip: '알림 목록',
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PolicyReminderListScreen(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (index) {
            if (index != _currentIndex) {
              _tabController.animateTo(
                index,
                curve: Curves.easeOutCubic,
              );
            }
          },
          tabs: _tabs.map((e) => Tab(text: e.label)).toList(),
        ),
      ),
      body: Column(
        children: [
          // 🔵 추천 탭에서만 상단 필터 바 노출
          if (currentFeedType == PolicyFeedType.recommend)
            const PolicyFilterBar(),

          // 🔵 추천 탭에서만 추천 태그 바 노출
          if (_shouldShowTagsBar(currentFeedType))
            const PolicyRecommendTagsBar(),

          // 🔵 실제 리스트 부분
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: _tabs.map((tab) {
                // 탐색 탭은 ExploreScreen 사용
                if (tab.type == PolicyFeedType.all) {
                  return const PolicyExploreScreen();
                }

                // 추천 / 보관함 탭은 기본 피드 리스트 사용
                return PolicyFeedListView(feedType: tab.type);
              }).toList(),
            ),
          ),

          // 🔵 보관함 탭 + 비교 항목 있을 때만 하단 CompareEntryBar 노출
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
      ),
    );
  }

  bool _shouldShowTagsBar(PolicyFeedType feedType) {
    return feedType == PolicyFeedType.recommend;
  }
}
