import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/controllers/global_filter_controller.dart';
import '../../application/providers.dart';
import '../../application/controllers/ui_reaction_controller.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/institution.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_status_filter.dart';
import '../../../../application/notifiers/region_notifier.dart';
import 'widgets/region_selector_section.dart';

class PolicyFilterBottomSheet extends ConsumerStatefulWidget {
  const PolicyFilterBottomSheet({
    super.key,
    required this.feedType,
  });

  final PolicyFeedType feedType;

  @override
  ConsumerState<PolicyFilterBottomSheet> createState() =>
      _PolicyFilterBottomSheetState();
}

class _PolicyFilterBottomSheetState
    extends ConsumerState<PolicyFilterBottomSheet> {
  late PolicyRegion _region;
  PolicyCategory? _category;
  bool _showOnlyOnline = false;
  PolicyStatusFilter _status = PolicyStatusFilter.includeClosed;
  String? _institutionId;
  String? _institutionName;
  String? _departmentId;
  String? _departmentName;
  ProviderSubscription<String?>? _regionSubscription;

  @override
  void initState() {
    super.initState();
    final ui = ref.read(globalFilterProvider);
    _region = ui.region;
    _category = ui.category;
    _showOnlyOnline = ui.showOnlyOnline;
    _status = ui.status;
    _institutionId = ui.institutionId?.isEmpty == true ? null : ui.institutionId;
    _institutionName = ui.institutionName;
    _departmentId = ui.departmentId?.isEmpty == true ? null : ui.departmentId;
    _departmentName = ui.departmentName;
    _regionSubscription = ref.listenManual<String?>(
      regionProvider,
      (_, __) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _regionSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final institutions = ref.watch(institutionListProvider);
    final departments = _institutionId == null
        ? const AsyncValue<List<Department>>.data([])
        : ref.watch(departmentListProvider(_institutionId!));

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Text(
                          '필터',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SelectedFiltersSummary(
                            items: _buildSelectedItems(),
                            onRemove: _removeSelectedFilter,
                          ),
                          const SizedBox(height: 20),
                          Text('모집 상태',
                              style: textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          _buildToggleGroup(context),
                          const SizedBox(height: 20),
                          Text('지역',
                              style: textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          const RegionSelectorSection(),
                          const SizedBox(height: 20),
                          Text('카테고리',
                              style: textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          _buildFilterChipGroup<PolicyCategory?>(
                            values: [null, ...PolicyCategory.values],
                            labelBuilder: _categoryLabel,
                            isSelected: (category) => category == _category,
                            onTap: (category) {
                              setState(() => _category = category);
                            },
                          ),
                          const SizedBox(height: 20),
                          Text('주관 기관',
                              style: textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          institutions.when(
                            data: (list) => _buildInstitutionChips(list),
                            loading: () => const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: LinearProgressIndicator(),
                            ),
                            error: (err, __) => Text('기관 목록 불러오기 실패: $err'),
                          ),
                          const SizedBox(height: 20),
                          Text('담당 부서',
                              style: textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          departments.when(
                            data: (list) => _buildDepartmentChips(list),
                            loading: () => const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: LinearProgressIndicator(),
                            ),
                            error: (err, __) =>
                                Text('부서 목록 불러오기 실패: $err'),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: scheme.shadow.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetFilters,
                            child: const Text('초기화'),
                          ),
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
          ),
        );
      },
    );
  }

  List<_SelectedFilterItem> _buildSelectedItems() {
    final items = <_SelectedFilterItem>[];

    if (_status == PolicyStatusFilter.inProgressOnly) {
      items.add(const _SelectedFilterItem(
        label: '모집 중',
        type: _FilterType.status,
      ));
    } else if (_status == PolicyStatusFilter.closedOnly) {
      items.add(const _SelectedFilterItem(
        label: '마감된 정책',
        type: _FilterType.status,
      ));
    }

    if (_showOnlyOnline) {
      items.add(const _SelectedFilterItem(
        label: '온라인 신청 가능',
        type: _FilterType.online,
      ));
    }

    final regionSummary = ref.read(regionProvider.notifier).summary;
    items.add(_SelectedFilterItem(
      label: regionSummary,
      type: _FilterType.region,
    ));

    if (_category != null) {
      items.add(_SelectedFilterItem(
        label: _categoryLabel(_category),
        type: _FilterType.category,
      ));
    }

    if (_institutionId != null && _institutionName?.isNotEmpty == true) {
      items.add(_SelectedFilterItem(
        label: _institutionName!,
        type: _FilterType.institution,
      ));
    }

    if (_departmentId != null && _departmentName?.isNotEmpty == true) {
      items.add(_SelectedFilterItem(
        label: _departmentName!,
        type: _FilterType.department,
      ));
    }

    return items;
  }

  void _removeSelectedFilter(_FilterType type) {
    setState(() {
      switch (type) {
        case _FilterType.status:
          _status = PolicyStatusFilter.includeClosed;
          break;
        case _FilterType.online:
          _showOnlyOnline = false;
          break;
        case _FilterType.region:
          ref.read(regionProvider.notifier).resetCity();
          _region = PolicyRegion.gyeongbuk;
          break;
        case _FilterType.category:
          _category = null;
          break;
        case _FilterType.institution:
          _institutionId = null;
          _institutionName = null;
          _departmentId = null;
          _departmentName = null;
          break;
        case _FilterType.department:
          _departmentId = null;
          _departmentName = null;
          break;
      }
    });
  }

  Widget _buildToggleGroup(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _ToggleChip(
          label: '모집 중인 정책만',
          value: _status == PolicyStatusFilter.inProgressOnly,
          onChanged: (value) {
            setState(() {
              _status = value
                  ? PolicyStatusFilter.inProgressOnly
                  : PolicyStatusFilter.includeClosed;
            });
          },
        ),
        _ToggleChip(
          label: '마감된 정책만',
          value: _status == PolicyStatusFilter.closedOnly,
          onChanged: (value) {
            setState(() {
              _status = value
                  ? PolicyStatusFilter.closedOnly
                  : PolicyStatusFilter.includeClosed;
            });
          },
        ),
        _ToggleChip(
          label: '온라인 신청 가능',
          value: _showOnlyOnline,
          onChanged: (value) {
            setState(() => _showOnlyOnline = value);
          },
        ),
      ],
    );
  }

  Widget _buildFilterChipGroup<T>({
    required List<T> values,
    required String Function(T value) labelBuilder,
    required bool Function(T value) isSelected,
    required ValueChanged<T> onTap,
  }) {
    if (values.isEmpty) {
      return const Text('선택 가능한 항목이 없습니다.',
          style: TextStyle(fontSize: 12));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => _FilterChip(
              label: labelBuilder(value),
              selected: isSelected(value),
              onTap: () => onTap(value),
            ),
          )
          .toList(),
    );
  }

  Widget _buildInstitutionChips(List<Institution> list) {
    final values = [null, ...list];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((inst) {
        final selected = inst?.id == _institutionId ||
            (inst == null && _institutionId == null);
        return _FilterChip(
          label: inst?.name ?? '전체',
          selected: selected,
          onTap: () => setState(() {
            _institutionId = inst?.id;
            _institutionName = inst?.name;
            _departmentId = null;
            _departmentName = null;
          }),
        );
      }).toList(),
    );
  }

  Widget _buildDepartmentChips(List<Department> list) {
    if (_institutionId == null) {
      return const Text('기관을 먼저 선택하세요.',
          style: TextStyle(fontSize: 12));
    }

    final values = [null, ...list];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((dept) {
        final selected = dept?.id == _departmentId ||
            (dept == null && _departmentId == null);
        return _FilterChip(
          label: dept?.name ?? '전체',
          selected: selected,
          onTap: () => setState(() {
            _departmentId = dept?.id;
            _departmentName = dept?.name;
          }),
        );
      }).toList(),
    );
  }

  void _resetFilters() {
    ref.read(globalFilterControllerProvider).resetAll();
    ref.read(regionProvider.notifier).resetCity();
    setState(() {
      _region = PolicyRegion.gyeongbuk;
      _category = null;
      _showOnlyOnline = false;
      _status = PolicyStatusFilter.includeClosed;
      _institutionId = null;
      _institutionName = null;
      _departmentId = null;
      _departmentName = null;
    });
    _notifyReaction('필터가 초기화됐어요.');
  }

  void _applyFilters() {
    final notifier = ref.read(globalFilterProvider.notifier);
    final current = ref.read(globalFilterProvider);
    var hasChanged = false;

    if (current.region != _region) {
      notifier.setRegion(_region);
      hasChanged = true;
    }

    if (current.category != _category) {
      notifier.setCategory(_category);
      hasChanged = true;
    }

    if (current.showOnlyOnline != _showOnlyOnline) {
      notifier.toggleOnlineOnly();
      hasChanged = true;
    }

    if (current.status != _status) {
      notifier.setStatus(_status);
      hasChanged = true;
    }

    if (current.institutionId != _institutionId ||
        current.institutionName != _institutionName) {
      notifier.setInstitution(id: _institutionId, name: _institutionName);
      hasChanged = true;
    }

    if (current.departmentId != _departmentId ||
        current.departmentName != _departmentName) {
      notifier.setDepartment(id: _departmentId, name: _departmentName);
      hasChanged = true;
    }

    Navigator.of(context).pop();
    _notifyReaction(hasChanged
        ? '필터가 적용됐어요. 결과를 새로 불러옵니다.'
        : '변경된 조건이 없어요.');
  }

  String _regionLabel(PolicyRegion region) {
    switch (region) {
      case PolicyRegion.all:
        return '전체';
      case PolicyRegion.seoul:
        return '서울';
      case PolicyRegion.busan:
        return '부산';
      case PolicyRegion.daegu:
        return '대구';
      case PolicyRegion.incheon:
        return '인천';
      case PolicyRegion.gwangju:
        return '광주';
      case PolicyRegion.daejeon:
        return '대전';
      case PolicyRegion.ulsan:
        return '울산';
      case PolicyRegion.gyeongbuk:
        return '경북';
    }
  }

  String _categoryLabel(PolicyCategory? category) {
    switch (category) {
      case null:
        return '전체';
      case PolicyCategory.employment:
        return '취업';
      case PolicyCategory.startup:
        return '창업';
      case PolicyCategory.housing:
        return '주거';
      case PolicyCategory.life:
        return '생활';
      case PolicyCategory.education:
        return '교육';
      case PolicyCategory.welfare:
        return '복지';
      case PolicyCategory.culture:
        return '문화';
      case PolicyCategory.other:
        return '기타';
    }
  }

  void _notifyReaction(String summary) {
    ref
        .read(uiReactionControllerProvider(widget.feedType).notifier)
        .markFilterConfirmed(summary);
  }
}

class _SelectedFiltersSummary extends StatelessWidget {
  const _SelectedFiltersSummary({
    required this.items,
    required this.onRemove,
  });

  final List<_SelectedFilterItem> items;
  final ValueChanged<_FilterType> onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          style:
              textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => _SelectedFilterPill(
                  label: item.label,
                  onRemove: () => onRemove(item.type),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: value ? scheme.primaryContainer : scheme.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onChanged(!value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: value ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: value,
                onChanged: (_) => onChanged(!value),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: value ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedFilterPill extends StatelessWidget {
  const _SelectedFilterPill({
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

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
            style: textTheme.bodySmall?.copyWith(color: scheme.primary),
          ),
          const SizedBox(width: 6),
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

class _SelectedFilterItem {
  const _SelectedFilterItem({
    required this.label,
    required this.type,
  });

  final String label;
  final _FilterType type;
}

enum _FilterType {
  status,
  online,
  region,
  category,
  institution,
  department,
}
