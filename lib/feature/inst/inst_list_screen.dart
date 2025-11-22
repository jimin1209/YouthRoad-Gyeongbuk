import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../policy/policy_list_notifier.dart';
import 'inst_list_notifier.dart';

class InstListScreen extends ConsumerStatefulWidget {
  const InstListScreen({super.key});

  @override
  ConsumerState<InstListScreen> createState() => _InstListScreenState();
}

class _InstListScreenState extends ConsumerState<InstListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final insts = ref.watch(instListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('기관 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(instListProvider.notifier).fetch(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: '기관명을 입력하세요',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (value) => ref.read(instListProvider.notifier).setKeyword(value),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => ref.read(instListProvider.notifier).setKeyword(_searchController.text),
                  child: const Text('검색'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: insts.when(
                data: (list) => ListView.separated(
                  itemBuilder: (_, index) {
                    final inst = list[index];
                    return Card(
                      child: ListTile(
                        title: Text(inst.instNm ?? '기관명 없음'),
                        subtitle: Text('부서 수: ${inst.deptCnt ?? 0}'),
                        onTap: () {
                          final instNo = inst.no ?? '';
                          context.push('/inst/$instNo/dept/list');
                          ref.read(policyListNotifierProvider.notifier).setInstitutionFilter(instNo: instNo);
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
