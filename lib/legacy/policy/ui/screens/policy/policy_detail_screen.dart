import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/features/policy_new/application/controllers/policy_action_controller.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_reminder_controller.dart';
import 'package:youth_road_app/features/policy_new/application/providers.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy_reminder.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_reminder_status.dart';
import 'package:youth_road_app/features/policy_new/domain/values/reminder_time_kind.dart';
import 'package:youth_road_app/ui/components/policy_cta_button.dart';
import 'package:youth_road_app/ui/components/policy_info_row.dart';
import 'package:youth_road_app/ui/components/policy_tag.dart';
import 'package:youth_road_app/ui/components/section_title.dart';

/// 정책 상세 화면
///
/// UI 전용으로 설계되어 있으며, 정책 알림(리마인더) 기능을
/// Riverpod Provider와 직접 연결한다.
class PolicyDetailScreen extends ConsumerWidget {
  const PolicyDetailScreen({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderProvider = policyReminderControllerProvider(policy.id);
    final reminderState = ref.watch(reminderProvider);
    final reminderController = ref.read(reminderProvider.notifier);
    final actionController =
        ref.read(policyActionControllerProvider(policy.id).notifier);

    ref.listen<AsyncValue<PolicyReminderViewState>>(reminderProvider,
        (previous, next) {
      next.whenOrNull(
        data: (viewState) {
          if (viewState.messages.isNotEmpty) {
            _showSnackBar(
              context,
              viewState.messages.join('\n'),
            );
            reminderController.clearMessages();
          }
        },
        error: (error, __) {
          _showSnackBar(
            context,
            '알림 상태를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.',
          );
        },
      );
    });

    final selectedReminder = _resolveSelectedReminder(reminderState);
    final isReminderBusy = reminderState.isLoading ||
        reminderState.maybeWhen(
          data: (viewState) => viewState.isMutating,
          orElse: () => false,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: null,
            tooltip: '관심 정책',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: null,
            tooltip: '공유하기',
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 + 태그
                _buildHeader(context),

                const SizedBox(height: 16),

                // 요약
                if (policy.summary.trim().isNotEmpty) ...[
                  Text(
                    policy.summary,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 접수기간 간단 강조
                _buildPeriodHighlight(context),

                const SizedBox(height: 20),

                // 신청 페이지 열기 CTA
                PolicyCtaButton(
                  text: '신청 페이지 열기',
                  onTap: () async {
                    final opened = await actionController.openPolicyLink(policy);
                    if (!opened && context.mounted) {
                      _showSnackBar(
                        context,
                        '신청 페이지를 열지 못했습니다.',
                      );
                    }
                  },
                ),

                if (policy.applyUrl.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    policy.applyUrl,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ],

                const SizedBox(height: 24),

                // 알림 설정 영역
                SectionTitle(title: '알림 설정'),
                const SizedBox(height: 8),
                Text(
                  '마감 전에 알림을 받아보고 싶다면 원하는 시점을 선택하세요.',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                if (reminderState.isLoading)
                  const LinearProgressIndicator(minHeight: 2),
                const SizedBox(height: 8),
                _buildReminderGrid(
                  context,
                  selectedReminder: selectedReminder,
                  isBusy: isReminderBusy,
                  onTap: (option) async {
                    await _handleReminderTap(
                      context,
                      actionController,
                      option,
                      selectedReminder,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // 지원 내용
                SectionTitle(title: '지원 내용'),
                const SizedBox(height: 8),
                Text(
                  policy.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                // 접수 기간 상세 섹션
                SectionTitle(title: '접수 기간'),
                const SizedBox(height: 4),
                Text(
                  _buildPeriodText(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: 24),

                // 기관 / 부서 / 문의처
                SectionTitle(title: '기관 및 문의'),
                const SizedBox(height: 4),
                PolicyInfoRow(
                  label: '주관 기관',
                  value: policy.institution,
                ),
                PolicyInfoRow(
                  label: '담당 부서',
                  value: policy.department,
                ),
                PolicyInfoRow(
                  label: '문의처',
                  value: policy.contact ?? '정보 없음',
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleReminderTap(
    BuildContext context,
    PolicyActionController controller,
    ReminderOption option,
    ReminderOption? selected,
  ) async {
    if (selected == option) {
      await controller.cancelReminder();
      _showSnackBar(context, '알림이 취소되었습니다.');
      return;
    }

    try {
      await controller.setReminder(policy, option.toKind());
      _showSnackBar(context, '알림이 예약되었습니다.');
    } catch (e) {
      _showSnackBar(
        context,
        '알림을 설정하지 못했습니다. 잠시 후 다시 시도해 주세요. ($e)',
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  ReminderOption? _resolveSelectedReminder(
    AsyncValue<PolicyReminderViewState> reminderState,
  ) {
    return reminderState.maybeWhen(
      data: (viewState) {
        final scheduled = _scheduledReminders(viewState);
        if (scheduled.isEmpty) return null;
        return ReminderOptionX.fromTimeKind(scheduled.first.timeKind);
      },
      orElse: () => null,
    );
  }

  List<PolicyReminder> _scheduledReminders(PolicyReminderViewState state) {
    final reminders = state.reminders
        .where((reminder) => reminder.status == PolicyReminderStatus.scheduled)
        .toList();
    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return reminders;
  }

  /// 상단 헤더 (정책 제목 + 태그)
  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          policy.title,
          style: textTheme.titleLarge!.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children:
              policy.tags.map((label) => PolicyTag(label: label)).toList(),
        ),
      ],
    );
  }

  /// 상단 기간 강조 박스
  Widget _buildPeriodHighlight(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: scheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _buildPeriodText(),
              style: textTheme.bodyMedium!.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2×2 알림 옵션 Grid
  Widget _buildReminderGrid(
    BuildContext context, {
    required ReminderOption? selectedReminder,
    required bool isBusy,
    required Future<void> Function(ReminderOption option) onTap,
  }) {
    final options = [
      _ReminderTileConfig(
        label: '마감 하루 전',
        description: 'D-1',
        option: ReminderOption.oneDayBefore,
      ),
      _ReminderTileConfig(
        label: '마감 3일 전',
        description: 'D-3',
        option: ReminderOption.threeDaysBefore,
      ),
      _ReminderTileConfig(
        label: '마감 7일 전',
        description: 'D-7',
        option: ReminderOption.sevenDaysBefore,
      ),
      _ReminderTileConfig(
        label: '마감 당일',
        description: '마감날 아침',
        option: ReminderOption.onDueDate,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2; // 2열 + 가로 간격 12

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((cfg) {
            final isSelected = selectedReminder == cfg.option;
            return SizedBox(
              width: width,
              child: _ReminderTile(
                label: cfg.label,
                description: cfg.description,
                selected: isSelected,
                onTap: isBusy ? null : () => onTap(cfg.option),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _buildPeriodText() {
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
}

/// 알림 옵션 enum (UI 하이라이트용)
enum ReminderOption {
  oneDayBefore,
  threeDaysBefore,
  sevenDaysBefore,
  onDueDate,
}

extension ReminderOptionX on ReminderOption {
  ReminderTimeKind toKind() {
    switch (this) {
      case ReminderOption.oneDayBefore:
        return ReminderTimeKind.day1;
      case ReminderOption.threeDaysBefore:
        return ReminderTimeKind.day3;
      case ReminderOption.sevenDaysBefore:
        return ReminderTimeKind.day7;
      case ReminderOption.onDueDate:
        return ReminderTimeKind.dayOf;
    }
  }

  static ReminderOption fromTimeKind(ReminderTimeKind kind) {
    switch (kind) {
      case ReminderTimeKind.day1:
        return ReminderOption.oneDayBefore;
      case ReminderTimeKind.day3:
        return ReminderOption.threeDaysBefore;
      case ReminderTimeKind.day7:
        return ReminderOption.sevenDaysBefore;
      case ReminderTimeKind.dayOf:
        return ReminderOption.onDueDate;
    }
  }
}

/// 알림 타일 구성 정보
class _ReminderTileConfig {
  final String label;
  final String description;
  final ReminderOption option;

  const _ReminderTileConfig({
    required this.label,
    required this.description,
    required this.option,
  });
}

/// 알림 옵션 개별 타일 UI
class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.label,
    required this.description,
    required this.selected,
    this.onTap,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = selected ? scheme.primaryContainer : scheme.surfaceVariant;
    final borderColor = selected ? scheme.primary : scheme.outlineVariant;
    final labelColor = selected ? scheme.primary : scheme.onSurface;
    final descColor = selected ? scheme.primary : scheme.onSurfaceVariant;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodySmall!.copyWith(
                  color: descColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
