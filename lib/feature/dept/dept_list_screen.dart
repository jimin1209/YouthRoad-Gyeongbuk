import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../policy/policy_list_notifier.dart';
import 'dept_list_notifier.dart';

class DeptListScreen extends ConsumerWidget {
  const DeptListScreen({super.key, required this.instNo});

  final String instNo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depts = ref.watch(deptListProvider(instNo));

    return Scaffold(
      appBar: AppBar(
        title: Text('부서 목록 ($instNo)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: depts.when(
          data: (list) => ListView.separated(
            itemBuilder: (_, index) {
              final dept = list[index];
              return Card(
                child: ListTile(
                  title: Text(dept.deptNm ?? '부서명 없음'),
                  subtitle: Text(dept.instNm ?? ''),
                  onTap: () {
                    ref.read(policyListNotifierProvider.notifier).setInstitutionFilter(
                          instNo: instNo,
                          deptNo: dept.no,
                        );
                    context.go('/policy/list');
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: list.length,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('불러오지 못했습니다: $e')),
        ),
      ),
    );
  }
}
