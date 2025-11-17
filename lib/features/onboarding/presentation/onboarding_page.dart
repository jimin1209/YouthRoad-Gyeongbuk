import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;
  String? _selectedRegion;
  final Set<String> _interests = {};

  void _next() {
    if (_step < 2) {
      setState(() => _step += 1);
    } else {
      // TODO: persist onboarding data.
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('온보딩 ${_step + 1}/3')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: IndexedStack(
          index: _step,
          children: [
            _IntroStep(onNext: _next),
            _RegionStep(
              selected: _selectedRegion,
              onSelected: (value) => setState(() => _selectedRegion = value),
            ),
            _InterestStep(
              interests: _interests,
              onToggle: (value) {
                setState(() {
                  _interests.contains(value)
                      ? _interests.remove(value)
                      : _interests.add(value);
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: (_step == 1 && _selectedRegion == null) ? null : _next,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('경북 청년 정책 추천', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('지역과 관심사를 기반으로 맞춤형 정책을 추천해드려요.'),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(onPressed: onNext, child: const Text('시작하기')),
        ),
      ],
    );
  }
}

class _RegionStep extends StatelessWidget {
  const _RegionStep({required this.selected, required this.onSelected});
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('지역을 선택하세요 (Unity 연동 예정)', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: [
            '경산시',
            '포항시',
            '경주시',
          ].map((r) {
            final isSelected = r == selected;
            return ChoiceChip(
              label: Text(r),
              selected: isSelected,
              onSelected: (_) => onSelected(r),
            );
          }).toList(),
        ),
        const Spacer(),
        const Text('Unity 지도에서 REGION_SELECTED 메시지를 수신해 연동합니다.'),
      ],
    );
  }
}

class _InterestStep extends StatelessWidget {
  const _InterestStep({required this.interests, required this.onToggle});
  final Set<String> interests;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final items = [
      '일자리·취업',
      '창업',
      '주거',
      '생활·복지',
      '교육·역량',
      '문화·여가',
      '기타',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('관심 분야를 선택하세요', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: items
              .map((e) => FilterChip(
                    label: Text(e),
                    selected: interests.contains(e),
                    onSelected: (_) => onToggle(e),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
