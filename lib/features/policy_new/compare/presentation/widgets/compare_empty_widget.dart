import 'package:flutter/material.dart';

class CompareEmptyWidget extends StatelessWidget {
  const CompareEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.compare_arrows_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              '비교할 정책을 담아주세요',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              '관심있는 정책 카드의 비교 버튼을 눌러 목록에 추가할 수 있습니다.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
