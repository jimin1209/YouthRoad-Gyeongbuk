import 'package:flutter/material.dart';

class CompareNeedMoreWidget extends StatelessWidget {
  const CompareNeedMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.playlist_add, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              '정책을 한 개 더 선택해주세요',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              '두 개 이상 선택하면 표로 비교해드려요.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
