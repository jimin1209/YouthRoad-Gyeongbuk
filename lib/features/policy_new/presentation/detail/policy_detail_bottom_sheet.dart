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
    final theme = Theme.of(context);
    final dDay = _buildDDayLabel(policy);

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
                    badge: dDay != null
                        ? _DDayBadge(label: dDay, color: theme.colorScheme)
                        : null,
                  ),
                  _InfoSection(
                    title: '신청 방법',
                    content: policy.applyUrl.isNotEmpty
                        ? 'Online: ${policy.applyUrl}'
                        : 'Application method not available.',
                  ),
                  _InfoSection(
                    title: '문의처',
                    content: (policy.contact ?? '').isNotEmpty
                        ? policy.contact!
                        : 'Contact info not available.',
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
                  child: PolicyReminderButton(policy: policy),
                ),
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
      final min = policy.minAge != null ? '만 ${policy.minAge}세 이상' : '';
      final max = policy.maxAge != null ? '만 ${policy.maxAge}세 이하' : '';
      final ageText = [min, max].where((e) => e.isNotEmpty).join(' / ');
      targets.add(ageText);
    }
    if (policy.isForYouth) targets.add('청년 대상');
    if ((policy.incomeCondition ?? '').isNotEmpty) {
      targets.add(policy.incomeCondition!);
    }
    if ((policy.educationCondition ?? '').isNotEmpty) {
      targets.add('학력: ${policy.educationCondition}');
    }
    if ((policy.employmentCondition ?? '').isNotEmpty) {
      targets.add('고용: ${policy.employmentCondition}');
    }

    if (targets.isEmpty) return 'Eligibility info not available.';
    return targets.join('\n');
  }

  static String _buildPeriodText(Policy policy) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;

    if (start == null && end == null) {
      return 'Application period not available';
    }
    if (start != null && end == null) {
      return 'Start: ${start.toLocal().toString().split(" ").first}';
    }
    if (start == null && end != null) {
      return 'End: ${end.toLocal().toString().split(" ").first}';
    }
    return 'Period: ${start!.toLocal().toString().split(" ").first} ~ '
        '${end!.toLocal().toString().split(" ").first}';
  }

  static String? _buildDDayLabel(Policy policy) {
    final end = policy.applicationEndDate;
    if (end == null) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDate = DateTime(end.year, end.month, end.day);

    final diff = endDate.difference(today).inDays;
    if (diff < 0) return '마감됨';
    if (diff == 0) return '오늘 마감';
    return 'D-$diff';
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.content,
    this.badge,
  });

  final String title;
  final String content;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionTitle(
              title: title,
              trailing: badge,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              content,
              style: AppText.textTheme.bodyMedium,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}

class _DDayBadge extends StatelessWidget {
  const _DDayBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppText.textTheme.labelMedium,
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
    final String message = error is PolicyFailure
        ? (error as PolicyFailure).message
        : 'An unknown error occurred while loading the policy.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Failed to load policy details'),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppText.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
