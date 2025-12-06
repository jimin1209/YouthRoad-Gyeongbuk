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
              '비교를 시작하려면 정책을 하나 더 추가해 주세요',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '두 번째 정책까지 담으면 자동으로 비교가 진행됩니다.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
