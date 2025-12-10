import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/policy_detail_controller.dart';
import '../../application/controllers/policy_query_override.dart';
import '../../application/providers.dart';
import '../../application/explore/explore_providers.dart';
import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/reexplore/policy_reexplore.dart';
import '../../domain/entities/policy.dart';
import '../../domain/values/policy_failure.dart';
import '../../domain/values/policy_feed_type.dart';
import '../widgets/policy_list_loading.dart';
import '../reminder/policy_reminder_button.dart';
import 'widgets/policy_action_bar.dart';
import '../explore/policy_explore_screen.dart';
import '../utils/policy_date_formatter.dart';
import '../../../../ui/components/app_section_title.dart';
import '../../../../ui/components/app_divider.dart';
import '../../../../ui/components/app_card.dart';
import '../../../../ui/theme/app_text.dart';
import '../../../../ui/theme/app_spacing.dart';
import '../../../../application/notifiers/region_notifier.dart';

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

  void _onReExplore(
    BuildContext context,
    Policy policy,
    PolicyReExploreMode mode,
  ) {
    var filter = ref
        .read(globalFilterProvider.notifier)
        .applyFromDetail(policy, mode, PolicyReExploreBuilder.buildFilter);

    filter = _normalizeRegionSelection(filter);

    final feedType = _feedTypeFor(filter);
    ref
        .read(policyQueryOverrideProvider(feedType).notifier)
        .applyFromDetail(
          policy: policy,
          mode: mode,
          feedType: feedType,
          filter: filter,
        );

    ref
        .read(exploreStateProvider.notifier)
        .applyFromDetail(filter: filter, mode: mode);

    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PolicyExploreScreen(),
      ),
    );
  }

  PolicyFilterUiState _normalizeRegionSelection(PolicyFilterUiState filter) {
    final regionNotifier = ref.read(regionProvider.notifier);
    final filterNotifier = ref.read(globalFilterProvider.notifier);
    final availableCities = regionNotifier.availableCities;
    final selectedProvince = regionNotifier.selectedProvince;

    final province = filter.province.trim();
    final city = filter.city?.trim() ?? '';
    final district = filter.district?.trim() ?? '';

    if (province != selectedProvince) {
      if (regionNotifier.selectedCity != null || regionNotifier.selectedDistrict != null) {
        regionNotifier.resetCity();
      }

      filterNotifier.setRegion(filter.region);
      return ref.read(globalFilterProvider);
    }

    if (city.isEmpty) {
      if (regionNotifier.selectedCity != null || regionNotifier.selectedDistrict != null) {
        regionNotifier.resetCity();
      }
      return ref.read(globalFilterProvider);
    }

    if (!availableCities.contains(city)) {
      regionNotifier.resetCity();
      return ref.read(globalFilterProvider);
    }

    if (regionNotifier.selectedCity != city) {
      regionNotifier.selectCity(city);
    }

    if (district.isNotEmpty && regionNotifier.availableDistricts.contains(district)) {
      if (regionNotifier.selectedDistrict != district) {
        regionNotifier.selectDistrict(district);
      }
    } else if (regionNotifier.selectedDistrict != null) {
      regionNotifier.selectDistrict(null);
    }

    return ref.read(globalFilterProvider);
  }

  PolicyFeedType _feedTypeFor(PolicyFilterUiState filter) {
    final regionNotifier = ref.read(regionProvider.notifier);
    final selectedProvince = regionNotifier.selectedProvince;
    final hasRegionSelection =
        filter.province.trim() == selectedProvince &&
        ((filter.city?.isNotEmpty ?? false) || (filter.district?.isNotEmpty ?? false));
    return hasRegionSelection ? PolicyFeedType.region : PolicyFeedType.all;
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
          child: SafeArea(
            top: true,
            bottom: false,
            child: asyncPolicy.when(
              data: (policy) => _Content(
                policy: policy,
                controller: scrollController,
                onReExplore: (mode) => _onReExplore(context, policy, mode),
              ),
              loading: () => const PolicyListLoading(),
              error: (err, __) => _ErrorView(
                error: err,
                onRetry: detailController.refresh,
              ),
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
    required this.onReExplore,
  });

  final Policy policy;
  final ScrollController controller;
  final ValueChanged<PolicyReExploreMode> onReExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dDay = _buildDDayLabel(policy);
    final hasSchedule =
        policy.applicationStartDate != null || policy.applicationEndDate != null;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
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
                const SizedBox(height: AppSpacing.xl),
                const AppDivider(),
                const SizedBox(height: AppSpacing.lg),
                _InfoSection(
                  title: '지원 대상',
                  content: _buildTargetText(policy),
                ),
                _InfoSection(
                  title: '신청 기간',
                  content: _buildPeriodText(policy, dDay: dDay),
                  badge: dDay != null
                      ? _DDayBadge(
                          label: '신청 마감 $dDay',
                          color: theme.colorScheme,
                        )
                      : null,
                ),
                _InfoSection(
                  title: '신청 방법',
                  content: policy.applyUrl.isNotEmpty
                      ? '온라인 신청 · ${policy.applyUrl}'
                      : '신청 방법 정보를 찾을 수 없습니다.',
                ),
                _InfoSection(
                  title: '문의처',
                  content: (policy.contact ?? '').isNotEmpty
                      ? policy.contact!
                      : '문의처 정보가 없습니다.',
                ),
                const SizedBox(height: AppSpacing.lg),
                _ReExploreSection(
                  policy: policy,
                  onSelect: onReExplore,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          bottom: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppDivider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PolicyActionBar(policy: policy),
                    const SizedBox(height: AppSpacing.md),
                    if (hasSchedule)
                      Row(
                        children: [
                          Expanded(
                            child: PolicyReminderButton(policy: policy),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('알림 설정'),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '일정 업데이트 되면 알려드릴게요',
                            style: AppText.textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
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

    if (targets.isEmpty) return '대상 정보를 찾을 수 없습니다.';
    return targets.join('\n');
  }

  static String _buildPeriodText(Policy policy, {String? dDay}) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;

    final baseRange =
        PolicyDateFormatter.formatRange(start: start, end: end);

    if (end == null) return baseRange;

    final deadline = PolicyDateFormatter.buildDeadlineText(
      end: end,
      dDayLabel: dDay,
    );

    if (start == null) {
      return deadline;
    }

    return '$baseRange\n$deadline';
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
              style: AppText.textTheme.bodyLarge?.copyWith(
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReExploreSection extends StatelessWidget {
  const _ReExploreSection({
    required this.policy,
    required this.onSelect,
  });

  final Policy policy;
  final ValueChanged<PolicyReExploreMode> onSelect;

  @override
  Widget build(BuildContext context) {
    final hasInstitution = (policy.institutionId ?? '').isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(title: '이 정책과 함께 보기'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '비슷한 정책이나 같은 기관·카테고리의 최신 정책을 이어서 탐색해보세요.',
            style: AppText.textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: () => onSelect(PolicyReExploreMode.similar),
            icon: const Icon(Icons.auto_awesome),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            label: const Text('비슷한 정책 더 보기'),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.tonalIcon(
            onPressed: () => onSelect(PolicyReExploreMode.category),
            icon: const Icon(Icons.category_outlined),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            label: const Text('같은 카테고리 최신 정책 보기'),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.tonalIcon(
            onPressed:
                hasInstitution ? () => onSelect(PolicyReExploreMode.institution) : null,
            icon: const Icon(Icons.apartment_outlined),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            label: Text(
              hasInstitution ? '같은 기관 정책 보기' : '기관 정보가 없습니다',
            ),
          ),
        ],
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
        : '정책 정보를 불러오는 중 알 수 없는 오류가 발생했어요.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('정책 정보를 불러오지 못했어요'),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppText.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
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
