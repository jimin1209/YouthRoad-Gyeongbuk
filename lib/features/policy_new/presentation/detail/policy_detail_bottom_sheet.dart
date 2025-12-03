import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/controllers/policy_detail_controller.dart';
import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../../domain/values/policy_failure.dart';
import '../reminder/sheets/reminder_manage_sheet.dart';
import '../reminder/sheets/reminder_setup_bottom_sheet.dart';
import '../widgets/policy_list_loading.dart';

class PolicyDetailBottomSheet extends ConsumerWidget {
  const PolicyDetailBottomSheet({
    super.key,
    required this.policyId,
  });

  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPolicy = ref.watch(policyDetailProvider(policyId));
    final detailController = ref.read(policyDetailProvider(policyId).notifier);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: asyncPolicy.when(
            data: (policy) =>
                _buildContent(context, ref, scrollController, policy),
            loading: () => const PolicyListLoading(),
            error: (err, __) => _buildError(context, err, detailController),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref,
      ScrollController controller, Policy policy) {
    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              policy.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              policy.summary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _chip(policy.region.name),
                _chip(policy.category.name),
                if (policy.isOngoing) _chip('모집중'),
                if (policy.isUpcoming) _chip('시작 예정'),
                if (policy.isClosed) _chip('마감'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '지원내용',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              policy.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              '접수기간',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _buildPeriodText(policy),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _infoRow('기관명', policy.institution),
            _infoRow('담당부서', policy.department),
            _infoRow('문의처', policy.contact ?? ''),
            _infoRow('지원대상', _buildTargetText(policy)),
            const SizedBox(height: 16),
            _buildReminderSection(context, ref, policy),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openApplyUrl(policy.applyUrl),
                    child: const Text('실제 정책 페이지로 이동'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    Object error,
    PolicyDetailController controller,
  ) {
    final message = error is PolicyFailure ? error.message : '알 수 없는 오류';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('상세 정보를 불러오지 못했습니다.'),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: controller.refresh,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '정보 없음',
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSection(
    BuildContext context,
    WidgetRef ref,
    Policy policy,
  ) {
    final remindersAsync = ref.watch(remindersByPolicyProvider(policy.id));
    final hasReminders = remindersAsync.valueOrNull?.isNotEmpty ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '신청 알림',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.notifications_active_outlined, size: 18),
          ],
        ),
        const SizedBox(height: 8),
        remindersAsync.when(
          data: (list) {
            if (list.isEmpty) {
              return const Text('알림이 설정되지 않았습니다.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list
                  .map(
                    (reminder) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${reminder.type.label} · ${reminder.remindAt.toLocal()}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          },
          error: (err, _) => Text('알림 정보를 불러오지 못했습니다: $err'),
          loading: () => const LinearProgressIndicator(minHeight: 3),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => ReminderSetupBottomSheet(policy: policy),
                  );
                },
                icon: const Icon(Icons.add_alert),
                label: const Text('알림 설정'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: hasReminders
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => ReminderManageSheet(policy: policy),
                        );
                      }
                    : null,
                icon: const Icon(Icons.manage_history_outlined),
                label: const Text('알림 관리'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _buildTargetText(Policy policy) {
    final targets = <String>[];
    if (policy.minAge != null || policy.maxAge != null) {
      final min = policy.minAge != null ? '${policy.minAge}세' : '';
      final max = policy.maxAge != null ? '${policy.maxAge}세' : '';
      targets.add('연령 ${[min, max].where((e) => e.isNotEmpty).join(' ~ ')}');
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

    if (targets.isEmpty) {
      return '대상 정보 없음';
    }
    return targets.join('\n');
  }

  String _buildPeriodText(Policy policy) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;
    if (start == null && end == null) {
      return '신청 기간 정보 없음';
    }
    if (start != null && end == null) {
      return '신청 시작일: ${start.toLocal().toString().split(" ").first}';
    }
    if (start == null && end != null) {
      return '신청 마감일: ${end.toLocal().toString().split(" ").first}';
    }
    return '신청 기간: '
        '${start!.toLocal().toString().split(" ").first} ~ '
        '${end!.toLocal().toString().split(" ").first}';
  }

  Future<void> _openApplyUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
