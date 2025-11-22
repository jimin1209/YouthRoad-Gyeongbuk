import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/policy_item.dart';
import '../card/policy_card_v2.dart';
import 'policy_detail_action_bar.dart';
import 'policy_detail_sections.dart';

class PolicyDetailPage extends ConsumerStatefulWidget {
  const PolicyDetailPage({super.key, required this.item});

  final PolicyItem item;

  @override
  ConsumerState<PolicyDetailPage> createState() => _PolicyDetailPageState();
}

class _PolicyDetailPageState extends ConsumerState<PolicyDetailPage> {
  bool _deadlineNotify = false;
  bool _announceNotify = false;
  bool _applied = false;
  bool _favorite = false;
  bool _compared = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: Text(item.title ?? '정책 상세')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PolicyDetailActionBar(
              onFavorite: () => setState(() => _favorite = !_favorite),
              onApplied: () => setState(() => _applied = !_applied),
              onOpenWeb: () {
                if (item.url != null && item.url!.isNotEmpty) {
                  context.push('/policy/detail/${item.id ?? ''}/web', extra: item.url);
                }
              },
              onShare: () {},
              onCompare: () => setState(() => _compared = !_compared),
            ),
            const SizedBox(height: 12),
            Text(item.title ?? '', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('${item.instNm ?? ''} · ${item.deptNm ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('기간: ${(item.startDate ?? '-')} ~ ${(item.endDate ?? '-')}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                _tag(context, item.policyType ?? '유형', scheme.primary),
                _tag(context, item.region ?? '지역', scheme.secondary),
                _tag(context, item.applyAbleYn == 'Y' ? '신청 가능' : '확인 필요', scheme.tertiary),
              ],
            ),
            const SizedBox(height: 12),
            _notificationBox(context),
            const SizedBox(height: 12),
            const PolicyDetailSections(),
            const SizedBox(height: 16),
            Text('비슷한 정책', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._mockSimilar().map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PolicyCardV2(
                  title: p.title ?? '',
                  summary: p.description ?? '',
                  agency: p.instNm ?? '',
                  department: p.deptNm ?? '',
                  policyType: p.policyType ?? '',
                  dDayText: '-',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationBox(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이 정책에 대해 알려드릴게요', style: Theme.of(context).textTheme.titleMedium),
            SwitchListTile(
              title: const Text('마감 7일 전 알림'),
              value: _deadlineNotify,
              onChanged: (v) => setState(() => _deadlineNotify = v),
            ),
            SwitchListTile(
              title: const Text('발표일 알림'),
              value: _announceNotify,
              onChanged: (v) => setState(() => _announceNotify = v),
            ),
            if (_favorite && (_deadlineNotify || _announceNotify))
              Text('즐겨찾기 정책은 알림이 자동 유지됩니다.', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  List<PolicyItem> _mockSimilar() {
    return [
      widget.item.copyWith(title: '[유사] ${widget.item.title ?? ''} A'),
      widget.item.copyWith(title: '[유사] ${widget.item.title ?? ''} B'),
      widget.item.copyWith(title: '[유사] ${widget.item.title ?? ''} C'),
    ];
  }
}
