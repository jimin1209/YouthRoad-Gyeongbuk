import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/institution_summary.dart';
import '../../widgets/app_appbar.dart';

class InstitutionListScreen extends ConsumerStatefulWidget {
  const InstitutionListScreen({super.key});

  @override
  ConsumerState<InstitutionListScreen> createState() => _InstitutionListScreenState();
}

class _InstitutionListScreenState extends ConsumerState<InstitutionListScreen> {
  final TextEditingController _controller = TextEditingController();
  List<InstitutionSummary> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load([String? keyword]) async {
    setState(() => _loading = true);
    final repo = ref.read(institutionRepositoryProvider);
    final data = await repo.fetchInstitutions(keyword: keyword);
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '기관 목록'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '기관명을 검색하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _load(_controller.text),
                ),
              ),
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, i) {
                final inst = _items[i];
                return ListTile(
                  title: Text(inst.name),
                  subtitle: Text('instNo: ${inst.instNo}'),
                  onTap: () =>
                      context.push('/inst/${inst.instNo}/dept/list'),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: _items.length,
            ),
          ),
        ],
      ),
    );
  }
}
