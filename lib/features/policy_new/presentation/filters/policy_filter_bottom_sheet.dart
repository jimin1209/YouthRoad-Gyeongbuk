import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/providers.dart';
import '../../domain/entities/department.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';

class PolicyFilterBottomSheet extends ConsumerWidget {
  const PolicyFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(policyFilterUiStateProvider);
    final notifier = ref.read(policyFilterUiStateProvider.notifier);
    final institutions = ref.watch(institutionListProvider);
    final departments = ui.institutionId == null
        ? const AsyncValue<List<Department>>.data([])
        : ref.watch(departmentListProvider(ui.institutionId!));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '필터',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: notifier.resetAll,
                    child: const Text('초기화'),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Text('지역'),
              Wrap(
                spacing: 8,
                children: PolicyRegion.values
                    .map(
                      (region) => ChoiceChip(
                        label: Text(region.name),
                        selected: ui.region == region,
                        onSelected: (_) => notifier.setRegion(region),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text('카테고리'),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('전체'),
                    selected: ui.category == null,
                    onSelected: (_) => notifier.setCategory(null),
                  ),
                  ...PolicyCategory.values.map(
                    (category) => ChoiceChip(
                      label: Text(category.name),
                      selected: ui.category == category,
                      onSelected: (_) => notifier.setCategory(category),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('기관'),
              const SizedBox(height: 8),
              institutions.when(
                data: (list) => DropdownButtonFormField<String?>(
                  value: ui.institutionId?.isEmpty == true ? null : ui.institutionId,
                  hint: const Text('기관을 선택하세요'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('전체')),
                    ...list.map(
                      (inst) => DropdownMenuItem<String?>(
                        value: inst.id,
                        child: Text(inst.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    final selected = value == null
                        ? null
                        : list.firstWhere((inst) => inst.id == value);
                    notifier.setInstitution(
                      id: value,
                      name: selected?.name,
                    );
                  },
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(),
                ),
                error: (err, __) => Text('기관 목록 불러오기 실패: $err'),
              ),
              const SizedBox(height: 12),
              const Text('부서'),
              const SizedBox(height: 8),
              departments.when(
                data: (list) => DropdownButtonFormField<String?>(
                  value: ui.departmentId?.isEmpty == true ? null : ui.departmentId,
                  hint: const Text('부서를 선택하세요'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('전체')),
                    ...list.map(
                      (dept) => DropdownMenuItem<String?>(
                        value: dept.id,
                        child: Text(dept.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    final selected = value == null
                        ? null
                        : list.firstWhere((dept) => dept.id == value);
                    notifier.setDepartment(
                      id: value,
                      name: selected?.name,
                    );
                  },
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(),
                ),
                error: (err, __) => Text('부서 목록 불러오기 실패: $err'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('온라인만 보기'),
                value: ui.showOnlyOnline,
                onChanged: (_) => notifier.toggleOnlineOnly(),
              ),
              SwitchListTile(
                title: const Text('모집중만 보기'),
                value: ui.showOnlyOngoing,
                onChanged: (_) => notifier.toggleOngoingOnly(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
