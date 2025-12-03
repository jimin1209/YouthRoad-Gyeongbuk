import 'package:flutter/material.dart';

class PolicyListEmpty extends StatelessWidget {
  const PolicyListEmpty({
    super.key,
    this.message = '표시할 정책이 없습니다.\n필터나 검색 조건을 바꿔보세요.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
