import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/values/policy_failure.dart';
import '../../compare/presentation/widgets/compare_empty_widget.dart';
import '../../compare/presentation/widgets/compare_need_more_widget.dart';
import '../detail/policy_detail_bottom_sheet.dart';
import 'widgets/policy_compare_canvas.dart';

/// 단독 화면으로 비교 UI를 띄울 때 사용하는 래퍼 스크린입니다.
class PolicyCompareScreen extends ConsumerWidget {
  const PolicyCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareIds = ref.watch(compareRepositoryProvider).ids;
    final state = ref.watch(compareFeedControllerProvider);
    final controller = ref.read(compareFeedControllerProvider.notifier);
    final compareController = ref.read(compareRepositoryProvider.notifier);

    Widget body;
    if (compareIds.isEmpty) {
      body = const CompareEmptyWidget();
    } else {
      body = state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => _buildError(context, e, controller.load),
        data: (data) {
          if (compareIds.length == 1) {
            return const CompareNeedMoreWidget();
          }

          if (data.policies.isEmpty) {
            return const CompareEmptyWidget();
          }

          return PolicyCompareCanvas(
            state: data,
            onRemove: compareController.remove,
            onClear: compareController.clear,
            onOpenDetail: (policyId) => _openDetail(context, policyId),
            onRefresh: controller.load,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 비교'),
      ),
      body: SafeArea(child: body),
    );
  }

  Widget _buildError(
    BuildContext context,
    Object error,
    VoidCallback onRetry,
  ) {
    final message = error is PolicyFailure ? error.message : error.toString();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '비교 정보를 불러오지 못했어요',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, String policyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyDetailBottomSheet(policyId: policyId),
    );
  }
}
