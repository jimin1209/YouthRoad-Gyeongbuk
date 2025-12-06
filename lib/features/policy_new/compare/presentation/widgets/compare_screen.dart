import 'dart:math';

import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../models/compare_state.dart';
import 'compare_content_view.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({
    super.key,
    required this.state,
    required this.onRemove,
    required this.onClear,
    required this.onOpenDetail,
    required this.onRefresh,
  });

  final CompareState state;
  final void Function(String) onRemove;
  final VoidCallback onClear;
  final void Function(String) onOpenDetail;
  final VoidCallback onRefresh;

  static const _columnWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    final service = CompareDiffService();
    final labelWidth = service.labelWidth;
    final totalWidth = max(
      MediaQuery.of(context).size.width,
      labelWidth + (_columnWidth + 12) * state.policies.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text(
                '비교 중인 정책 ${state.policies.length}개',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                tooltip: '새로고침',
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
              ),
              TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.delete_outline),
                label: const Text('모두 비우기'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 2.5,
            boundaryMargin: const EdgeInsets.all(32),
            clipBehavior: Clip.none,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: CompareContentView(
                    state: state,
                    service: service,
                    labelWidth: labelWidth,
                    columnWidth: _columnWidth,
                    onRemove: onRemove,
                    onOpenDetail: onOpenDetail,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
