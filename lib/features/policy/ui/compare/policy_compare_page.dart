import 'package:flutter/material.dart';

import '../../model/policy_item.dart';

class PolicyComparePage extends StatefulWidget {
  const PolicyComparePage({super.key, required this.items});

  final List<PolicyItem> items;

  @override
  State<PolicyComparePage> createState() => _PolicyComparePageState();
}

class _PolicyComparePageState extends State<PolicyComparePage> {
  late final ScrollController _leftCtrl;
  late final ScrollController _rightCtrl;
  bool _diffOnly = false;

  @override
  void initState() {
    super.initState();
    _leftCtrl = ScrollController();
    _rightCtrl = ScrollController();
    _leftCtrl.addListener(() {
      if (_rightCtrl.hasClients) {
        _rightCtrl.jumpTo(_leftCtrl.offset);
      }
    });
    _rightCtrl.addListener(() {
      if (_leftCtrl.hasClients) {
        _leftCtrl.jumpTo(_rightCtrl.offset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final left = widget.items.isNotEmpty ? widget.items[0] : null;
    final right = widget.items.length > 1 ? widget.items[1] : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 비교'),
        actions: [
          Row(
            children: [
              const Text('차이점만'),
              Switch(
                value: _diffOnly,
                onChanged: (v) => setState(() => _diffOnly = v),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: _buildColumn(context, left, right, _leftCtrl)),
          const VerticalDivider(width: 1),
          Expanded(child: _buildColumn(context, right, left, _rightCtrl)),
        ],
      ),
    );
  }

  Widget _buildColumn(
      BuildContext context, PolicyItem? me, PolicyItem? other, ScrollController controller) {
    final rows = [
      _row(context, '정책명', me?.title, other?.title),
      _row(context, '기관', me?.instNm, other?.instNm),
      _row(context, '유형', me?.policyType, other?.policyType),
      _row(context, '지원내용', me?.description, other?.description),
      _row(context, '기간', _period(me), _period(other)),
      _row(context, 'Eligibility', me?.applyAbleYn, other?.applyAbleYn),
      _row(context, '지역', me?.region, other?.region),
      _row(context, '연락처', me?.instTel, other?.instTel),
    ];
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(12),
      children: rows,
    );
  }

  Widget _row(BuildContext context, String label, String? a, String? b) {
    final same = (a ?? '') == (b ?? '');
    final muted = _diffOnly && same;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: Text(a ?? '-', style: TextStyle(color: muted ? Colors.grey : null))),
                const SizedBox(width: 12),
                Expanded(child: Text(b ?? '-', style: TextStyle(color: muted ? Colors.grey : null))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _period(PolicyItem? item) {
    if (item == null) return '-';
    return '${item.startDate ?? '-'} ~ ${item.endDate ?? '-'}';
  }

  @override
  void dispose() {
    _leftCtrl.dispose();
    _rightCtrl.dispose();
    super.dispose();
  }
}
