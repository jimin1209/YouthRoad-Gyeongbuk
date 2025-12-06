import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_feed_type.dart';
import '../filters/policy_keyword_sheet.dart';

class PolicySearchEmptyView extends ConsumerWidget {
  const PolicySearchEmptyView({
    super.key,
    required this.isKeywordTooShort,
    this.feedType = PolicyFeedType.search,
  });

  final bool isKeywordTooShort;
  final PolicyFeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = isKeywordTooShort
        ? '검색어를 2글자 이상 입력해주세요.'
        : '검색어를 입력하거나 추천 태그를 선택해보세요.';
    final description = isKeywordTooShort
        ? '검색어가 너무 짧아요. 조금 더 구체적으로 입력해보세요.'
        : '상단의 추천 태그를 눌러보거나 검색어를 입력하면 정책을 찾아드릴게요.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _openKeywordSheet(context),
              icon: const Icon(Icons.edit),
              label: const Text('검색어 입력하기'),
            ),
          ],
        ),
      ),
    );
  }

  void _openKeywordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyKeywordSheet(feedType: feedType),
    );
  }
}
