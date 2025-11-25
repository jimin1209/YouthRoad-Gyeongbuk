import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card_v2.dart';

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareAsync = ref.watch(compareProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '정책 비교함'),
      body: compareAsync.when(
        data: (policies) {
          if (policies.isEmpty) {
            return const _EmptyView(message: '비교함에 담긴 정책이 없습니다');
          }
          if (policies.length == 1) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: PolicyCardV2(policy: policies.first)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: _EmptyView(
                      message: '비교할 정책을 하나 더 담아주세요',
                    ),
                  ),
                ],
              ),
            );
          }
          final first = policies[0];
          final second = policies[1];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: PolicyCardV2(policy: first)),
                    const SizedBox(width: 12),
                    Expanded(child: PolicyCardV2(policy: second)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCompareTable(first, second),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(child: Text('비교 정보를 불러올 수 없습니다.')),
      ),
    );
  }

  Widget _buildCompareTable(Policy a, Policy b) {
    final rows = <_CompareRowInfo>[
      _CompareRowInfo('제목', a.policyNm, b.policyNm),
      _CompareRowInfo('기관', a.sprvsnInstNm ?? a.operInstNm ?? '-',
          b.sprvsnInstNm ?? b.operInstNm ?? '-'),
      _CompareRowInfo('유형', a.policyTypeNm ?? '-', b.policyTypeNm ?? '-'),
      _CompareRowInfo('지원 규모', a.policyScl ?? '-', b.policyScl ?? '-'),
      _CompareRowInfo('지원 내용', a.policyCn ?? '-', b.policyCn ?? '-'),
      _CompareRowInfo('연령/지역', _regionAge(a), _regionAge(b)),
      _CompareRowInfo(
        '신청 기간',
        _formatPeriod(a.applyStart, a.applyEnd, a.policyBgngYmd, a.policyEndYmd),
        _formatPeriod(b.applyStart, b.applyEnd, b.policyBgngYmd, b.policyEndYmd),
      ),
      _CompareRowInfo('링크', a.dtlLinkUrl ?? '-', b.dtlLinkUrl ?? '-'),
    ];

    return Table(
      columnWidths: const {0: IntrinsicColumnWidth()},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows
          .map(
            (row) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    row.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row.left, maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row.right,
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  static String _regionAge(Policy policy) {
    final region = (policy.rgnSeNm ?? '').trim();
    final regionText = region.isEmpty ? '지역 전체' : region;
    final age = policy.policyScl ?? '연령 정보 없음';
    return '$regionText / $age';
  }

  static String _formatPeriod(
    DateTime? applyStart,
    DateTime? applyEnd,
    DateTime? policyStart,
    DateTime? policyEnd,
  ) {
    String? start =
        applyStart?.toIso8601String().split('T').first ?? policyStart?.toIso8601String().split('T').first;
    String? end =
        applyEnd?.toIso8601String().split('T').first ?? policyEnd?.toIso8601String().split('T').first;
    start = (start == null || start.isEmpty) ? null : start;
    end = (end == null || end.isEmpty) ? null : end;
    if (start == null && end == null) return '-';
    if (start != null && end != null) return '$start ~ $end';
    if (start != null) return '$start 시작';
    return '~ $end';
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.balance_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _CompareRowInfo {
  const _CompareRowInfo(this.label, this.left, this.right);

  final String label;
  final String left;
  final String right;
}
