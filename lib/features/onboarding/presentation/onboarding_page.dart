import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../region/providers/providers.dart';
import '../../policy/controller/policy_metadata_providers.dart';
import '../../profile/providers/user_preferences_provider.dart';
import '../../policy/controller/policy_list_controller.dart';
import '../../policy/data/models/region.dart';
import '../../policy/data/models/category.dart';
import '../controller/onboarding_controller.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;
  String? _selectedRegion;
  final Set<String> _interests = <String>{};

  void _next() {
    if (_step < 2) {
      setState(() => _step += 1);
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final region = _selectedRegion;
    if (region == null) {
      return;
    }
    final interests = List<String>.unmodifiable(_interests);
    ref.read(userRegionProvider.notifier).state = region;
    ref.read(userInterestsProvider.notifier).state = interests;
    await UserPreferencesStorage.save(
      region: region,
      interests: interests,
      onboardingCompleted: true,
    );
    ref.read(policyFilterUseProfileProvider.notifier).state = true;
    ref.read(policyFilterStateProvider.notifier).state =
        PolicyFilter.initial();
    final onboardingNotifier = ref.read(onboardingStateProvider.notifier);
    onboardingNotifier.state =
        onboardingNotifier.state.copyWith(completed: true);
    if (!mounted) {
      return;
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final regions = ref.watch(regionListProvider);
    final categories = ref.watch(categoryListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('나만의 추천 준비')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LinearProgressIndicator(value: (_step + 1) / 3),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: IndexedStack(
                    key: ValueKey(_step),
                    index: _step,
                    children: [
                      _IntroStep(onNext: _next),
                      _RegionStep(
                        regions: regions,
                        selected: _selectedRegion,
                        onSelected: (value) => setState(() => _selectedRegion = value),
                      ),
                      _InterestStep(
                        categories: categories,
                        interests: _interests,
                        onToggle: (value) {
                          setState(() {
                            if (_interests.contains(value)) {
                              _interests.remove(value);
                            } else {
                              _interests.add(value);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed:
                (_step == 1 && _selectedRegion == null) ? null : _next,
            child: Text(_step < 2 ? '다음' : '완료'),
          ),
        ),
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('경북 청년 정책 추천', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('지역과 관심사를 기반으로 맞춤형 정책을 추천해드려요.'),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FilledButton(onPressed: onNext, child: const Text('시작하기')),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionStep extends StatelessWidget {
  const _RegionStep({
    required this.regions,
    required this.selected,
    required this.onSelected,
  });

  final AsyncValue<List<Region>> regions;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. 살고 있는 지역을 알려주세요', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            regions.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Text('선택 가능한 지역 정보가 없습니다.');
                }
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: items.map((region) {
                    final isSelected = region.code == selected;
                    return FilterChip(
                      label: Text(region.name),
                      selected: isSelected,
                      onSelected: (_) => onSelected(region.code),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('지역 정보를 불러오지 못했습니다: $error'),
            ),
            const SizedBox(height: 12),
            const Text('Unity 지도와 연동되어 자동으로 지역을 불러올 수 있어요.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _InterestStep extends StatelessWidget {
  const _InterestStep({
    required this.categories,
    required this.interests,
    required this.onToggle,
  });

  final AsyncValue<List<Category>> categories;
  final Set<String> interests;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('2. 관심 분야를 골라주세요', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            categories.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Text('선택 가능한 관심 분야가 없습니다.');
                }
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: items.map((category) {
                    final selected = interests.contains(category.code);
                    return FilterChip(
                      label: Text(category.name),
                      selected: selected,
                      onSelected: (_) => onToggle(category.code),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('관심 분야 정보를 불러오지 못했습니다: $error'),
            ),
            const SizedBox(height: 8),
            Text('최소 3개 이상 선택하면 더 정확한 추천을 받습니다.',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
