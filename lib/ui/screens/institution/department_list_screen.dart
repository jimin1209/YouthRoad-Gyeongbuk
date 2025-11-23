import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../widgets/app_appbar.dart';

class DepartmentListScreen extends ConsumerStatefulWidget {
  const DepartmentListScreen({super.key, required this.instNo});

  final String instNo;

  @override
  ConsumerState<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends ConsumerState<DepartmentListScreen> {
  bool _loading = true;
  List departments = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = ref.read(institutionRepositoryProvider);
    final data = await repo.fetchDepartments(widget.instNo);
    setState(() {
      departments = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: '부서 목록 (${widget.instNo})'),
      body: Column(
        children: [
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, i) {
                final dept = departments[i];
                return ListTile(
                  title: Text(dept.name),
                  subtitle: Text('deptNo: ${dept.deptNo}'),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: departments.length,
            ),
          ),
        ],
      ),
    );
  }
}
