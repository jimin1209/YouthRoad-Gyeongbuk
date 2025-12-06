import 'package:flutter/material.dart';

class PolicyListEmpty extends StatelessWidget {
  const PolicyListEmpty({
    super.key,
    this.message = '표시할 정책이 없습니다.\n필터나 검색 조건을 바꿔보세요.',
    this.summary,
  });

  final String message;
  final String? summary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            if (summary != null && summary!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '현재 조건: $summary',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
