import 'package:flutter/material.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({
    super.key,
    this.primaryMessage = '조건에 맞는 정책이 없습니다.',
    this.secondaryMessage = '검색 조건(지역/상태/정렬)을 변경해보세요.',
  });

  final String primaryMessage;
  final String secondaryMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                primaryMessage,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                secondaryMessage,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
