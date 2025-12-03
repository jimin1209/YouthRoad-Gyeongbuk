import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/values/policy_failure.dart';
import '../../presentation/detail/policy_detail_bottom_sheet.dart';
import 'widgets/compare_empty_widget.dart';
import 'widgets/compare_need_more_widget.dart';
import 'widgets/compare_screen.dart';

class CompareTab extends ConsumerWidget {
  const CompareTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareIds = ref.watch(compareRepositoryProvider).ids;
    final state = ref.watch(compareFeedControllerProvider);
    final controller = ref.read(compareFeedControllerProvider.notifier);
    final compareController = ref.read(compareRepositoryProvider.notifier);

    if (compareIds.isEmpty) {
      return const CompareEmptyWidget();
    }

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => _buildError(context, e, controller.load),
      data: (data) {
        if (compareIds.length == 1) {
          return const CompareNeedMoreWidget();
        }

        if (data.policies.isEmpty) {
          return const CompareEmptyWidget();
        }

        return CompareScreen(
          state: data,
          onRemove: compareController.remove,
          onClear: compareController.clear,
          onOpenDetail: (policyId) => _openDetail(context, policyId),
          onRefresh: controller.load,
        );
      },
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
              '비교 정보를 불러오지 못했습니다.',
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
