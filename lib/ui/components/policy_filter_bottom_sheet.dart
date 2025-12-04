import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';

import 'policy_tag.dart';
import 'section_title.dart';

/// 필터 상태 모델 (UI 전용 DTO)
class PolicyFilterUiState {
  final bool onlyRecruiting;
  final bool onlyOnline;
  final Set<String> regions;
  final Set<String> categories;
  final Set<String> organizations;
  final Set<String> departments;

  const PolicyFilterUiState({
    this.onlyRecruiting = false,
    this.onlyOnline = false,
    this.regions = const {},
    this.categories = const {},
    this.organizations = const {},
    this.departments = const {},
  });

  PolicyFilterUiState copyWith({
    bool? onlyRecruiting,
    bool? onlyOnline,
    Set<String>? regions,
    Set<String>? categories,
    Set<String>? organizations,
    Set<String>? departments,
  }) {
    return PolicyFilterUiState(
      onlyRecruiting: onlyRecruiting ?? this.onlyRecruiting,
      onlyOnline: onlyOnline ?? this.onlyOnline,
      regions: regions ?? this.regions,
      categories: categories ?? this.categories,
      organizations: organizations ?? this.organizations,
      departments: departments ?? this.departments,
    );
  }

  bool get isEmpty =>
      !onlyRecruiting &&
      !onlyOnline &&
      regions.isEmpty &&
      categories.isEmpty &&
      organizations.isEmpty &&
      departments.isEmpty;
}

/// 필터 옵션 집합 (실제 데이터는 상위에서 주입)
class PolicyFilterOptions {
  final List<String> regions;
  final List<String> categories;
  final List<String> organizations;
  final List<String> departments;

  const PolicyFilterOptions({
    required this.regions,
    required this.categories,
    required this.organizations,
    required this.departments,
  });
}

/// 필터 BottomSheet 공용 엔트리 함수
Future<PolicyFilterUiState?> showPolicyFilterBottomSheet({
  required BuildContext context,
  required PolicyFilterUiState initialState,
  required PolicyFilterOptions options,
}) async {
  final result = await showModalBottomSheet<PolicyFilterUiState>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        initialChildSize: 0.8,
        builder: (context, scrollController) {
          return PolicyFilterBottomSheet(
            initialState: initialState,
            options: options,
            scrollController: scrollController,
          );
        },
      );
    },
  );

  return result;
}

/// 정책 필터 BottomSheet 본문
class PolicyFilterBottomSheet extends StatefulWidget {
  final PolicyFilterUiState initialState;
  final PolicyFilterOptions options;
  final ScrollController? scrollController;

  const PolicyFilterBottomSheet({
    super.key,
    required this.initialState,
    required this.options,
    this.scrollController,
  });

  @override
  State<PolicyFilterBottomSheet> createState() =>
      _PolicyFilterBottomSheetState();
}

class _PolicyFilterBottomSheetState extends State<PolicyFilterBottomSheet> {
  late PolicyFilterUiState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  void _toggleRegion(String value) {
    setState(() {
      final next = Set<String>.from(_state.regions);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(regions: next);
    });
  }

  void _toggleCategory(String value) {
    setState(() {
      final next = Set<String>.from(_state.categories);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(categories: next);
    });
  }

  void _toggleOrganization(String value) {
    setState(() {
      final next = Set<String>.from(_state.organizations);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(organizations: next);
    });
  }

  void _toggleDepartment(String value) {
    setState(() {
      final next = Set<String>.from(_state.departments);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(departments: next);
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop(_state);
  }

  void _resetFilters() {
    setState(() {
      _state = const PolicyFilterUiState();
    });
  }

  void _removeSelectedFilter(String label) {
    setState(() {
      if (label == '모집 중') {
        _state = _state.copyWith(onlyRecruiting: false);
        return;
      }
      if (label == '온라인 신청') {
        _state = _state.copyWith(onlyOnline: false);
        return;
      }

      final regions = Set<String>.from(_state.regions)..remove(label);
      final categories = Set<String>.from(_state.categories)..remove(label);
      final organizations = Set<String>.from(_state.organizations)..remove(label);
      final departments = Set<String>.from(_state.departments)..remove(label);

      _state = _state.copyWith(
        regions: regions,
        categories: categories,
        organizations: organizations,
        departments: departments,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final policyTheme = Theme.of(context).extension<PolicyTheme>()!;

    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // 헤더
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  Text(
                    '필터',
                    style: textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // 본문 스크롤 영역
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 선택된 필터 요약
                    _buildSelectedFiltersSummary(context),

                    const SizedBox(height: 16),

                    // 토글 그룹
                    const SectionTitle(title: '모집 상태'),
                    const SizedBox(height: 8),
                    _buildToggleGroup(context),

                    const SizedBox(height: 20),

                    // 지역
                    const SectionTitle(title: '지역'),
                    const SizedBox(height: 8),
                    _buildFilterChipGroup(
                      values: widget.options.regions,
                      selected: _state.regions,
                      onTap: _toggleRegion,
                    ),

                    const SizedBox(height: 20),

                    // 카테고리
                    const SectionTitle(title: '카테고리'),
                    const SizedBox(height: 8),
                    _buildFilterChipGroup(
                      values: widget.options.categories,
                      selected: _state.categories,
                      onTap: _toggleCategory,
                    ),

                    const SizedBox(height: 20),

                    // 주관 기관
                    const SectionTitle(title: '주관 기관'),
                    const SizedBox(height: 8),
                    _buildFilterChipGroup(
                      values: widget.options.organizations,
                      selected: _state.organizations,
                      onTap: _toggleOrganization,
                    ),

                    const SizedBox(height: 20),

                    // 담당 부서
                    const SectionTitle(title: '담당 부서'),
                    const SizedBox(height: 8),
                    _buildFilterChipGroup(
                      values: widget.options.departments,
                      selected: _state.departments,
                      onTap: _toggleDepartment,
                    ),

                    const SizedBox(height: 24),
                    SizedBox(height: policyTheme?.policyCardPadding.bottom ?? 0),
                  ],
                ),
              ),
            ),

            // 하단 버튼 영역
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              decoration: BoxDecoration(
                color: scheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _state.isEmpty ? null : _resetFilters,
                    child: const Text('초기화'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: const Text('필터 적용'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFiltersSummary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final items = <String>[];

    if (_state.onlyRecruiting) items.add('모집 중');
    if (_state.onlyOnline) items.add('온라인 신청');
    items.addAll(_state.regions);
    items.addAll(_state.categories);
    items.addAll(_state.organizations);
    items.addAll(_state.departments);

    if (items.isEmpty) {
      return Text(
        '선택된 필터가 없습니다. 조건을 선택해보세요.',
        style: textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '선택된 필터',
          style: textTheme.bodySmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: items
              .map(
                (label) => _SelectedFilterPill(
                  label: label,
                  onRemove: () => _removeSelectedFilter(label),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildToggleGroup(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget buildToggle({
      required String label,
      required bool value,
      required ValueChanged<bool> onChanged,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(!value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value ? scheme.primary : scheme.outlineVariant,
            ),
            color: value
                ? scheme.primaryContainer
                : scheme.surfaceVariant,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: textTheme.bodyMedium!.copyWith(
                  color: value
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        buildToggle(
          label: '모집 중인 정책만',
          value: _state.onlyRecruiting,
          onChanged: (v) {
            setState(() {
              _state = _state.copyWith(onlyRecruiting: v);
            });
          },
        ),
        buildToggle(
          label: '온라인 신청 가능',
          value: _state.onlyOnline,
          onChanged: (v) {
            setState(() {
              _state = _state.copyWith(onlyOnline: v);
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterChipGroup({
    required List<String> values,
    required Set<String> selected,
    required ValueChanged<String> onTap,
  }) {
    if (values.isEmpty) {
      return const Text(
        '선택 가능한 항목이 없습니다.',
        style: TextStyle(fontSize: 12),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => _FilterChip(
              label: value,
              selected: selected.contains(value),
              onTap: () => onTap(value),
            ),
          )
          .toList(),
    );
  }
}

/// 필터 선택용 Chip
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor =
        selected ? scheme.primaryContainer : scheme.surfaceVariant;
    final borderColor =
        selected ? scheme.primary : scheme.outlineVariant;
    final textColor =
        selected ? scheme.primary : scheme.onSurfaceVariant;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            label,
            style: textTheme.bodySmall!.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

/// 선택된 필터 Pill
class _SelectedFilterPill extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SelectedFilterPill({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: textTheme.bodySmall!.copyWith(
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
