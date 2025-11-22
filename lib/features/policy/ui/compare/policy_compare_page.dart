import 'package:flutter/material.dart';

import '../../model/policy_item.dart';

class PolicyComparePage extends StatelessWidget {
  const PolicyComparePage({super.key, required this.items});

  final List<PolicyItem> items;

  @override
  Widget build(BuildContext context) {
    final left = items.isNotEmpty ? items.first : null;
    final right = items.length > 1 ? items[1] : null;
    return Scaffold(
      appBar: AppBar(title: const Text('정책 비교')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row('제목', left?.title, right?.title),
            _row('기관', left?.instNm, right?.instNm),
            _row('유형', left?.policyType, right?.policyType),
            _row('지원내용', left?.description, right?.description),
            _row('기간', _period(left), _period(right)),
            _row('Eligibility', left?.applyAbleYn, right?.applyAbleYn),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String? a, String? b) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(width: 90, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
            Expanded(child: Text(a ?? '-')),
            const SizedBox(width: 12),
            Expanded(child: Text(b ?? '-')),
          ],
        ),
      ),
    );
  }

  String _period(PolicyItem? item) {
    if (item == null) return '-';
    return '${item.startDate ?? '-'} ~ ${item.endDate ?? '-'}';
    }
}
