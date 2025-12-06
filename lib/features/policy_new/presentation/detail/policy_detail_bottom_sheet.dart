import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/policy_detail_controller.dart';
import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../../domain/values/policy_failure.dart';
import '../widgets/policy_list_loading.dart';
import '../reminder/policy_reminder_button.dart';
import 'widgets/policy_action_bar.dart';
import '../../../../ui/layout/app_screen_container.dart';
import '../../../../ui/components/app_section_title.dart';
import '../../../../ui/components/app_divider.dart';
import '../../../../ui/components/app_card.dart';
import '../../../../ui/theme/app_text.dart';
import '../../../../ui/theme/app_spacing.dart';

class PolicyDetailBottomSheet extends ConsumerStatefulWidget {
  const PolicyDetailBottomSheet({
    super.key,
    required this.policyId,
  });

  final String policyId;

  @override
  ConsumerState<PolicyDetailBottomSheet> createState() =>
      _PolicyDetailBottomSheetState();
}

class _PolicyDetailBottomSheetState
    extends ConsumerState<PolicyDetailBottomSheet> {
  @override
  void initState() {
    super.initState();
    ref
        .read(policyReminderControllerProvider(widget.policyId).notifier)
        .onInit();
  }

  @override
  Widget build(BuildContext context) {
    final asyncPolicy = ref.watch(policyDetailProvider(widget.policyId));
    final detailController =
        ref.read(policyDetailProvider(widget.policyId).notifier);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: asyncPolicy.when(
            data: (policy) =>
                _Content(policy: policy, controller: scrollController),
            loading: () => const PolicyListLoading(),
            error: (err, __) => _ErrorView(
              error: err,
              onRetry: detailController.refresh,
            ),
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.policy,
    required this.controller,
  });

  final Policy policy;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AppScreenContainer(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    policy.title,
                    style: AppText.textTheme.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${policy.institution} · ${policy.department}',
                    style: AppText.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PolicyActionBar(policy: policy),
                  const SizedBox(height: AppSpacing.lg),
                  const AppDivider(),
                  const SizedBox(height: AppSpacing.lg),
                  _InfoSection(
                    title: '지원 대상',
                    content: _buildTargetText(policy),
                  ),
                  _InfoSection(
                    title: '신청 기간',
                    content: _buildPeriodText(policy),
                  ),
                  _InfoSection(
                    title: '신청 방법',
                    content: policy.applyUrl.isNotEmpty
                        ? '온라인 신청\n${policy.applyUrl}'
                        : '신청 방법 정보가 없습니다.',
                  ),
                  _InfoSection(
                    title: '문의처 정보',
                    content: (policy.contact ?? '').isNotEmpty
                        ? policy.contact!
                        : '문의 정보가 없습니다.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
        const AppDivider(),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('비교 화면')),
                            body: const SizedBox.shrink(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('비교하기'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                PolicyReminderButton(policy: policy),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _buildTargetText(Policy policy) {
    final targets = <String>[];

    if (policy.minAge != null || policy.maxAge != null) {
      final min = policy.minAge != null ? '${policy.minAge}세' : '';
      final max = policy.maxAge != null ? '${policy.maxAge}세' : '';
      final ageText = [min, max].where((e) => e.isNotEmpty).join(' ~ ');
      targets.add('연령 $ageText');
    }
    if (policy.isForYouth) targets.add('청년 대상');
    if ((policy.incomeCondition ?? '').isNotEmpty) {
      targets.add(policy.incomeCondition!);
    }
    if ((policy.educationCondition ?? '').isNotEmpty) {
      targets.add('학력: ${policy.educationCondition}');
    }
    if ((policy.employmentCondition ?? '').isNotEmpty) {
      targets.add('취업 상태: ${policy.employmentCondition}');
    }

    if (targets.isEmpty) return '지원 대상 정보가 없습니다.';
    return targets.join('\n');
  }

  static String _buildPeriodText(Policy policy) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;

    if (start == null && end == null) return '신청 기간 정보 없음';
    if (start != null && end == null) {
      return '신청 시작: ${start.toLocal().toString().split(" ").first}';
    }
    if (start == null && end != null) {
      return '신청 마감: ${end.toLocal().toString().split(" ").first}';
    }

    return '신청 기간: ${start!.toLocal().toString().split(" ").first} ~ '
        '${end!.toLocal().toString().split(" ").first}';
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionTitle(title: title, padding: EdgeInsets.zero),
            const SizedBox(height: AppSpacing.sm),
            Text(
              content,
              style: AppText.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message =
        error is PolicyFailure ? (error as PolicyFailure).message : '알 수 없는 오류';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('상세 정보를 불러오지 못했어요'),
            const SizedBox(height: 8),
            Text(message, style: AppText.textTheme.bodyMedium),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
