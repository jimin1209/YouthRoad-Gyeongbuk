import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/notifiers/department_notifier.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';

class DepartmentListScreen extends ConsumerStatefulWidget {
  const DepartmentListScreen({super.key, required this.instNo});

  final String instNo;

  @override
  ConsumerState<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends ConsumerState<DepartmentListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    ref.read(departmentNotifierProvider(widget.instNo).notifier).search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentNotifierProvider(widget.instNo));

    return Scaffold(
      appBar: AppAppBar(title: '부서 목록 (${widget.instNo})'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '부서명을 검색하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: state.when(
              data: (departments) {
                if (departments.isEmpty) {
                  return const Center(child: Text('등록된 부서가 없습니다.'));
                }
                return ListView.separated(
                  itemBuilder: (_, i) {
                    final dept = departments[i];
                    return ListTile(
                      title: Text(dept.deptName),
                      subtitle: Text('deptNo: ${dept.id}'),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: departments.length,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => GlobalErrorView(
                message: '불러오지 못했습니다. 다시 시도해 주세요.',
                onRetry: () => ref.invalidate(departmentNotifierProvider(widget.instNo)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
